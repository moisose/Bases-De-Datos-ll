import pika
from elasticsearch.helpers import scan
from elasticsearch import Elasticsearch

# FOR THE MOMENT USE THIS
INPUT_QUEUE = 'TO_PARSE'

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


connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.queue_declare(queue=INPUT_QUEUE)
channel.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)

channel.start_consuming()

