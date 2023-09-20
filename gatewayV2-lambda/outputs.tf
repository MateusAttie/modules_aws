output "apigatewayv2_api_id" {
  description = "The API identifier"
  value       = aws_apigatewayv2_api.attielabz-gateway.id
}

output "apigatewayv2_api_api_endpoint" {
  description = "The URI of the API"
  value       = aws_apigatewayv2_api.attielabz-gateway.api_endpoint
}

output "apigatewayv2_api_arn" {
  description = "The ARN of the API"
  value       = aws_apigatewayv2_api.attielabz-gateway.arn
}

output "apigatewayv2_api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = aws_apigatewayv2_api.attielabz-gateway.execution_arn
}

# default stage
output "default_apigatewayv2_stage_id" {
  description = "The default stage identifier"
  value       = aws_apigatewayv2_stage.attielabz-gateway-stage.id
}

output "default_apigatewayv2_stage_arn" {
  description = "The default stage ARN"
  value       = aws_apigatewayv2_stage.attielabz-gateway-stage.arn
}

output "default_apigatewayv2_stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = aws_apigatewayv2_stage.attielabz-gateway-stage.execution_arn
}

output "default_apigatewayv2_stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = aws_apigatewayv2_stage.attielabz-gateway-stage.invoke_url
}