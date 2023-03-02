import time
import os
import sys
import pika
from datetime import datetime
import hashlib
import json
from elasticsearch import Elasticsearch

hostname = os.getenv('HOSTNAME')
RABBIT_MQ=os.getenv('RABBITMQ')
RABBIT_MQ_PASSWORD=os.getenv('RABBITPASS')
INPUT_QUEUE=os.getenv('INPUT_QUEUE')

ESENDPOINT=os.getenv('ESENDPOINT')
ESPASSWORD=os.getenv('ESPASSWORD')
ESINDEX=os.getenv('ESINDEX')

def callback(ch, method, properties, body):
    json_object = json.loads(body)
    localtime = time.localtime()
    result = time.strftime("%I:%M:%S %p", localtime)
    msg = "{\"data\": [ {\"msg\":\""+result+"\", \"hostname\": \""+hostname+"\"}]}"
    json_object["data"].append({"msg": result, "hostname": hostname})
    print(json_object)
    resp = client.index(index=ESINDEX, id=hashlib.md5(body).hexdigest(), document=json_object)
    print(resp)


credentials_input = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
parameters_input = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_input) 
connection_input = pika.BlockingConnection(parameters_input)
channel_input = connection_input.channel()
channel_input.queue_declare(queue=INPUT_QUEUE)
channel_input.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)

client = Elasticsearch("https://"+ESENDPOINT+":9200", basic_auth=("elastic", ESPASSWORD), verify_certs=False)

channel_input.start_consuming()