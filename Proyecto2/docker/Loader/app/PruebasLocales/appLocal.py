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
containerName = "documents"
path_File = '\\downloadedFiles'

# connectionString to mongo database
uri = "mongodb+srv://MelSaFer:3trZoWOalvOKN7tQ@mangos.ybmshbl.mongodb.net/OpenLyricsSearch"
# connectionString to the bolb storage
connectionString = "DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=KzcNb8ePMdcwCm5gO8/DJc9nY6fngiXFETmDtcdgBfoUPSo+/BowwJxxSdjVx8n0Trh72v9k/yrb+AStjPineQ==;EndpointSuffix=core.windows.net" 

Artist_File="artists-data.csv"
Lyrics_File="lyrics-data.csv"
artistDownloaded = None
lyricsDownloaded = None

# ===========================================================================
# Blob Storage

"""
-----------------------------------------------------------------------------------------------
Parse all the artists of the csv file and insert them into the database
ENTRIES: artist downloaded file
OUTPUT: 1 if the process was successful (if mongo db conection was successful
        0 if the process was unsuccessful  
-----------------------------------------------------------------------------------------------
"""
def parseArtists(artistDownloaded_var):
    try:
        client = MongoClient(uri)  #Mongo Client
        client = MongoClient(uri, server_api=ServerApi('1'))
        #Prueba conexión con Mongo DB
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!") 

        db = client[str(DatabaseName)]
        collection = db[str(ArtistsCollection)]

        #csv_reader = csv.reader(artistDownloaded_var)
        csv_reader = csv.reader(artistDownloaded_var, delimiter=',')
        header = next(csv_reader)

        documents  = []
        doc = {}
 
        artistsNames = collection.distinct("artist")

        for row in csv_reader:
            if not row[0] in artistsNames:
                doc['artist'] = row[0]
                #parsing genres
                doc['genres'] = row[1].split(';')
                doc['songs'] = row[2]
                doc['popularity'] = row[3]
                doc['link'] = row[4]
                documents.append(doc)
                doc = {}
            else:
                print(row[0] + " is already on the collection")
        collection.insert_many(documents)
        #print("Insertados los IDs de los documentos:", result.inserted_ids)
        return documents
        client.close()
    except Exception as e:
        print("Unexpected error:", e)
        return 0
    return 1    
"""
-----------------------------------------------------------------------------------------------
""" 

"""
-----------------------------------------------------------------------------------------------
Parse all the artists of the csv file and insert them into the database
ENTRIES: artist downloaded file
OUTPUT: 1 if the process was successful (if mongo db conection was successful
        0 if the process was unsuccessful  
-----------------------------------------------------------------------------------------------
"""
def parseLyrics(lyricsDownloaded_var):
    try:
        client = MongoClient(uri)  #Mongo Client
        client = MongoClient(uri, server_api=ServerApi('1'))
        #Prueba conexión con Mongo DB
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!") 

        db = client[str('OpenLyricsSearch')]
        collection = db[str('lyricsCollection')]
        artistCollection = db[str('artistsCollection')]
        print(2)
        #csv_reader = csv.reader(artistDownloaded_var)
        csv_reader = csv.reader(lyricsDownloaded_var, delimiter=',')
        header = next(csv_reader)

        print(3)
        documents  = []
        doc = {}
        artistDocuments = list(artistCollection.find())

        i=0
        for row in csv_reader:
            if i == 20:
                break
            #get artist document       
            matching_dict = list((d for d in artistDocuments if row[0] == d['link']))
            doc['artist'] = matching_dict[0]

            doc['songName'] = row[1]
            doc['songLink'] = row[2]
            doc['lyric'] = row[3]
            doc['language'] = row[4]
            documents.append(doc)
            print(doc)
            doc = {}
            i+=1

        #collection.insert_many(documents)

        return documents
    except Exception as e:
        print("Unexpected error:", e)
        return 0
    return 1    
"""
-----------------------------------------------------------------------------------------------
"""


"""
-----------------------------------------------------------------------------------------------
Download the file from the blob storage
ENTRIES: The filename and the path
OUTPUT: The file downloaded
-----------------------------------------------------------------------------------------------
"""
def downloadFile(filename, filePath):
    try:        
        # Connection with blob storage
        blob_service_client = BlobServiceClient.from_connection_string(connectionString)
        container_client = blob_service_client.get_container_client('documents')
        blob_client = container_client.get_blob_client(filename)
        print(1)
        # Opens and reads the archive
        with open(filePath, "wb") as my_blob:
            download_stream = blob_client.download_blob()
            my_blob.write(download_stream.readall())

        currentFile = open(filePath, 'r', encoding='utf-8')
        #parseArtistsFile(currentFile)
        print(f"File {filename} downloaded to {filePath}")
        return currentFile
    except Exception as e:
        print(e)
 
    
def main():
    lyricsDownloaded = open('lyrics-data.csv', 'r', encoding='utf-8')
    parseLyrics(lyricsDownloaded)
    
    '''
    client = MongoClient(uri)  #Mongo Client
    client = MongoClient(uri, server_api=ServerApi('1'))
    #Prueba conexión con Mongo DB
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!") 

    db = client[str('OpenLyricsSearch')]
    collection = db[str("artistsCollection")]

    query = ( collection.find())
    print(query)
    return
    for document in query:
        print(document)
    '''


    
if __name__ == '__main__': 
    main()