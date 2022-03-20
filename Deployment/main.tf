# Need to create the following:
# - Lambda
# - DynamoDB

locals {
  edit_num_of_clients_in_barbers_lambda_name      = "${var.prefix}-${var.project}-edit-num-of-clients-in-barbers"
  edit_num_of_clients_in_barbers_lambda_file_name = "src-zip/edit-num-of-clients-in-barbers.zip"
  lambda_handler                                  = "LambdaHandler.process_event"
  num_of_clients_in_barbers_dynamo_name           = "${var.prefix}-${var.project}-num-of-clients-in-barbers"
}

data "archive_file" "edit_num_of_clients_in_barbers_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/lambda/edit-num-of-clients-in-barbers"
  output_path = "${path.module}/${local.edit_num_of_clients_in_barbers_lambda_file_name}"
}

resource "aws_lambda_function" "num_of_clients_in_barbers_lambda" {
  filename         = local.edit_num_of_clients_in_barbers_lambda_file_name
  function_name    = local.edit_num_of_clients_in_barbers_lambda_name
  role             = "arn:aws:iam::574674178402:role/iam_for_lambda"
  handler          = local.lambda_handler
  source_code_hash = filebase64sha256(local.edit_num_of_clients_in_barbers_lambda_file_name)
  runtime          = "python3.9"

  environment {
    variables = {
      num_of_clients_in_barbers_table = aws_dynamodb_table.num_of_clients_in_barbers_dynamodb.name
    }
  }
}

resource "aws_dynamodb_table" "num_of_clients_in_barbers_dynamodb" {
  name           = local.num_of_clients_in_barbers_dynamo_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
