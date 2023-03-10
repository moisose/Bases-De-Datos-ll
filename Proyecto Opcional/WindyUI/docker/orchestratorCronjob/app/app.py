import time
import os
import sys
import pika
import mysql.connector
from datetime import datetime
import requests
from bs4 import BeautifulSoup

hostname = os.getenv('HOSTNAME')
#interval = int(os.getenv('EVENT_INTERVAL'))
RABBIT_MQ=os.getenv('RABBITMQ')
RABBIT_MQ_PASSWORD=os.getenv('RABBITPASS')
OUTPUT_QUEUE=os.getenv('OUTPUT_QUEUE')

credentials = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
parameters = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials) 
connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.queue_declare(queue=OUTPUT_QUEUE)

# environment variables
HOST = os.getenv('MARIADBHOST')
PASSWORD = os.getenv('MARIADBPASS')
PORT = '3306'
USER = 'root'
DATABASE = 'weather'

#-------------------------------------------Functions------------------------------------
# executes a stored procedure
# @restrictions: none
# @param: the name of the stored prcedure and the parameters of the stored procedure (array of strings)
# @output: none
def executeProcedure(procedure, parameters):
    resultArray = []
    try:
        conn = mysql.connector.connect(host=HOST, user=USER, password= PASSWORD, port= PORT, database=DATABASE)
        cursor = conn.cursor()
        args = ("FF", 2, 2, 20, 3)
        result_args = cursor.callproc(procedure, parameters)

        
        for result in cursor.stored_results():
             resultArray.append(result.fetchall())
             #print(resultArray)
        conn.commit()

        if (conn.is_connected()):
            cursor.close()
            conn.close()
            stored_results = cursor.stored_results()
            #print("MySQL connection is closed")
        

    except mysql.connector.Error as error:
        return ['error']
        #print("Failed to execute stored procedure: {}".format(error))

    finally:
        pass
        
    return resultArray

def readFolder():
    print('empezó el request')
    # root of the NOOA website to add to the files url
    root = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/all/'

    # Making a GET request
    r = requests.get('https://www.ncei.noaa.gov/pub/data/ghcn/daily/all/')
    
    # Parsing the HTML
    soup = BeautifulSoup(r.content, 'html.parser')

    print('termino el request')

    # find all the anchor tags with "href"
    # the count is used to ommit the first 5 links
    count = 0
    for link in soup.find_all('a', href=True):
        if count > 4:
            name = link['href']
            url = root + link['href']
            state = 'LISTED'
            md5 = None

            # code to save the record and publish the ms in rabbitMQ here
            print(url)

            # message for rabbitmq
            msg = url
            channel.basic_publish(exchange='', routing_key=OUTPUT_QUEUE, body=msg)

            executeProcedure("loadFileFolder", [name, url, md5, state])

        if count == 40:
            break
        count += 1
    r.close()
    # close the rabbitmq connection
    #connection.close()

readFolder()
connection.close()