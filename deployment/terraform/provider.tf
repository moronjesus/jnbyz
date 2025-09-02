provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id = var.environment == "prod" ? var.prod_sub_id : var.dev_sub_id
}


provider "azurerm" {
  alias = "dev"
  subscription_id = var.dev_sub_id
  features {}
  skip_provider_registration = true
}

provider "azurerm" {
  alias = "prod"
  subscription_id = var.prod_sub_id
  features {}
  skip_provider_registration = true
}

data "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.environment}-aks"
  resource_group_name = data.azurerm_resource_group.rgcomun.name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.k8s.kube_admin_config.0.host
  username               = data.azurerm_kubernetes_cluster.k8s.kube_admin_config.0.username
  password               = data.azurerm_kubernetes_cluster.k8s.kube_admin_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.k8s.kube_admin_config.0.cluster_ca_certificate)
}

terraform {
  backend "azurerm" {
    resource_group_name  = "DEVOPS_PROD"
    storage_account_name = "nebtr"
    container_name       = "nebtrstate"
    key                  = "k8s-membresiasfront.tfstate"
    subscription_id      = "c242e182-fb5f-4bcc-8566-c34d558833ca"
    # # access_key = "abcdefghijklmnopqrstuvwxyz0123456789..."
    # # sas_token = "abcdefghijklmnopqrstuvwxyz0123456789..."
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.23.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.36.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "1.8.1"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}

provider "docker" {
  registry_auth {
    address  = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/NEBRIJA"
  personal_access_token = var.PAT
}
