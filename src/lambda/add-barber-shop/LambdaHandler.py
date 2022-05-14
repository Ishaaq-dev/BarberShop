import json

def process_event(event, context):
    body_json = None
    if "Records" in event:
        body = event['Records'][0]['body']
        body_json = json.loads(body)
    else:
        body_json = event

    