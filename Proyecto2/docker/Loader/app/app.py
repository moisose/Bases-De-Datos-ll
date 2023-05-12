# Este archivo tendrá la aplicacion loader que se encarga de subir los archivos a mongoDB

#Imports
from azure.storage.blob import BlobServiceClient
import io
from azure.storage.blob import BlobServiceClient
from pathlib import Path
import os

#Variables
connectionString = "DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=KzcNb8ePMdcwCm5gO8/DJc9nY6fngiXFETmDtcdgBfoUPSo+/BowwJxxSdjVx8n0Trh72v9k/yrb+AStjPineQ==;EndpointSuffix=core.windows.net" 
containerName = "documents"
pathLyrics = '\\downloadedFiles'
pathArtists = ""
fileName = "prueba.txt"

fileDownloaded = False


# ===========================================================================
# Blob Storage

# Downloads a file from the blob storage
def downloadFiles(filename, filePath):
    global fileDownloaded
    try:
        blob_service_client = BlobServiceClient.from_connection_string(connectionString)
        container_client = blob_service_client.get_container_client(containerName)
        blob_client = container_client.get_blob_client(filename)
        with open(filePath, "wb") as my_blob:
            download_stream = blob_client.download_blob()
            my_blob.write(download_stream.readall())

        fileDownloaded = open(filePath, 'r')
        return f"File {filename} downloaded to {filePath}"
    except Exception as e:
        return {'error': str(e)}
    
def main():
    print(downloadFiles(fileName, pathLyrics + "\\" + fileName))
    print(fileDownloaded.read())

if __name__ == '__main__': 
    main()