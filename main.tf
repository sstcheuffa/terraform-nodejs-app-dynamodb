terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "archive_file" "note-create-archive" {
  source_file = "lambdas/note-create.js"
  output_path = "lambdas/note-create.zip"
  type        = "zip"
}

resource "aws_lambda_function" "note-create" {
  environment {
    variables = {
      NOTES_TABLE = aws_dynamodb_table.tf_notes_table.name
    }
  }
  memory_size   = "128"
  timeout       = 10
  runtime       = "nodejs14.x"
  architectures = ["arm64"]
  handler       = "lambdas/note-create.handler"
  function_name = "note-create"
  role          = aws_iam_role.iam_for_lambda.arn
  filename      = "lambdas/note-create.zip"
}

data "archive_file" "note-delete-archive" {
  source_file = "lambdas/note-delete.js"
  output_path = "lambdas/note-delete.zip"
  type        = "zip"
}

resource "aws_lambda_function" "note-delete" {
  environment {
    variables = {
      NOTES_TABLE = aws_dynamodb_table.tf_notes_table.name
    }
  }
  memory_size   = "128"
  timeout       = 10
  runtime       = "nodejs14.x"
  architectures = ["arm64"]
  handler       = "lambdas/note-delete.handler"
  function_name = "note-delete"
  role          = aws_iam_role.iam_for_lambda.arn
  filename      = "lambdas/note-delete.zip"
}

data "archive_file" "note-get-all-archive" {
  source_file = "lambdas/note-get-all.js"
  output_path = "lambdas/note-get-all.zip"
  type        = "zip"
}


resource "aws_lambda_function" "note-get-all" {
  environment {
    variables = {
      NOTES_TABLE = aws_dynamodb_table.tf_notes_table.name
    }
  }
  memory_size   = "128"
  timeout       = 10
  runtime       = "nodejs14.x"
  architectures = ["arm64"]
  handler       = "lambdas/note-get-all.handler"
  function_name = "note-get-all"
  role          = aws_iam_role.iam_for_lambda.arn
  filename      = "lambdas/note-get-all.zip"
}