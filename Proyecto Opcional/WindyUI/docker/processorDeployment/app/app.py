import time
import os
import sys
import pika
import requests
import mysql.connector
from datetime import datetime
import hashlib
import json
from elasticsearch import Elasticsearch

hostname = os.getenv('HOSTNAME')
RABBIT_MQ=os.getenv('RABBITMQ')
RABBIT_MQ_PASSWORD=os.getenv('RABBITPASS')
OUTPUT_QUEUE=os.getenv('OUTPUT_QUEUE')
INPUT_QUEUE=os.getenv('INPUT_QUEUE')

ESENDPOINT=os.getenv('ESENDPOINT')
ESPASSWORD=os.getenv('ESPASSWORD')
ESINDEX=os.getenv('ESINDEX')

# environment variables
HOST = os.getenv('MARIADBHOST')
PASSWORD = os.getenv('MARIADBPASS')
PORT = '3306'
USER = 'root'
DATABASE = 'weather'


# executes the sameFolderFileMD5 stored procedure
# @restrictions: none
# @param: the name of the stored prcedure and the parameters of the stored procedure (array of strings)
# @output: none
def sameFolderFileMD5(procedure, parameters):
    sameMD5 = 0
    try:
        conn = mysql.connector.connect(host=HOST, user=USER, password= PASSWORD, port= PORT, database=DATABASE)
        cursor = conn.cursor()
        result_args = cursor.callproc(procedure, parameters)
        for result in cursor.stored_results():
             print(result.fetchall())

        sameMD5 = result_args[2]
        conn.commit()

    except mysql.connector.Error as error:
        print("Failed to execute stored procedure: {}".format(error))

    finally:
        if (conn.is_connected()):
            cursor.close()
            conn.close()
            print("MySQL connection is closed")

    return sameMD5


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
      
   string = str(file.content.decode('utf-8'))
   
   # changes the md5 if its different, changes the state either way and gets the flag "sameMD5"
   sameMD5 = sameFolderFileMD5("sameFolderFileMD5", [fileName, getMD5(string)+"1", 0])
   print(sameMD5)
   
   # if the file has changed it is published in elastic search
   if (not sameMD5):
        
        # elastic search index publication here
        # ** change this for isaac's function
        jsonFile = '{"fileName":"' + fileName + '", ' + '"contents"'+ ':"' + string + '"}'
        jsonF = json.loads({"filename":fileName})
        jsonF.update({"contents":string})
        es.index(index=ESINDEX, id=hashlib.md5(string).hexdigest(), document=jsonF)

        time.sleep(2)

        # publish message to rabbitMQ queue TO_PARSE
        channel_output.basic_publish(exchange='', routing_key=OUTPUT_QUEUE, body=fileName)


def callback(ch, method, properties, body):
   readFolderFile(body, OUTPUT_QUEUE)

credentials_input = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
parameters_input = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_input) 
connection_input = pika.BlockingConnection(parameters_input)
channel_input = connection_input.channel()

channel_input.queue_declare(queue=INPUT_QUEUE)
channel_input.basic_consume(queue=INPUT_QUEUE, on_message_callback=callback, auto_ack=True)

#===============================================
# elastic search file index creation
es = Elasticsearch("https://"+ESENDPOINT+":9200", basic_auth=("elastic", ESPASSWORD), verify_certs=False)

#es.indices.create(index=ESINDEX)
#===============================================


credentials_output = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
parameters_output = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials_output) 
connection_output = pika.BlockingConnection(parameters_output)
channel_output = connection_output.channel()
channel_output.queue_declare(queue=OUTPUT_QUEUE)

channel_input.start_consuming()