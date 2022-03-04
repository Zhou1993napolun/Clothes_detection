import json
import os
from celery import Celery
import requests
import logging

logging.basicConfig(level=logging.INFO)

ORION_HOST_PORT = os.getenv("ORION_HOST_PORT", "192.168.28.186:1026")

app = Celery('result_publisher', broker='redis://' + ORION_HOST_PORT + '/0')


@app.task(name="result_publisher")
def send_result(result):
    build_ngsi_request(result)


def build_ngsi_request(result):
    orion_url = "http://{}/v2/op/update".format(ORION_HOST_PORT)
    payload = {
        "actionType": "append",
        "entities": [
            {
                "id": "frame_id_" + str(result['frame_id']),
                "type": "Frame",
                "detected_items": {
                    "value": result['detected_items'],
                    "type": "List"
                },
                "scores": {
                    "value": result['scores'],
                    "type": "List"
                },
                "boxes": {
                    "value": result['boxes'],
                    "type": "List"
                }
            }
        ]
    }
    headers = {'content-type': 'application/json'}
    r = requests.post(orion_url, data=json.dumps(payload), headers=headers) 
    logging.info('Detection results sent, frame ID: {}, status: {}'.format(result['frame_id'], r.status_code))
