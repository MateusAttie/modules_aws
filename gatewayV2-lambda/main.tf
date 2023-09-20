resource "aws_apigatewayv2_api" "attielabz-gateway" {
  name          = var.gateway_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "attielabz-gateway-stage" {
  api_id = aws_apigatewayv2_api.attielabz-gateway.id

  name        = var.gtw_stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "attielabz-gateway-integration" {
  api_id = aws_apigatewayv2_api.attielabz-gateway.id

  integration_uri    = var.invoke_arn_lambda_function #aws_lambda_function.hello_world.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "attielabz-gateway-route" {
  api_id = aws_apigatewayv2_api.attielabz-gateway.id

  route_key = "GET /attielabz"
  target    = "integrations/${aws_apigatewayv2_integration.attielabz-gateway-integration.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.attielabz-gateway.name}"

  retention_in_days = 7
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name #aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.attielabz-gateway.execution_arn}/*/*"
}
