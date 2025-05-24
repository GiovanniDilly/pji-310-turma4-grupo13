data "aws_iam_policy_document" "lambda-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "lambda-vpc-access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Lambda Policy Attachment

resource "aws_iam_role" "lambda-role" {
  name               = "${var.service_domain}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role.json
}

resource "aws_iam_role_policy_attachment" "lambda-vpc-access" {
  policy_arn = data.aws_iam_policy.lambda-vpc-access.arn
  role       = aws_iam_role.lambda-role.name
}

