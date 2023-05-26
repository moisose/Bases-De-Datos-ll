import unittest
import requests
import os

baseurl = 'https://main-app.politebush-c6efad18.eastus.azurecontainerapps.io'
phrase = 'Leave us'
artist = 'Beyoncé'
language = 'es'
genre = 'Pop'
minPop = '0'
maxPop = '100'
amountOfSongs = '10'
songName = 'Halo'

class test_api(unittest.TestCase):
    
    def testFacets(self):
        url = baseurl+'/facets/list/' + phrase

        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

        condition = ('Error' in response.json())
        self.assertEqual(condition, False)


    def testSearch(self):
        url = baseurl+ '/search/' + phrase + '/' + artist + '/' + language + '/' + genre + '/' + minPop + '/' + maxPop + '/' + amountOfSongs

        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

        condition = ('Error' in response.json())
        self.assertEqual(condition, False)


    def testDetails(self):
        url = baseurl+'/details/' + artist + '/' + songName

        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

        condition = ('Error' in response.json())
        self.assertEqual(condition, False)


if __name__=="__main__":
    unittest.main()
