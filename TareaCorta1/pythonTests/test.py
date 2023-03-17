import requests
import json
import random


BASE = "http://127.0.0.1:5000/"


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

menu()


"""
Para igualar el puerto del contenedor Docker con el puerto del servidor local, puedes usar la opción -p (o --publish) cuando ejecutas el contenedor.

El formato de la opción -p es puerto-local:puerto-contenedor, lo que significa que el puerto local especificado será redirigido al puerto dentro del contenedor especificado. Por ejemplo, si el contenedor de Docker está ejecutando una aplicación web en el puerto 5000 y deseas acceder a ella desde el puerto 8080 en tu máquina local, puedes ejecutar el contenedor de la siguiente manera:

css
Copy code
docker run -p 8080:5000 imagen-docker
En este ejemplo, el puerto 8080 de la máquina local se mapeará al puerto 5000 del contenedor. Ahora puedes acceder a la aplicación web desde tu navegador web ingresando la dirección http://localhost:8080.

Es importante tener en cuenta que puedes mapear cualquier número de puertos del contenedor al puerto local utilizando la opción -p. Solo necesitas especificar el puerto local y el puerto del contenedor para cada mapeo de puerto que desees establecer.


"""