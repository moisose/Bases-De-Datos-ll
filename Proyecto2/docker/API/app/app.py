from azure.storage.blob import BlobServiceClient
from flask import Flask, flash, request, send_file
from azure.storage.blob import BlobServiceClient
from flask_cors import CORS

# Definition of the API
app = Flask(__name__)
CORS(app)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
app.config['AZURE_STORAGE_CONNECTION_STRING'] = 'DefaultEndpointsProtocol=https;AccountName=filesmanagertiburoncines;AccountKey=CkgCBqebOGWP5we26jpV1TIP49C+Wxp2Nf5qJFNEI4i26LUdEX4bSMYfP/yRAYY9RBbGi5tV0QoN+AStTBd8Ew==;EndpointSuffix=core.windows.net'
app.config['AZURE_STORAGE_CONTAINER_NAME'] = 'documents'

@app.route('/', methods = ['GET'])
def main():
    return {"message": "Welcome to the API!"}

# Run the app
if __name__ == '__main__': 
    app.run(debug=True)