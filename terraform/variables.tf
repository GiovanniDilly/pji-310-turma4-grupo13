variable "aws_region" {
  type        = string
  description = ""
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = ""
  default     = "default"
}

variable "aws_account_id" {
  type        = number
  description = ""
}

variable "aws_account_id_str" {
  type        = string
  description = ""
}

variable "service_name" {
  type        = string
  description = ""
  default     = "avul-pji240"
}

variable "service_domain" {
  type        = string
  description = ""
  default     = "api-avul-1-pji240"
}