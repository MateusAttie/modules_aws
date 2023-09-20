output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.lambda-attielabz.function_name
}

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda-bucket.id
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = aws_lambda_function.lambda-attielabz.arn
}

output "lambda_function_invoke_arn" {
  description = "The Invoke ARN of the Lambda Function"
  value       = aws_lambda_function.lambda-attielabz.invoke_arn
}