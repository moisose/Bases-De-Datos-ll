import requests
import json
import random


BASE = "http://127.0.0.1:5000/"


def testLoad():
    url = BASE + "user"
    response = requests.post(url)
    print(response)
    print(response.json())

def testUpdate():
    url = BASE + "db01"
    response = requests.put(url)
    print(response)
    print(response.json())

def testDelete():
    url = BASE + "db01"

    response = requests.delete(url)
    print(response)
    print(response.json())

def testRead():
    response = requests.get(BASE + "db01")
    print(response)
    print(response.json())
    # print("===")
    # print(random.choice(response.json()["data"])[0])



for i in range(5):
    testLoad()


"""
COMANDOS:

cd TareaCorta1/APIs
python test.py
"""