# libs in requirements.txt
# pip install requests
# pip install beautifulsoup4

import requests
from bs4 import BeautifulSoup
import time
from datetime import date

# root of the NOOA website to add to the files url
root = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/all/'

begin = time.time()

# Making a GET request
r = requests.get('https://www.ncei.noaa.gov/pub/data/ghcn/daily/all/')
 
# Parsing the HTML
soup = BeautifulSoup(r.content, 'html.parser')

end = time.time()

print('Execution Time: ' + str(end-begin))

# find all the anchor tags with "href"
cont = 0

for link in soup.find_all('a', href=True):
    if cont > 4:
        name = link['href']
        url = root + link['href']
        processedDay = date.today()
        state = 'LISTED'
        md5 = None
        
        print(name, url, processedDay, state, md5)
        print()
    if cont == 40:
        break
    cont += 1

