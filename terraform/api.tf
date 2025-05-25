resource "aws_api_gateway_rest_api" "this" {
  name = var.service_name
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "formulario" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "formulario"
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "login"
}

resource "aws_api_gateway_method" "formulario_any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.formulario.id
  authorization = "NONE"
  http_method   = "ANY"
}

resource "aws_api_gateway_method" "login_post" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.login.id
  authorization = "NONE"
  http_method   = "POST"
}

resource "aws_api_gateway_integration" "login" {

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.login.id
  http_method = aws_api_gateway_method.login_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.login.invoke_arn
}

# resource "aws_api_gateway_integration" "inspetor" {
#   for_each                = aws_lambda_function.docdb_inspetor
#   rest_api_id             = aws_api_gateway_rest_api.this.id
#   resource_id             = aws_api_gateway_resource.formulario.id
#   http_method             = aws_api_gateway_method.inspetor_any.http_method
#   integration_http_method = "ANY"
#   type                    = "AWS_PROXY"
#   uri                     = each.value.invoke_arn
# }

# resource "aws_lambda_permission" "permit" {

#   for_each = concat(aws_lambda_function.docdb_inspetor.*.function_name, aws_lambda_function.docdb_formulario.*.function_name)

#   statement_id  = "AllowAPIGatewayToInvokeFunction"
#   action        = "lambda:InvokeFunction"
#   function_name = each.value
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
# }

# resource "aws_api_gateway_deployment" "this" {
#   rest_api_id = aws_api_gateway_rest_api.this.id

#   depends_on = [aws_api_gateway_integration.formulario, aws_api_gateway_integration.inspetor]
# }
