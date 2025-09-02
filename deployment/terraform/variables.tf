variable "PAT" {
  type = string
  description = "PAT de Azure DevOps"
  default = ""
}

variable "rg_devops" {
  type = map(string)
  default = {
    "prod" = "DEVOPS_PROD",
    "testpre" = "DEVOPS_DEVTEST",
    "develop" = "DEVOPS_DEVTEST",
    "other" = "DEVOPS_DEVTEST",
  }
}

variable "vnet_general" {
  type = map(string)
  default = {
    "prod" = "NebrijaNet",
    "testpre" = "AzureNEBRIJANet",
    "develop" = "AzureNEBRIJANet",
    "other" = "AzureNEBRIJANet",
  }
}

variable "vnet_devops" {
  type = map(string)
  default = {
    "prod" = "NebrijaDevOpsProd",
    "testpre" = "AzureNEBRIJANet",
    "develop" = "AzureNEBRIJANet",
    "other" = "AzureNEBRIJANet",
  }
}

variable "rg_general" {
  type = map(string)
  default = {
    "prod" = "NebrijaBI",
    "testpre" = "SolidQ",
    "develop" = "SolidQ",
    "other" = "SolidQ",
  }
}

variable "subnet" {
  type        = string
  description = "subnet"
  default ="CAPPS"
}

variable "repository" {
  type        = string
  description = "Repository"
}

variable "tagtodeploy" {
  type        = string
  description = "branch"
  default = ""
}

variable "repository_tag" {
  type        = string
  description = "Default tag to deploy"
  default = "latest"
}

variable "project" {
  description = "The project name"
  default     = "membresiasfront"
}

variable "environment" {
  description = "The project environment"
  default     = "dev"
}

variable "tags_extra" {
  type        = map(string)
  description = "Extra tags that should be applied to all resources"
  default     = {}
}


variable "dev_sub_id" {
  type = string
  description = "Identificador de la suscripcion de produccion"
  default = "dc5ccce8-12e9-452d-86d2-19c5d2efc1dc"
}

variable "prod_sub_id" {
  type = string
  description = "Identificador de la suscripcion de desarrollo"
  default = "c242e182-fb5f-4bcc-8566-c34d558833ca"
}

variable "tenant_id" {
  type = string
  description = "Identificador del tenant"
  default = "da301890-cd7c-4f36-bd78-310740100a5a"
}
