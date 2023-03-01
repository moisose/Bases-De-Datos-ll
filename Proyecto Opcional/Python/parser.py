import pika


# FOR THE MOMENT USE THIS
INPUT_QUEUE = 'TO_PARSE'

def callback(ch, method, properties, body):
    body = str(body)[2:-1]
    print(body)

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.queue_declare(queue=INPUT_QUEUE)
channel.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)

channel.start_consuming()

