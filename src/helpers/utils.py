import json

def get_records_from_event(event):
    body_json = None
    if "Records" in event:
        body = event['Records'][0]['body']
        body_json = json.loads(body)
    
    return body_json