locals {
  lambdas_path = "${path.module}/../lambda/logica"
  layers_path  = "${path.module}/../lambda/layers"
  layer_name   = "lambda_layer.zip"

  common_tags = {
    Project   = "PJI 240 - Avul"
    CreatedAt = "2024-05-24"
    ManagedBy = "Terraform"
    Owner     = "PJI 310 Turma 4 Grupo 16"
    Service   = var.service_name
  }

  
}
