# libs in requirements.txt
# pip install requests
# pip install beautifulsoup4

import requests
from bs4 import BeautifulSoup
from datetime import date
from script import executeProcedure


# lists the file's links in gov/pub/data/ghcn/daily/all/
# saves the info in a MariaDB record
# publishes a message (the url of each file) in rabbitMQ's queue 'TO_PROCESS'
# @restrictions: none
# @param: none
# @output: none
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
            
            executeProcedure("loadFileFolder", [name, url, md5, state])

        if count == 40:
            break
        count += 1
    r.close()

readFolder()