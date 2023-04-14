"""
File Manager

Este se encarga de recibir los archivos de node JS, es decir, tiene que tener manejo de parametros
y luego los envia a el blob storage

Se supone que es el más grande

"""

from flask import Flask
from flask_restful import Resource, Api, reqparse

app = Flask(__name__)
api = Api(app)

"""

{'userId': 'user1', 'log': 'File loaded'}

parser = {'userId': None}

"""

parser = reqparse.RequestParser()
parser.add_argument('userId', type=str, help='User ID', required=True)
parser.add_argument('name', type=str, help='User Name', required=False)
parser.add_argument('age', type=int, help='Age', required=False)


class BlobStorage(Resource):
    def get(self):
        args = parser.parse_args()
        userId = args['userId']
        name = args['name']
        conn.callproc("sp_insert_user", (userId,name))
        return {'message': 'Hello, World!'}
    def post(self):
        return {'message': 'Hello, World!'}
    def put(self):
        return {'message': 'Hello, World!'}

api.add_resource(BlobStorage, '/blob/filemanager')

if __name__ == '__main__':
    app.run(debug=True)
