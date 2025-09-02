locals {
  tag = var.tagtodeploy != "" ? var.tagtodeploy : var.repository_tag
  package_file = jsondecode(file("${path.module}/../../package.json"))
  projectversion = "v${substr(local.package_file.version,0 , 1)}"

  hostname =  var.environment == "prod" ? "membresias.az.nebrija.es" : "membresias${var.environment}.az.nebrija.es"
  domain = join(".", slice(split(".", local.hostname), length(split(".", local.hostname))-3, length(split(".", local.hostname)))) 

  config_variables = {
    VUE_APP_API_UNNE="",
    VUE_APP_API_UXXI="",
    environment="${var.environment}",
    project = "membresiasfront",
    backendServiceArmTR = "NebrijaPro",
    backendAzureRmContainerName = "nebtrstate",
    backendAzureRmStorageAccountName = "nebtr",
    backendAzureRmKey = "k8s-${var.project}.tfstate",
    backendAzureRmResourceGroupName = var.rg_devops["prod"]
    backendAzureRmSubscriptionId = var.prod_sub_id
    backendServiceArm = var.environment == "prod" ? "NebrijaPro" : "NebrijaDev/Test",
  }

  var_groupname = {
    "prod" = "MEMBRESIASFRONT_PROD",
    "testpre" = "MEMBRESIASFRONT_TESTPRE",
    "develop" = "MEMBRESIASFRONT_DEV",
    "other" = "MEMBRESIASFRONT_OTHER",
  }
}


data "terraform_remote_state" "entraid" {
  backend = "azurerm"
  config = {
    storage_account_name = "nebtr"
    container_name       = "nebtrstate"
    key                  = "apidevops.tfstate"
    resource_group_name  =  "DEVOPS_PROD"
    subscription_id      = "c242e182-fb5f-4bcc-8566-c34d558833ca"
  }
  workspace = var.environment == "other" ? "testpre" : var.environment
}

resource "local_file" "env" {
 content = templatefile("${path.cwd}/../../.env.template",
           { 
               TENANT_ID = "da301890-cd7c-4f36-bd78-310740100a5a"
               VUE_APP_CLIENT_ID = data.terraform_remote_state.entraid.outputs.membresiasfront_client_id
               VUE_APP_SCOPE = "api://${data.terraform_remote_state.entraid.outputs.membresiasback_client_id}/.default openid offline_access"
               VUE_APP_SCOPE_BACK = "api://${data.terraform_remote_state.entraid.outputs.membresiasback_client_id}/BackendUser api://${data.terraform_remote_state.entraid.outputs.membresiasback_client_id}/.default"
               VUE_APP_REDIRECT = "https://${local.hostname}"
               VUE_APP_SCOPE_UNNE = "api://${data.terraform_remote_state.entraid.outputs.frontalunne_client_id}/.default openid offline_access"
               VUE_APP_SCOPE_UNNE_BACK = "api://${data.terraform_remote_state.entraid.outputs.frontalunne_client_id}/FrontalUNNEUser api://${data.terraform_remote_state.entraid.outputs.frontalunne_client_id}/.default"
               VUE_APP_SCOPE_UXXI = "api://${data.terraform_remote_state.entraid.outputs.frontaluxxi_client_id}/.default openid offline_access"
               VUE_APP_SCOPE_UXXI_BACK = "api://${data.terraform_remote_state.entraid.outputs.frontaluxxi_client_id}/FrontalUXXIUser api://${data.terraform_remote_state.entraid.outputs.frontaluxxi_client_id}/.default"
               VUE_APP_API_UNNE = try([for s in nonsensitive(azuredevops_variable_group.vargroup.variable) : s.value if s.name == "VUE_APP_API_UNNE" ][0], "")
               VUE_APP_API_UXXI = try([for s in nonsensitive(azuredevops_variable_group.vargroup.variable) : s.value if s.name == "VUE_APP_API_UXXI" ][0], "")
               VUE_APP_API_GRP = "https://${var.environment == "prod" ? "membresiasback.az.nebrija.es" : "membresiasback${var.environment}.az.nebrija.es"}"
           }
          )
  filename = "${path.cwd}/../../.env.production"

  depends_on = [
    azuredevops_variable_group.vargroup
  ]

}

data "azurerm_resource_group" "rgcomun" {
  name     = "${var.rg_devops[var.environment]}_${var.environment}"
}

data "azurerm_container_registry" "acr" {
  name                = "arcnebrija${var.environment}"
  resource_group_name = data.azurerm_resource_group.rgcomun.name
}

data "azurerm_subnet" "CAPPS" {
  name                 = "${var.subnet}"
  virtual_network_name = "${var.environment == "prod" ? var.vnet_devops[var.environment] :var.vnet_general[var.environment]}"
  resource_group_name  = "${var.environment == "prod" ? var.rg_devops[var.environment] :var.rg_general[var.environment]}"
}


data "azurerm_application_gateway" "appgw" {
  name                = reverse(split("/", data.azurerm_kubernetes_cluster.k8s.ingress_application_gateway[0].effective_gateway_id))[0]
  resource_group_name = data.azurerm_kubernetes_cluster.k8s.node_resource_group
}

