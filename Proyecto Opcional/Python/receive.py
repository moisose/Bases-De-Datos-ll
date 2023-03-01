import pika
import requests
from script import sameFolderFileMD5
import hashlib

def getMD5(string):
    hashSha = hashlib.sha256()
    hashSha.update(string.encode())
    #print (hashSha.hexdigest())
    return hashSha.hexdigest()

# # reads a single file of the gov/pub/data/ghcn/daily/all/ folder
# # procedure sameFolderFileMD5 is called, if result is 0 the
# # index is added to elastic search
# # @restrictions: none
# # @param: url
# # @output: none
def readFolderFile(url, OUTPUT_QUEUE):
   file = requests.get(url)
   # gets name from url
   fileName = str(url[50:])
   # parse the annoying caracters
   fileName = fileName[2:-1]
      
   string = file.content.decode('utf-8')
   
   # changes the md5 if its different, changes the state either way and gets the flag "sameMD5"
   sameMD5 = sameFolderFileMD5("sameFolderFileMD5", [fileName, getMD5(string)+"", 0])
   print(sameMD5)
   
   # if the file has changed it is published in elastic search
   if (not sameMD5):
        index = {
       "fileName": fileName,
       "contents": string
       }
        # publish message to rabbitMQ queue TO_PARSE
        channel.basic_publish(exchange='', routing_key=OUTPUT_QUEUE, body=fileName)

        # elastic search index publication here

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

# FOR THE MOMENT USE THIS
OUTPUT_QUEUE = 'TO_PARSE'
connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
channel.queue_declare(queue=OUTPUT_QUEUE)

def callback(ch, method, properties, body):
   readFolderFile(body, OUTPUT_QUEUE)

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
        