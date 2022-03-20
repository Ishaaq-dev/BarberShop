import os
import json
from edit_num_of_clients_in_barbers import edit_num_of_clients_in_barbers

def process_event(event, context):
    body_json = None
    if "Records" in event:
        body = event['Records'][0]['body']
        body_json = json.loads(body)
    else: 
        body_json = event
    edit_num_of_clients_in_barbers(body_json)
    return {
        'statusCode': 200,
        'body': body_json
    }