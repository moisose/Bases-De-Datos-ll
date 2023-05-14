
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



def parseArtists(artistDownloaded_var):
    #csv_reader = csv.reader(artistDownloaded_var)
    csv_reader = csv.reader(artistDownloaded_var, delimiter=',')
    header = next(csv_reader)  # Read the header row
    for row in csv_reader:
        Artist = row[0]
        Genres = row[1]
        print(Artist + " - " + Genres )
            
    return 1
 
 
    
def main():
    #artistDownloaded = downloadFile(Artist_File, path_File + "\\" + Artist_File)
    #lyricsDownloaded = downloadFile(Lyrics_File, path_File + "\\" + Lyrics_File)
    #print(artistDownloaded.read())
    downloadFile = open("artists-data.csv", 'r', encoding='utf-8')	
    parseArtists(downloadFile)

if __name__ == '__main__': 
    main()