data "azurerm_public_ip" "appgw" {
  name                = "${data.azurerm_application_gateway.appgw.name}-appgwpip"
  resource_group_name = data.azurerm_kubernetes_cluster.k8s.node_resource_group
}

data "azurerm_resource_group" "rg_devops" {
  name     = "${var.rg_devops[var.environment]}"
}

data "azurerm_resource_group" "rg_devops_prod" {
  provider = azurerm.prod
  name     = "${var.rg_devops["prod"]}"
}

data "azurerm_dns_zone" "az" {
  provider = azurerm.prod
  name                = local.domain
  resource_group_name = data.azurerm_resource_group.rg_devops_prod.name
}

resource "azurerm_dns_a_record" "appgw" {
  provider = azurerm.prod
  name                = split(".", local.hostname)[0]
  zone_name           = data.azurerm_dns_zone.az.name
  resource_group_name = data.azurerm_resource_group.rg_devops_prod.name
  ttl                 = 300
  records             = [ data.azurerm_public_ip.appgw.ip_address ]
}

# --- DevOps


data "azuredevops_project" "app" {
  name = "GestorMembresias"
}

resource "azuredevops_variable_group" "vargroup" {
  project_id   = data.azuredevops_project.app.id
  name         = local.var_groupname[var.environment]
  description  = local.var_groupname[var.environment]
  allow_access = true

  dynamic "variable" {
    for_each = local.config_variables

    content {
      name = variable.key
      value = variable.value
    }
  }

  lifecycle {
    ignore_changes = [ variable ]
  }  
}


data "external" "content_nginx" {
  program = ["${path.cwd}/bin/dirhash_nginx.sh"]

  depends_on = [
    local_file.env
  ]
}

resource "docker_image" "nginx" {
  name = "${data.azurerm_container_registry.acr.login_server}/${var.repository}-nginx:${substr(data.external.content_nginx.result["checksum"],0,5)}"
  keep_locally = false
  
  build {
#    no_cache = true
    context = "${path.cwd}/../.."
    dockerfile = "nginx-prod.dockerfile"
  }

  triggers = {
    dir_sha1 = "${data.external.content_nginx.result["checksum"]}"
  }
  depends_on = [
    local_file.env
    ,data.external.content_nginx
  ]
}

resource "docker_registry_image" "nginx" {
  name          = docker_image.nginx.name
  keep_remotely = true
  
  triggers = {
    dir_sha1 = docker_image.nginx.id
  } 

  depends_on  = [
    docker_image.nginx
    ,local_file.env
  ]
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "${var.project}-${var.environment}"
    annotations = {
      "k8tz.io/inject"= "true",
      "k8tz.io/timezone"= "Europe/Madrid",
    }
    labels = {
      app = "${var.project}-${var.environment}"
    }
  }
  spec {
    replicas = var.environment == "prod" ? 2 : 1
    selector {
      match_labels = {
        app = "${var.project}-${var.environment}"
      }
    }
    template {
      metadata {
        labels = {
          app = "${var.project}-${var.environment}"
        }
      }
      spec {
        container {
          name = "nginx"
          image = "${data.azurerm_container_registry.acr.login_server}/${var.repository}-nginx:${substr(data.external.content_nginx.result["checksum"],0,5)}"
          resources {
                limits = {
                    cpu    = "1"
                    memory = "1Gi"
                }
                requests = {
                    cpu    = "500m"
                    memory = "1.5Mi"
                }
          }
          port {
              container_port = 443
          }
        }
        dns_config {
          searches = [ "rednebrija.nebrija.es" ]
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      spec[0].template[0].spec[0].container[0].volume_mount,
      spec[0].template[0].spec[0].init_container,
      spec[0].template[0].spec[0].volume,
     ]
  }

  depends_on = [ 
      docker_registry_image.nginx
    ]
}

resource "kubernetes_service_v1" "app" {
  metadata {
    name = "${var.project}-${var.environment}-srv"
  }
  spec {
    selector = {
      app = kubernetes_deployment.app.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 443
      target_port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "ingress_app" {
  metadata {
    name = "${var.project}-${var.environment}-in"
    annotations = {
        "kubernetes.io/ingress.class" = "azure/application-gateway"
        "appgw.ingress.kubernetes.io/ssl-redirect" = "true"
#        "appgw.ingress.kubernetes.io/override-frontend-port" = "443"
        "appgw.ingress.kubernetes.io/health-probe-port" = "80"
        "appgw.ingress.kubernetes.io/health-probe-path" = "/"
        "cert-manager.io/cluster-issuer" = "${var.environment == "prod" ? "letsencrypt-production" : "letsencrypt-production"}"
    }
  }

  spec {

    rule {
      host = local.hostname
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.app.metadata.0.name
              port {
                number = 80
              }
            }
          }

          path = "/"
        }
      }
    }

    tls {
      hosts       = [ "${local.hostname}" ]
      secret_name = "${var.environment}-${var.project}-secret"
    }
  }
}
