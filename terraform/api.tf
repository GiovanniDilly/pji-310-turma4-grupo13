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

resource "aws_api_gateway_resource" "inspetor" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "inspetor"
}

resource "aws_api_gateway_authorizer" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.this.arn]
}

resource "aws_api_gateway_method" "formulario_any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.formulario.id
  authorization = "COGNITO_USER_POOLS"
  http_method   = "ANY"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_method" "inspetor_any" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.inspetor.id
  authorization = "COGNITO_USER_POOLS"
  http_method   = "ANY"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_integration" "formulario" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.formulario.id
  http_method             = aws_api_gateway_method.any.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.formulario.invoke_arn
  // anterior: dynamo
}

resource "aws_api_gateway_integration" "inspetor" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.formulario.id
  http_method             = aws_api_gateway_method.any.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.inspetor.invoke_arn
  // anterior: dynamo
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  depends_on = [aws_api_gateway_integration.formulario, aws_api_gateway_integration.inspetor]
}
