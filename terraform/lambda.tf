# resource "null_resource" "build_lambda_layers" {
#   triggers = {
#     layer_build = filemd5("${path.module}\\lambda\\layers_zip\\SQLalchemy_PyMySQL.zip")
#   }

#   provisioner "local-exec" {
#     working_dir = "\\"
#     command     = ".\\venv\\Scripts\\activate && pip install SQLAlchemy -t .\\lambda\\layers && pip install PyMySQL -t .\\lambda\\layers"
#   }

# }

# data "archive_file" "layer_zip" {
#   type        = "zip"
#   source_dir  = "${local.layers_path}"
#   output_path = "${local.layers_path}\\..\\layers_zip"
# }

# Uploads the ziped layer to the S3 
resource "aws_s3_object" "upload_layer" {

  key    = "SQLalchemy_PyMySQL.zip"
  bucket = aws_s3_bucket.this.bucket
  source = ".\\..\\lambda\\layers_zip\\SQLalchemy_PyMySQL.zip"

  depends_on = [
    resource.aws_s3_bucket.this
  ]
}

# ------

resource "aws_lambda_layer_version" "lambda_layer" {
  s3_bucket  = aws_s3_bucket.this.bucket
  s3_key     = "SQLalchemy_PyMySQL.zip"
  layer_name = "SQLalchemy_PyMySQL"

  compatible_runtimes = ["python3.11"]

  depends_on = [
    aws_s3_object.upload_layer
  ]
}

# data "archive_file" "formulario" {
#   type        = "zip"
#   source_file = "${local.lambdas_path}/formulario.py"
#   output_path = "files/formulario.zip"
# }

data "archive_file" "login" {
  type        = "zip"
  source_file = "${local.lambdas_path}/login.py"
  output_path = "files/login.zip"
}

resource "aws_lambda_function" "login" {

  function_name = "avul2_login"
  handler       = "login.handler"
  role          = aws_iam_role.lambda-role.arn
  runtime       = "python3.11"

  filename         = data.archive_file.login.output_path
  source_code_hash = data.archive_file.login.output_base64sha256

  depends_on = [
    aws_lambda_layer_version.lambda_layer,
    aws_db_instance.this
  ]

  environment {
    variables = {
      mysql_dsn = "mysql+mysqlconnector://${var.rds_mysql_master_username}:${var.rds_mysql_master_password}@${aws_db_instance.this.endpoint}/${var.rds_mysql_name}"
    }
  }

}

# resource "aws_lambda_function" "formulario" {
#   for_each = var.formulario_functions

#   function_name = "avul2_${each.key}"
#   handler       = "formulario.${each.key}"
#   role          = aws_iam_role.lambda-role.arn
#   runtime       = "python3.11"

#   filename         = data.archive_file.formulario.output_path
#   source_code_hash = data.archive_file.formulario.output_base64sha256

#   depends_on = [
#     aws_lambda_layer_version.lambda_layer
#   ]

#   environment {
#     variables = {
#       mysql_dsn = "mysql+mysqlconnector://${var.rds_mysql_master_username}:${var.rds_mysql_master_password}@${aws_db_instance.this.endpoint}/${var.rds_mysql_name}"
#     }
#   }

# }

# resource "aws_lambda_permission" "permit_formulario" {

#   for_each = aws_lambda_function.formulario

#   statement_id  = "AllowAPIGatewayToInvokeFunction"
#   action        = "lambda:InvokeFunction"
#   function_name = each.value
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
# }

resource "aws_lambda_permission" "permit_login" {

  statement_id  = "AllowAPIGatewayToInvokeFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.login.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}