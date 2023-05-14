
import io
from pathlib import Path
import os
import sys
import csv

#Mongo db libraries--------------------------------------------------------------------------------------
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

#Variables de entorno------------------------------------------------------------------------------------	


uri = "mongodb+srv://MelSaFer:3trZoWOalvOKN7tQ@mangos.ybmshbl.mongodb.net/OpenLyricsSearch"


containerName = "documents"
path_File = '\\downloadedFiles'
Artist_File="artists-data.csv"
Lyrics_File="lyrics-data.csv"
#fileName = "artists-data.csv"
artistDownloaded = None
lyricsDownloaded = None
ArtistsCollection = "artistsCollection"
DatabaseName = "OpenLyricsSearch"



def parseArtists(artistDownloaded_var):
    try:
        client = MongoClient(uri)  #Mongo Client
        client = MongoClient(uri, server_api=ServerApi('1'))
        #Prueba conexión con Mongo DB
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!") 

        db = client[DatabaseName]
        collection = db[ArtistsCollection]

        #csv_reader = csv.reader(artistDownloaded_var)
        csv_reader = csv.reader(artistDownloaded_var, delimiter=',')
        header = next(csv_reader)  # Read the header row

        documents  = []
        doc = {}

        c = 0
        for row in csv_reader:
            if c == 20:
                break
            doc['artist'] = row[0]
            #parsing genres
            doc['genres'] = row[1].split(';')
            doc['songs'] = row[2]
            doc['popularity'] = row[3]
            doc['link'] = row[4]
            documents.append(doc)
            print(doc)
            doc = {}
            c += 1

        result = collection.insert_many(documents)
        print("Insertados los IDs de los documentos:", result.inserted_ids)
        client.close()
    except Exception as e:
        print("Unexpected error:", e)

    return 1    
 
def parseLyrics(lyricsDownloaded_var):
    try:
        '''
        client = MongoClient(uri)  #Mongo Client
        client = MongoClient(uri, server_api=ServerApi('1'))
        #Prueba conexión con Mongo DB
        client.admin.command('ping')
        print("Pinged your deployment. You successfully connected to MongoDB!") 

        db = client['mydatabase']
        collection = db['Lyric']
        '''

        #csv_reader = csv.reader(artistDownloaded_var)
        csv_reader = csv.reader(lyricsDownloaded_var, delimiter=',')
        header = next(csv_reader)  # Read the header row

        documents  = []
        doc = {}

        for row in csv_reader:
            doc['artistLink'] = row[0]
            doc['songName'] = row[1]
            doc['songLink'] = row[2]
            doc['lyric'] = row[3]
            doc['language'] = row[4]
            documents.append(doc)
            print(doc)
            doc = {}
        
        #print(documents)
        
        #result = collection.insert_many(documents)
        #print("Insertados los IDs de los documentos:", result.inserted_ids)

    except Exception as e:
        print("Unexpected error:", e)
            
    return 1
 
    
def main():
    #artistDownloaded = downloadFile(Artist_File, path_File + "\\" + Artist_File)
    #lyricsDownloaded = downloadFile(Lyrics_File, path_File + "\\" + Lyrics_File)
    #print(artistDownloaded.read())

    downloadFile = open("artists-data.csv", 'r', encoding='utf-8')	
    parseArtists(downloadFile)
    
    downloadFile = open("lyrics-data.csv", 'r', encoding='utf-8')
    #parseLyrics(downloadFile)

if __name__ == '__main__': 
    main()
