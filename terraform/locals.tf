locals {
  lambdas_path = "${path.module}/../lambdas/logica"
  layers_path  = "${path.module}/../lambdas/layers/nodejs"
  #   layer_name   = "joi.zip"

  common_tags = {
    Project   = "PJI 240 - Avul"
    CreatedAt = "2024-11-16"
    ManagedBy = "Terraform"
    Owner     = "PJI 240 Turma 5 Grupo 21"
    Service   = var.service_name
  }
}
