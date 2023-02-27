# libs in requirements.txt
# pip install requests
# pip install beautifulsoup4

import requests
from bs4 import BeautifulSoup
from datetime import date


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

        if count == 40:
            break
        count += 1
    r.close()

