variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "db_dbname" {
  description = "Database database name"
  type        = string
  default     = "postgres"
}

variable "db_engine" {
  description = " database engine"
  type        = string
  default     = "postgres"
}

resource "aws_db_instance" "this" {
  allocated_storage    = var.rds_allocated_storage
  db_name              = var.rds_mysql_name
  db_subnet_group_name = ""
  engine               = var.rds_mysql_engine
  engine_version       = var.rds_mysql_engine_version
  instance_class       = var.rds_mysql_instance_class
  username             = var.rds_mysql_master_username
  password             = var.rds_mysql_master_password
  publicly_accessible = true
  skip_final_snapshot = true
}
