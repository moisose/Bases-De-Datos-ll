import pika

# RABITMQ
# USE THIS FOR THE CRONJOB
#=================================================
# hostname = os.getenv('HOSTNAME')
# interval = int(os.getenv('EVENT_INTERVAL'))
# RABBIT_MQ=os.getenv('RABBITMQ')
# RABBIT_MQ_PASSWORD=os.getenv('RABBITPASS')
# INPUT_QUEUE=os.getenv('INPUT_QUEUE')
# OUTPUT_QUEUE=os.getenv('OUTPUT_QUEUE')

# credentials = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
# parameters = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials) 
# connection = pika.BlockingConnection(parameters)
# channel = connection.channel()
# channel.queue_declare(queue=OUTPUT_QUEUE)

# FOR THE MOMENT USE THIS
INPUT_QUEUE = 'TO_PARSE'
OUTPUT_QUEUE = "TO_TRANSFORM"

def callback(ch, method, properties, body):
    body = str(body)[2:-1]
    print(body)

connection_input = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel_input = connection_input.channel()
channel_input.queue_declare(queue=INPUT_QUEUE)
channel_input.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)


#credentials_output = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
#parameters_output = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_output) 
#connection_output = pika.BlockingConnection(parameters_output)
connection_output = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel_output = connection_output.channel()
channel_output.queue_declare(queue=OUTPUT_QUEUE)


channel_input.start_consuming()

