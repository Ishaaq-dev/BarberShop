import os
import json
import boto3 as aws
import uuid

NUM_OF_CLIENTS_DYNAMO_DB = os.getenv('num_of_clients_in_barbers_table')
dynamoDB = aws.client('dynamodb')

def edit_num_of_clients_in_barbers(event_body):
    print(event_body)