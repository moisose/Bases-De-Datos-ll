# Este archivo tendrá la aplicacion loader que se encarga de subir los archivos a mongoDB

#------------------------------------------------Imports-------------------------------------------------
from azure.storage.blob import BlobServiceClient
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
uri = "mongodb+srv://" + str(UserName) + ":" + str(Password) + "@mangos.ybmshbl.mongodb.net/" + str(DatabaseName)
# connectionString to the bolb storage
connectionString = "DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=KzcNb8ePMdcwCm5gO8/DJc9nY6fngiXFETmDtcdgBfoUPSo+/BowwJxxSdjVx8n0Trh72v9k/yrb+AStjPineQ==;EndpointSuffix=core.windows.net" 

Artist_File="artists-data.csv"
Lyrics_File="lyrics-data.csv"
ProcessedFiles = "processedFiles.txt"
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
        print("Successfully connected to MongoDB") 

        db = client[str(DatabaseName)]  #Database to be use
        collection = db[str(ArtistsCollection)] #Database to be use

        #csv_reader to parse the csv file
        csv_reader = csv.reader(artistDownloaded_var, delimiter=',')
        header = next(csv_reader)  #skip the header

        documents  = []   #list of documents to be inserted
        doc = {}          #document to be inserted in the list of documents
 
        artistsNames = collection.distinct("artist")  #To verify if the artist is already in the database by name
        max = 0
        for row in csv_reader:
            if max == 100:
                break
            if not row[0] in artistsNames:
                #Parse of the csv file
                doc['artist'] = row[0]
                #parsing genres
                doc['genres'] = row[1].split(';')
                doc['songs'] = row[2]
                doc['popularity'] = row[3]
                doc['link'] = row[4]
                #Add the document to the list of documents
                documents.append(doc)  
                #Add the artist name to the list of artists names in the database
                artistsNames.append(row[0]) 
                doc = {}  #reset the document
                max = max + 1
            else:
                print(row[0] + " is already on the collection")
            #max = max + 1
        #Insert the list of documents into the database
        collection.insert_many(documents)
        client.close() #close the connection
    except Exception as e:
        print("Unexpected error:", e)
        return 0
    return 1    
"""
-----------------------------------------------------------------------------------------------
""" 


"""
-----------------------------------------------------------------------------------------------
Parse all the lyrics of the csv file and insert them into the database
ENTRIES: lyrics downloaded file
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
                doc['popularity'] = matching_dict[0]["popularity"]
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

                max = max + 1	
            else:
                print("The song " + row[1] + " by " + matching_dict[0]["artist"] + " is already on the collection")

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
        container_client = blob_service_client.get_container_client(containerName)
        blob_client = container_client.get_blob_client(filename)
        
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
 
"""
-----------------------------------------------------------------------------------------------
Get the files from the blob storage
ENTRIES: none
OUTPUT: none
-----------------------------------------------------------------------------------------------
"""

def getAllBlobFiles():
    try:
        # Connection with blob storage
        blob_service_client = BlobServiceClient.from_connection_string(connectionString)
        container_client = blob_service_client.get_container_client(containerName)

        # List all blobs in the container
        blob_list = container_client.list_blobs()

        # Download txt that contains the processed files
        processedFileTxt = downloadFile(ProcessedFiles, path_File + "\\" + ProcessedFiles)
        processedFiles = processedFileTxt.readlines()

        # Get the files that have been processed from the blob storage
        files = []
        for blob in blob_list:
            files.append(blob.name)

        # Process the files that haven't been processed yet
        newFile = open(path_File + "\\" + 'newFile.txt', 'wb')
        content = ""
        for fileName in files:
            if fileName not in processedFiles:
                currentFile = downloadFile(fileName, path_File + "\\" + fileName)
                
                # Verify if the file is an Artist or Lyrics file
                if "artists" in fileName:
                    parseArtists(currentFile)
                    pass

                elif "lyrics" in fileName:
                    parseLyrics(currentFile)
                    pass

                elif "processedFiles.txt" == fileName:
                    print("skip")
                    continue

            content = content + fileName + "\n"
            
        # Write the content in the new processed files txt
        newFile.write(content.encode('utf-8'))
        newFile.close()

        # Update the processed files txt in Blob Storage
        updateBlobFile(path_File + "\\" + 'newFile.txt')

        return files
    except Exception as e:
        print(e)


"""
-----------------------------------------------------------------------------------------------
Update a file in Blob Storage
ENTRIES: namefile, pathfile
OUTPUT: none
-----------------------------------------------------------------------------------------------

"""

def updateBlobFile(filepath):
    try:
        # Connection with blob storage
        blob_service_client = BlobServiceClient.from_connection_string(connectionString)
        container_client = blob_service_client.get_container_client(containerName)
        blob_client = container_client.get_blob_client(ProcessedFiles)

        # Uploads the new file to the blob
        with open(filepath, "rb") as data:
            content = data.readlines()
            # Convert the content to a string
            try:
                decoded_list = [element.decode('utf-8') for element in content]
                print(str(decoded_list))
            except Exception as e:
                print(e)

        # Convert the content to a string
        newContent = ""
        for line in decoded_list:
            newContent = newContent + line
        newContent = newContent.encode('utf-8') # Convert the new string to bytes

        blob_client.upload_blob(newContent, overwrite=True)  # Overwrites the existing blob

        print(f"File {ProcessedFiles} updated in Blob Storage with {filepath}")
    except Exception as e:
        print(e)


"""
-----------------------------------------------------------------------------------------------
Select a random genre from the list of genres
ENTRIES: list of genres
OUTPUT: selected genre
-----------------------------------------------------------------------------------------------
"""

def selectRandomGenre(genres):
    genreIndex = random.randint(0, len(genres)-1)
    selectedGenre = genres[genreIndex]
    return selectedGenre

#------------------------------------------------------------------------------------------
    
def main():
    #artistDownloaded = downloadFile(Artist_File, path_File + "\\" + Artist_File)
    #parseArtists(artistDownloaded)
    #lyricsDownloaded = downloadFile(Lyrics_File, path_File + "\\" + Lyrics_File)
    #parseLyrics(lyricsDownloaded)

    getAllBlobFiles()

if __name__ == '__main__': 
    main()