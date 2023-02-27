# libs in requirements.txt
# pip install requests
# pip install beautifulsoup4

import requests
from bs4 import BeautifulSoup
from datetime import date

import pika

# lists the file's links in gov/pub/data/ghcn/daily/all/
# @restrictions: none
# @param: none
# @output: none
def readFolder():
    # root of the NOOA website to add to the files url
    root = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/all/'

    # Making a GET request
    r = requests.get('https://www.ncei.noaa.gov/pub/data/ghcn/daily/all/')
    
    # Parsing the HTML
    soup = BeautifulSoup(r.content, 'html.parser')

    # RABITMQ
    # USE THIS FOR THE CRONJOB
    #=================================================
    # hostname = os.getenv('HOSTNAME')
    # interval = int(os.getenv('EVENT_INTERVAL'))
    # RABBIT_MQ=os.getenv('RABBITMQ')
    # RABBIT_MQ_PASSWORD=os.getenv('RABBITPASS')
    # OUTPUT_QUEUE=os.getenv('OUTPUT_QUEUE')

    # credentials = pika.PlainCredentials('user', RABBIT_MQ_PASSWORD)
    # parameters = pika.ConnectionParameters(host=RABBIT_MQ, credentials=credentials) 
    # connection = pika.BlockingConnection(parameters)
    # channel = connection.channel()
    # channel.queue_declare(queue=OUTPUT_QUEUE)
    #=================================================

    # FOR THE MOMENT USE THIS
    OUTPUT_QUEUE = 'TO_PROCESS'
    connection = pika.BlockingConnection(
    pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()
    channel.queue_declare(queue=OUTPUT_QUEUE)


    # find all the anchor tags with "href"
    # the count is used to ommit the first 5 links
    count = 0
    for link in soup.find_all('a', href=True):
        if count > 4:
            name = link['href']
            url = root + link['href']
            processedDay = date.today()
            state = 'LISTED'
            md5 = None

            # code to save the record and publish the ms in rabbitMQ here
            print(url)

            # message for rabbitmq
            msg = url
            channel.basic_publish(exchange='', routing_key=OUTPUT_QUEUE, body=msg)

        if count == 40:
            break
        count += 1
    r.close()
    # close the rabbitmq connection
    connection.close()

readFolder()