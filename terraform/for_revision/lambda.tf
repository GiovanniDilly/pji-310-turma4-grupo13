resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name          = var.lambda_layer_name
  description         = "Inclui SQLAlchemy"
  filename            = "${local.layers_path}\\result\\${local.layer_name}"
  compatible_runtimes = ["python3.12"]
}

# data "aws_lambda_layer_version" "lambda_layer" {
#   layer_name = var.lambda_layer_name
# }

data "archive_file" "formulario" {
  type        = "zip"
  source_file = "${local.lambdas_path}/formulario.py"
  output_path = "files/formulario.zip"
}

data "archive_file" "inspetor" {
  type        = "zip"
  source_file = "${local.lambdas_path}/inspetor.py"
  output_path = "files/inspetor.zip"
}

# resource "aws_lambda_function" "docdb_inspetor" {
#   for_each      = var.inspetor_functions
#   function_name = "avul_${each.key}"
#   handler       = "inspetor.${each.key}"
#   role          = aws_iam_role.lambda-role.arn
#   runtime       = "python3.12"

#   vpc_config {
#     subnet_ids         = data.aws_subnets.this.ids
#     security_group_ids = [aws_security_group.lambda_sg.id]
#   }

#   filename         = data.archive_file.inspetor.output_path
#   source_code_hash = data.archive_file.inspetor.output_base64sha256

#   depends_on = [
#     aws_lambda_layer_version.lambda_layer
#   ]
# }

# resource "aws_lambda_function" "docdb_formulario" {
#   for_each      = var.formulario_functions
#   function_name = "avul_${each.key}"
#   handler       = "formulario.${each.key}"
#   role          = aws_iam_role.lambda-role.arn
#   runtime       = "python3.12"

#   vpc_config {
#     subnet_ids         = data.aws_subnets.this.ids
#     security_group_ids = [aws_security_group.lambda_sg.id]
#   }

#   filename         = data.archive_file.formulario.output_path
#   source_code_hash = data.archive_file.formulario.output_base64sha256

#   depends_on = [
#     aws_lambda_layer_version.lambda_layer
#   ]
# }
