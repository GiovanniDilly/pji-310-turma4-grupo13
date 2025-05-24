# output "cognito_pool_id" {
#   value = aws_cognito_user_pool.this.id
# }

# output "cognito_client_id" {
#   value = aws_cognito_user_pool_client.this.id
# }

# output "cognito_url" {
#   value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
# }

#-------------------------------------------------------------------------------

# AWS RDS - MySQL

output "rds_mysql_arn" {
  value = aws_db_instance.this.arn
}

output "rds_mysql_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "rds_mysql_status" {
  value = aws_db_instance.this.status
}

#-------------------------------------------------------------------------------

# DocumentDB

# output "docdb_cluster_arn" {
#   value = aws_docdb_cluster.this.arn
# }

# output "docdb_cluster_url" {
#   value = aws_docdb_cluster.this.endpoint
# }

# output "docdb_cluster_instance_arn" {
#   value = aws_docdb_cluster_instance.this.arn
# }

# output "docdb_cluster_instance_url" {
#   value = aws_docdb_cluster_instance.this.endpoint
# }

# output "docdb_cluster_instance_port" {
#   value = aws_docdb_cluster_instance.this.port
# }

#-------------------------------------------------------------------------------

# output "lambda_layer_name" {
#   value = aws_lambda_layer_version.joi.layer_name
# }

# output "lambda_layer_version" {
#   value = aws_lambda_layer_version.joi.version
# }

# output "lambda_layer_description" {
#   value = aws_lambda_layer_version.joi.description
#}

# output "lambda_s3_url" {
#   value = aws_lambda_function.s3.invoke_arn
# }

# output "lambda_dynamo_url" {
#   value = aws_lambda_function.dynamo.invoke_arn
# }

# output "api_url" {
#   value = aws_api_gateway_deployment.this.invoke_url
# }

# output "bucket_name" {
#   value = aws_s3_bucket.todo.bucket
# }
