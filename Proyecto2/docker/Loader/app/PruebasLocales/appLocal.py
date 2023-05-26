# Este archivo tendrá la aplicacion loader que se encarga de subir los archivos a mongoDB

#------------------------------------------------Imports-------------------------------------------------
#from azure.storage.blob import BlobServiceClient
import io
from pathlib import Path
import os
import sys
import csv
import random

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
                print(doc)
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
        print("Successfully connected to MongoDB") 

        db = client[str('OpenLyricsSearch')]  #Database to be use
        collection = db[str('lyricsCollection')] #Collection to be use
        
        #Csv reader to parse the csv file
        csv_reader = csv.reader(lyricsDownloaded_var, delimiter=',')
        header = next(csv_reader) #skip the header

        documents  = []   #list of documents to be inserted
        doc = {} #document to be inserted in the database
        
        artistCollection = db[str('artistsCollection')] #Collection of artists
        artistDocuments = list(artistCollection.find()) #list of artists documents
        songLinks = collection.distinct("songLink") #list of song names in the database
        
        max = 0
        for row in csv_reader: 
            if max == 100:
                break
            #Obtain the artist document from the list of artists documents
            matching_dict = list((d for d in artistDocuments if row[0] == d['link']))
            #Case 1: The artist is not in the database
            if (matching_dict.__len__() == 0):
                print("The artist " + row[0] + " is not in the database")
                continue

            #Case 2: The song is not in the database
            elif(row[2] not in songLinks):
                #Parse of the csv file
                doc['artist'] = matching_dict[0]["artist"]
                doc['genres'] = selectRandomGenre(matching_dict[0]["genres"])
                doc['popularity'] = float(matching_dict[0]["popularity"])
                doc['songs'] = matching_dict[0]["songs"]
                doc['artistLink'] = matching_dict[0]["link"]
                doc['songName'] = row[1]
                doc['songLink'] = row[2]
                doc['lyric'] = row[3]
                doc['language'] = row[4]

                #Add the song name and the artist name to the list of song names in the database
                songLinks.append(row[2]) 

                #Add the document to the list of documents
                documents.append(doc)
                doc = {} #reset the document
                print("The song " + row[1] + " by " + matching_dict[0]["artist"] + " is already on the collection")

                max = max + 1	
            #else:
                #print("The song " + row[1] + " by " + matching_dict[0]["artist"] + " is already on the collection")

        #Insert the list of documents into the database
        collection.insert_many(documents)
        
        #Close the connection	
        client.close()
        return 1
    except Exception as e:
        print("Unexpected error:", e)
        return 0
    return 1    
"""
-----------------------------------------------------------------------------------------------
"""

def selectRandomGenre(genres):
    genreIndex = random.randint(0, genres.__len__()-1)
    selectedGenre = genres[genreIndex]
    return selectedGenre


def main():
    #artistDownloaded = open('artists-data.csv', 'r', encoding='utf-8')
    #parseArtists(artistDownloaded)
    
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