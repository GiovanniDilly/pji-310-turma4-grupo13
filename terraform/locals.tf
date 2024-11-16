locals {
#   lambdas_path = "${path.module}/../app/lambdas"
#   layers_path  = "${path.module}/../app/layers/nodejs"
#   layer_name   = "joi.zip"

  common_tags = {
    Project   = "PJI 240 - Avul"
    CreatedAt = "2024-11-16"
    ManagedBy = "Terraform"
    Owner     = "PJI 240 Turma 5 Grupo 21"
    Service   = var.service_name
  }
}
