# Este archivo tendrá la aplicacion loader que se encarga de subir los archivos a mongoDB

#------------------------------------------------Imports-------------------------------------------------
from azure.storage.blob import BlobServiceClient
import io
from pathlib import Path
import os
import sys
import csv

#Mongo db libraries--------------------------------------------------------------------------------------
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

#Variables de entorno------------------------------------------------------------------------------------	
UserName= os.getenv('USERNAME')
Password= os.getenv('PASSWORD')
DatabaseName= os.getenv('DATABASENAME')
ArtistsCollection= os.getenv('ARTISTS_COLLECTION')
LyricsCollection= os.getenv('LYRICS_COLLECTION')

uri = "mongodb+srv://" + str(UserName) + ":" + str(Password) + "@mangos.ybmshbl.mongodb.net/" + str(DatabaseName)
connectionString = "DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=KzcNb8ePMdcwCm5gO8/DJc9nY6fngiXFETmDtcdgBfoUPSo+/BowwJxxSdjVx8n0Trh72v9k/yrb+AStjPineQ==;EndpointSuffix=core.windows.net" 



containerName = "documents"
path_File = '\\downloadedFiles'
Artist_File="artists-data.csv"
Lyrics_File="lyrics-data.csv"
#fileName = "artists-data.csv"
artistDownloaded = None
lyricsDownloaded = None

# ===========================================================================
# Blob Storage

# Downloads a file from the blob storage
def downloadFile(filename, filePath):
    try:
        # Conection with Mongo DB
        client = MongoClient(uri)  #Mongo Client
        client = MongoClient(uri, server_api=ServerApi('1'))
        #Prueba conexión con Mongo DB
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!") 
        
        # Connection with blob storage
        blob_service_client = BlobServiceClient.from_connection_string(connectionString)
        container_client = blob_service_client.get_container_client(containerName)
        blob_client = container_client.get_blob_client(filename)
        
        # Opens and reads the archive
        with open(filePath, "wb") as my_blob:
            download_stream = blob_client.download_blob()
            my_blob.write(download_stream.readall())

        cirrentFile = open(filePath, 'r')
        client.close()
        print(f"File {filename} downloaded to {filePath}")
        return cirrentFile
    except Exception as e:
        print(e)


 
 
    
def main():
    artistDownloaded = downloadFile(Artist_File, path_File + "\\" + Artist_File)
    lyricsDownloaded = downloadFile(Lyrics_File, path_File + "\\" + Lyrics_File)

if __name__ == '__main__': 
    main()