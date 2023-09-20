data "archive_file" "file-lambda-attielabz" {
  type = "zip"

  source_dir  = var.lambda_source_dir
  output_path = var.lambda_output_path
}

resource "aws_s3_bucket" "lambda-bucket" {
  bucket = var.lambda_bucket_name

  tags = {
    Name        = var.lambda_bucket_name
  }
}

resource "aws_s3_object" "s3-lambda-attielabz" {
  bucket = aws_s3_bucket.lambda-bucket.id

  key    =  var.lambda_s3_key
  source = data.archive_file.file-lambda-attielabz.output_path

  etag = filemd5(data.archive_file.file-lambda-attielabz.output_path)
}


resource "aws_lambda_function" "lambda-attielabz" {
  function_name =  var.lambda_name

  s3_bucket = aws_s3_bucket.lambda-bucket.id
  s3_key    = aws_s3_object.s3-lambda-attielabz.key

  runtime =  var.lambda_runtime
  handler =  var.lambda_handler 

  source_code_hash = data.archive_file.file-lambda-attielabz.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "attielabz-cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.lambda-attielabz.function_name}"

  retention_in_days = 7
}

resource "aws_iam_role" "lambda_exec" {
  name = var.lambda_iam_role_name

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