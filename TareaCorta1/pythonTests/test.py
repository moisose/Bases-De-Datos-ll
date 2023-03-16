import requests
import threading
import time
import json


BASE = "http://127.0.0.1:5000/"


def testLoad():
    url = BASE + "babynames"
    data = {"birthyear": 1990, "gender": "F", "ethnicity": "Hispanic", "nm": "Carlos", "cnt": 2, "rnk": 3}

    headers = {'Content-type': 'application/json'}
    response = requests.post(url, data=json.dumps(data), headers=headers)
    print(response)
    print(response.json())

def testUpdate(jsonInput):
    url = BASE + "babynames"
    data = jsonInput

    headers = {'Content-type': 'application/json'}
    response = requests.put(url, data=json.dumps(data), headers=headers)
    print(response)
    print(response.json())

def testDelete(id):
    url = BASE + "babynames"
    data = {"id": id}

    headers = {'Content-type': 'application/json'}
    response = requests.delete(url, data=json.dumps(data), headers=headers)
    print(response)
    print(response.json())

def testRead():
    response = requests.get(BASE + "babynames")
    print(response)
    print(response.json())



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
            id = int(input("Ingrese el id del que desea actualizar: "))
            birthyear = int(input("Ingrese el id del que desea actualizar: "))
            gender = input("Ingrese el id del que desea actualizar: ")
            ethnicity = input("Ingrese el id del que desea actualizar: ")
            nm = input("Ingrese el id del que desea actualizar: ")
            cnt = int(input("Ingrese el id del que desea actualizar: "))
            rnk = int(input("Ingrese el id del que desea actualizar: "))
            jsonInput = {"id": id, "birthyear": birthyear, "gender": gender, "ethnicity": ethnicity, "nm": nm, "cnt": cnt, "rnk": rnk}
            testUpdate(jsonInput)

        elif opcion == 4:
            id = int(input("Ingrese el id del que desea eliminar: "))
            testDelete(id)

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