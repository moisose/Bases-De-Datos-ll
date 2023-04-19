"""
File Manager

Este se encarga de recibir los archivos de node JS, es decir, tiene que tener manejo de parametros
y luego los envia a el blob storage

Se supone que es el más grande

"""

from flask import Flask, request
from flask_restful import Resource, Api, reqparse
from azure.storage.blob import BlobServiceClient
from werkzeug.utils import secure_filename

app = Flask(__name__)
# https://filesmanagertiburoncines.blob.core.windows.net/
app.config['AZURE_STORAGE_CONNECTION_STRING'] = 'DefaultEndpointsProtocol=https;AccountName=filesmanagertiburoncines;AccountKey=CkgCBqebOGWP5we26jpV1TIP49C+Wxp2Nf5qJFNEI4i26LUdEX4bSMYfP/yRAYY9RBbGi5tV0QoN+AStTBd8Ew==;EndpointSuffix=core.windows.net'
app.config['AZURE_STORAGE_CONTAINER_NAME'] = 'documents'
api = Api(app)

parser = reqparse.RequestParser()
parser.add_argument('userId', type=str, help='User ID', required=True)
parser.add_argument('name', type=str, help='User Name', required=False)
parser.add_argument('age', type=int, help='Age', required=False)
parser.add_argument('filename', type=str, help='Filename', required=False)


class BlobStorage(Resource):
    def post(self):
        file = request.files['file']
        filename = secure_filename(file.filename)
        blob_service_client = BlobServiceClient.from_connection_string(app.config['AZURE_STORAGE_CONNECTION_STRING'])
        container_client = blob_service_client.get_container_client(app.config['AZURE_STORAGE_CONTAINER_NAME'])
        blob_client = container_client.get_blob_client(filename)
        blob_client.upload_blob(file)
        return 'File uploaded successfully'
    
    def delete(self):
        args = parser.parse_args()
        filename = args['filename']
        blob_service_client = BlobServiceClient.from_connection_string(app.config['AZURE_STORAGE_CONNECTION_STRING'])
        container_client = blob_service_client.get_container_client(app.config['AZURE_STORAGE_CONTAINER_NAME'])
        blob_client = container_client.get_blob_client(filename)

        if blob_client.exists():
            blob_client.delete_blob()
            return f'File {filename} deleted successfully'
        else:
            return f'File {filename} not found'
    
    def put(self, filename):
        file = request.files['file']
        blob_service_client = BlobServiceClient.from_connection_string(app.config['AZURE_STORAGE_CONNECTION_STRING'])
        container_client = blob_service_client.get_container_client(app.config['AZURE_STORAGE_CONTAINER_NAME'])
        blob_client = container_client.get_blob_client(filename)

        if blob_client.exists():
            blob_client.upload_blob(file, overwrite=True)
            return f'File {filename} updated successfully'
        else:
            return f'File {filename} not found'

api.add_resource(BlobStorage, '/blob/filemanager')

if __name__ == '__main__':
    app.run(debug=True)


"""

from azure.storage.blob import BlobServiceClient
from flask import Flask, request
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config['AZURE_STORAGE_CONNECTION_STRING'] = 'DefaultEndpointsProtocol=https;AccountName=<account_name>;AccountKey=<account_key>;EndpointSuffix=core.windows.net'
app.config['AZURE_STORAGE_CONTAINER_NAME'] = '<container_name>'

@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['file']
    filename = secure_filename(file.filename)
    blob_service_client = BlobServiceClient.from_connection_string(app.config['AZURE_STORAGE_CONNECTION_STRING'])
    container_client = blob_service_client.get_container_client(app.config['AZURE_STORAGE_CONTAINER_NAME'])
    blob_client = container_client.get_blob_client(filename)
    blob_client.upload_blob(file)
    return 'File uploaded successfully'

if __name__ == '__main__':
    app.run(debug=True)


"""
