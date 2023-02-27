import pika
import sys
import os

# USE THIS FOR THE CRONJOB
#==============================================
# hostname = os.getenv('HOSTNAME')
# RABBIT_MQ=os.getenv('RABBITMQ')
# RABBIT_MQ_PASSWORD=os.getenv('RABBITPASS')
# OUTPUT_QUEUE=os.getenv('OUTPUT_QUEUE')
# INPUT_QUEUE=os.getenv('INPUT_QUEUE')
#===============================================

# FOR THE MOMENT USE THIS
INPUT_QUEUE = 'TO_PROCESS'

def callback(ch, method, properties, body):
    print(body)

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.queue_declare(queue=INPUT_QUEUE)
channel.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)

channel.start_consuming()

# USE THIS FOR THE CRONJOB
#======================================================================================================
# credentials_input = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
# parameters_input = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_input) 
# connection_input = pika.BlockingConnection(parameters_input)
# channel_input = connection_input.channel()
# channel_input.queue_declare(queue=INPUT_QUEUE)
# channel_input.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)

# credentials_output = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
# parameters_output = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_output) 
# connection_output = pika.BlockingConnection(parameters_output)
# channel_output = connection_output.channel()
# channel_output.queue_declare(queue=OUTPUT_QUEUE)

# channel_input.start_consuming()
#======================================================================================================