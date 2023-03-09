import time
import os
import sys
import pika
from datetime import datetime
import hashlib
import json

hostname = os.getenv('HOSTNAME')
RABBIT_MQ=os.getenv('RABBITMQ')
RABBIT_MQ_PASSWORD=os.getenv('RABBITPASS')
OUTPUT_QUEUE=os.getenv('OUTPUT_QUEUE')
INPUT_QUEUE=os.getenv('INPUT_QUEUE')

def callback(ch, method, properties, body):
    print(body)
    
    channel_output.basic_publish(exchange='', routing_key=OUTPUT_QUEUE, body="")


credentials_input = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
parameters_input = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_input) 
connection_input = pika.BlockingConnection(parameters_input)
channel_input = connection_input.channel()
channel_input.queue_declare(queue=INPUT_QUEUE)
channel_input.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)

credentials_output = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
parameters_output = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_output) 
connection_output = pika.BlockingConnection(parameters_output)
channel_output = connection_output.channel()
channel_output.queue_declare(queue=OUTPUT_QUEUE)

channel_input.start_consuming()