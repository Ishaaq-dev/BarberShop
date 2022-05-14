# Need to create the following:
# - Lambda
# - DynamoDB

locals {
  zip_location = "src-zip"
  edit_num_of_clients_in_barbers_lambda_name      = "${var.prefix}-${var.project}-edit-num-of-clients-in-barbers"
  edit_num_of_clients_in_barbers_lambda_file_name = "${local.zip_location}/edit-num-of-clients-in-barbers.zip"
  lambda_handler                                  = "LambdaHandler.process_event"
  num_of_clients_in_barbers_dynamo_name           = "${var.prefix}-${var.project}-num-of-clients-in-barbers"
  lambda_runtime                                  = "python3.9"
}

data "archive_file" "edit_num_of_clients_in_barbers_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/lambda/edit-num-of-clients-in-barbers"
  output_path = "${path.module}/${local.edit_num_of_clients_in_barbers_lambda_file_name}"
}

data "archive_file" "utils_zip" {
  type = "zip"
  source_dir = "${path.module}/../src/helpers"
  output_path = "${path.module}/${local.zip_location}/utils.zip"
}

resource "aws_dynamodb_table" "num_of_clients_in_barbers_dynamodb" {
  name           = local.num_of_clients_in_barbers_dynamo_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "barber_shop_id"

  attribute {
    name = "barber_shop_id"
    type = "S"
  }
}

resource "aws_lambda_function" "num_of_clients_in_barbers_lambda" {
  filename         = local.edit_num_of_clients_in_barbers_lambda_file_name
  function_name    = local.edit_num_of_clients_in_barbers_lambda_name
  role             = "arn:aws:iam::574674178402:role/iam_for_lambda"
  handler          = local.lambda_handler
  source_code_hash = filebase64sha256(data.archive_file.edit_num_of_clients_in_barbers_lambda_zip.output_path)
  runtime          = local.lambda_runtime

  environment {
    variables = {
      num_of_clients_in_barbers_table = aws_dynamodb_table.num_of_clients_in_barbers_dynamodb.name
    }
  }

  layers = [aws_lambda_layer_version.lambda_utils_layer.arn]
}

resource "aws_lambda_layer_version" "lambda_utils_layer" {
  filename   = data.archive_file.utils_zip.output_path
  layer_name = "utils"

  compatible_runtimes = ["${local.lambda_runtime}"]
}
