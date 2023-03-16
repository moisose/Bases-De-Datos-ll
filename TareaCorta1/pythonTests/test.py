import requests
import threading
import time

BASE = "http://127.0.0.1:5000/"

listaNombres = ["Isaac Araya", "Fiorella Zelaya", "Melany Salas", "Moisés Solano", "Pablo Arias"]

def test1():
    while(True):
        response = requests.get(BASE)
        print("==>")
        print(response.json())
        time.sleep(1)

def test2():
    while(True):
        response = requests.get(BASE)
        print("-->")
        print(response.json())
        time.sleep(1)

def test3():
    #response = requests.post(BASE + "babynames/{'birthyear':1990, 'gender':'F', 'ethnicity':'Asian', 'nm':1, 'cnt':2, 'rnk':3}")
    response = requests.get(BASE + "babynames/")
    print(response)
    # for i in listaNombres:
        
    #     print("==>")
    #     print(response.json())
    #     time.sleep(1)

thread1 = threading.Thread(target=test1)
thread2 = threading.Thread(target=test2)
thread3 = threading.Thread(target=test3)

#thread1.start()
#thread2.start()
#thread3.start()
test3()


"""
Para igualar el puerto del contenedor Docker con el puerto del servidor local, puedes usar la opción -p (o --publish) cuando ejecutas el contenedor.

El formato de la opción -p es puerto-local:puerto-contenedor, lo que significa que el puerto local especificado será redirigido al puerto dentro del contenedor especificado. Por ejemplo, si el contenedor de Docker está ejecutando una aplicación web en el puerto 5000 y deseas acceder a ella desde el puerto 8080 en tu máquina local, puedes ejecutar el contenedor de la siguiente manera:

css
Copy code
docker run -p 8080:5000 imagen-docker
En este ejemplo, el puerto 8080 de la máquina local se mapeará al puerto 5000 del contenedor. Ahora puedes acceder a la aplicación web desde tu navegador web ingresando la dirección http://localhost:8080.

Es importante tener en cuenta que puedes mapear cualquier número de puertos del contenedor al puerto local utilizando la opción -p. Solo necesitas especificar el puerto local y el puerto del contenedor para cada mapeo de puerto que desees establecer.
"""