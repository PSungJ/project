# Create IAM
# AWSLambdaRole
resource "aws_iam_role" "role_lambda" {
  name = format("%s-AWSLambdaRole", var.name)
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# AWSLambdaVPCAccessExecutionRole
resource "aws_iam_role_policy" "role_policy_lambda_vpc" {
  name   = format("%s-AWSLambdaVPCAccessExecutionRole", var.name)
  role   = aws_iam_role.role_lambda.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:AssignPrivateIpAddresses",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# AWS SES
resource "aws_iam_role_policy" "role_policy_SES" {
  name   = format("%s-SES", var.name)
  role   = aws_iam_role.role_lambda.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ses:SendRawEmail"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Lambda가 EventBridge에서 실행될 수 있도록 권한 생성
resource "aws_lambda_permission" "lambda_permission_cw" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function_random.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
}

resource "aws_lambda_function" "function_random" {
  filename      = var.lambda.zip_file
  function_name = "${var.name}-random"
  role          = aws_iam_role.role_lambda.arn
  handler       = "${var.lambda.filename}.lambda_handler"

  source_code_hash = filebase64sha256("${var.lambda.zip_file}")

  runtime = "python3.9"

  vpc_config {
    # vpc_id                 = aws_vpc.vpc.id
    subnet_ids         = aws_subnet.web_sub.*.id
    security_group_ids = [aws_security_group.sg_lambda.id]
  }
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = format("%s-event-rule", var.name)
  description = "Application lottery in progress."

  schedule_expression = "cron(0 0 1 * ? *)"
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule      = aws_cloudwatch_event_rule.event_rule.name
  target_id = format("%s-random-lambda", var.name)
  arn       = aws_lambda_function.function_random.arn
}

resource "aws_ses_email_identity" "source_email_identity" {
  email = var.email.source
}

resource "aws_ses_email_identity" "to_email_identity" {
  count = length(var.email.to)
  email = var.email.to[count.index]
}
