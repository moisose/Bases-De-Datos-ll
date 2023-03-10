from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

@app.route('/test')
def bye():
    return 'Bye, World!'

if __name__ == '__main__':
    app.run()

"""
Para igualar el puerto del contenedor Docker con el puerto del servidor local, puedes usar la opción -p (o --publish) cuando ejecutas el contenedor.

El formato de la opción -p es puerto-local:puerto-contenedor, lo que significa que el puerto local especificado será redirigido al puerto dentro del contenedor especificado. Por ejemplo, si el contenedor de Docker está ejecutando una aplicación web en el puerto 5000 y deseas acceder a ella desde el puerto 8080 en tu máquina local, puedes ejecutar el contenedor de la siguiente manera:

css
Copy code
docker run -p 8080:5000 imagen-docker
En este ejemplo, el puerto 8080 de la máquina local se mapeará al puerto 5000 del contenedor. Ahora puedes acceder a la aplicación web desde tu navegador web ingresando la dirección http://localhost:8080.

Es importante tener en cuenta que puedes mapear cualquier número de puertos del contenedor al puerto local utilizando la opción -p. Solo necesitas especificar el puerto local y el puerto del contenedor para cada mapeo de puerto que desees establecer.
"""