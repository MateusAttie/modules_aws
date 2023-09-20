data "archive_file" "lambda_attielabz" {
  type = "zip"

  source_dir  = var.lambda_source_dir # "https://github.com/MateusAttie/app_attielabz"
  output_path = var.lambda_output_path # "https://github.com/MateusAttie/app_attielabz/app_attielabz.zip"
}

resource "aws_s3_object" "lambda_attielabz" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    =  var.lambda_s3_key #"app-attielabz.zip"
  source = data.archive_file.lambda_attielabz.output_path

  etag = filemd5(data.archive_file.lambda_attielabz.output_path)
}


resource "aws_lambda_function" "AttieLabz" {
  function_name =  var.lambda_name #"AttieLabz"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_attielabz.key

  runtime =  var.lambda_runtime #"nodejs12.x"
  handler =  var.lambda_handler #"attielabz.handler"

  source_code_hash = data.archive_file.lambda_attielabz.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "attielabz-cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"

  retention_in_days = 7
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}