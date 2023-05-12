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
Artist_File= os.getenv('ARTIST_FILE')
Lyrics_File= os.getenv('LYRICS_FILE')

uri = "mongodb+srv://" + str(UserName) + ":" + str(Password) + "@mangos.ybmshbl.mongodb.net/" + str(DatabaseName)
print(uri)
#uri = "mongodb+srv://MelSaFer:3trZoWOalvOKN7tQ@mangos.ybmshbl.mongodb.net/OpenLyricsSearch"
client = MongoClient(uri)  #Cliente Mongo
client = MongoClient(uri, server_api=ServerApi('1'))

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
    

"""
----------------------------------------------------------------------------------------------
Function for reading artist.csv
->Entries:
->Returns:
->Restrictions:
----------------------------------------------------------------------------------------------
"""
def readArtist():
    try:
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!")
        
        
        client.close()
    except Exception as e:
        print(e)
        
    
def main():
    print(downloadFiles(fileName, pathLyrics + "\\" + fileName))
    print(fileDownloaded.read())
    try:
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!")
        client.close()
    except Exception as e:
        print(e)

if __name__ == '__main__': 
    main()