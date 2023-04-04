"""
File Manager

Este se encarga de recibir los archivos de node JS, es decir, tiene que tener manejo de parametros
y luego los envia a el blob storage

Se supone que es el más grande

"""

from flask import Flask
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)

class BlobStorage(Resource):
    def get(self):
        return {'message': 'Hello, World!'}
    def post(self):
        return {'message': 'Hello, World!'}
    def put(self):
        return {'message': 'Hello, World!'}

api.add_resource(BlobStorage, '/blob/filemanager')

if __name__ == '__main__':
    app.run(debug=True)
