variable "aws_region" {
  type        = string
  description = "A região da AWS"
  default     = "us-east-1"
}

variable "availability_zones" {
  type        = list
  description = "A região da AWS"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_profile" {
  type        = string
  description = "O perfil da AWS"
  default     = "default"
}

variable "aws_account_id" {
  type        = number
  description = "O ID da conta AWS no formato Number"
  sensitive = true
}

variable "aws_account_id_str" {
  type        = string
  description = "O ID da conta AWS no formato String"
  sensitive = true
}

variable "service_name" {
  type        = string
  description = "Nome do Serviço"
  default     = "avul-pji240"
}

variable "service_domain" {
  type        = string
  description = "Domínio do Serviço"
  default     = "api-avul-1-pji240"
}

variable "docdb_master_username" {
  type        = string
  description = "Usuário Mestre do DocumentDB"
  sensitive = true
}

variable "docdb_master_password" {
  type        = string
  description = "Senha Mestre do DocumentDB. Deve conter 8 caracteres."
  sensitive = true
}
