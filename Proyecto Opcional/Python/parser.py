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
from elasticsearch.helpers import scan
from elasticsearch import Elasticsearch

# FOR THE MOMENT USE THIS
INPUT_QUEUE = 'TO_PARSE'
OUTPUT_QUEUE = "TO_TRANSFORM"

#===============================================
# elastic search file index creation
es = Elasticsearch(['http://localhost:9200'], basic_auth=('elastic', 'AJCcCwWNgEhIHm1KQJPe'))
#===============================================


# returns the JSON string of the given file retrived from elasticsearch
# @restrictions: none
# @param: the name of the file that will be retrieved from elasticsearch
# @output: JSON string of the given file
def getFileElasticSearch(fileName):

    hit = ""

    query = {
        "query":{
            "match": {
            "fileName.keyword": fileName
            }
        }
    }

    # Scan function to get all the data. 
    rel = scan(client=es,             
               query=query,                                     
               scroll='1m',
               index='files',
               raise_on_error=True,
               preserve_order=False,
               clear_scroll=True)

    # We need only '_source', which has all the fields required.
    # This elimantes the elasticsearch metdata like _id, _type, _index.
    result = list(rel)
    if (result != []):
        hit = result[0]['_source']

    return hit

def callback(ch, method, properties, body):
    body = str(body)[2:-1]

    print("rabbitmq fileName: " + body)
    print("new string: ")
    # get JSON string with filename and contents
    print(getFileElasticSearch(body))
    print("==============================")
    # body is the name of the file


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

