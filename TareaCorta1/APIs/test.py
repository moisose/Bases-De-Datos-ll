import requests
import json
import random


BASE = "http://127.0.0.1:30000/"


def testLoad():
    url = BASE + "babynames"
    response = requests.post(url)
    print(response)
    print(response.json())

def testUpdate():
    url = BASE + "babynames"
    response = requests.put(url)
    print(response)
    print(response.json())

def testDelete():
    url = BASE + "babynames"

    response = requests.delete(url)
    print(response)
    print(response.json())

def testRead():
    response = requests.get(BASE + "babynames")
    print(response)
    print(response.json())
    # print("===")
    # print(random.choice(response.json()["data"])[0])



def menu():
    while True:
        print("===================================================")
        print("Bienvenido, estos son los test disponibles:")
        print("1.Read Test")
        print("2.Load Test")
        print("3.Update Test")
        print("4.Delete Test")
        opcion = int(input("Ingrese la opción que desea usar: "))
        
        if opcion == 1:
            testRead()

        elif opcion == 2:
            testLoad()

        elif opcion == 3:
            testUpdate()

        elif opcion == 4:
            testDelete()

        else:
            print("La opción no es válida.")
        print("===================================================")

menu()


"""
COMANDOS:

cd TareaCorta1/APIs
python test.py
"""