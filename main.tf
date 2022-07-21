resource "aws_lambda_function" "main" {
  filename         = data.archive_file.main.output_path
  source_code_hash = data.archive_file.main.output_base64sha256
  function_name    = "furl"
  role             = aws_iam_role.main.arn
  handler          = "lambda.handler"
  runtime          = "python3.8"
}

data "archive_file" "main" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/src/lambda.zip"
}

resource "aws_lambda_function_url" "main" {
  function_name      = aws_lambda_function.main.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

resource "aws_iam_role" "main" {
  name               = "furl"
  assume_role_policy = data.aws_iam_policy_document.main.json
}

data "aws_iam_policy_document" "main" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
