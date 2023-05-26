# Imports
import os
from azure.storage.blob import BlobServiceClient
from flask import Flask, flash, request, send_file
from flask_cors import CORS

# Mongo Atlas imports
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import pymongo.errors


#Env Variables------------------------------------------------------------------------------------		
UserName= os.getenv('USERNAME')
Password= os.getenv('PASSWORD')
DatabaseName= os.getenv('DATABASE')
ArtistsCollection= os.getenv('ARTISTS_COLLECTION')
LyricsCollection= os.getenv('LYRICS_COLLECTION')

# Mongo Atlas connection string
uri = "mongodb+srv://" + str(UserName) + ":" + str(Password) + \
    "@mangos.ybmshbl.mongodb.net/" + str(DatabaseName)

# Definition of the API
app = Flask(__name__)
CORS(app)

# ====================================================================================================
# Auxiliar functions

"""
Method mainPhrase

Method that receives a list of highlights and returns the main phrase of the song related to the search
"""
def mainPhrase(highlights):
    phrase = ""
    highlightList = []
    hitFlag = False
    for highlight in highlights:
        if highlight['type'] == 'hit':
            phrase += highlight['value']
            hitFlag = True
            highlightList.append(highlight)
        elif highlight['type'] == 'text' and hitFlag == True:
            if len(phrase) <= 80:
                if '\n' in highlight['value']:
                    phrase += highlight['value'].split('\n')[0]
                    tempHighlight = {'type': 'text', 'value': highlight['value'].split('\n')[0]}
                    highlightList.append(tempHighlight)
                    break
                else:
                    phrase += highlight['value']
                    highlightList.append(highlight)
            else:
                break
    return [phrase, highlightList]

"""
Method shortLyric

Method that receives a lyric and returns the closest 4 lines of the song related to the search
"""

def shortLyric(lyric, substring):
    jumps = 0
   
    lyricsArray = lyric.split('\n')
    endIndex = len(lyricsArray) - 1
    
    newString = ''

    jumps = 0
    find = False
    for i, line in enumerate(lyricsArray):

        if jumps <= 4 and find == False:
            newString += line + '\n'

        if (substring in line or find):
            if find == False:
                find = True
                newString = ''
                jumps = 0
                if endIndex == i:
                    for j in range(4):
                        newString += lyricsArray[i - (4 - j)] + '\n'
                        break

            if line == '':
                jumps -= 1
            if jumps >= 4:
                break

            newString += line + '\n'
            
        jumps += 1

    return newString

"""
Method artistFilter

Method that adds the artist filter to the pipeline query if the artist is specified
"""
def artistFilter(pipeline, artist):
    match = {
        '$match': {
            'artist': artist
        }
    }
    pipeline.append(match)

"""
Method genreFilter

Method that adds the genre filter to the pipeline query if the genre is specified
"""
def genreFilter(pipeline, genre):
    match = {
        '$match': {
            'genres': genre
        }
    }
    pipeline.append(match)

"""
Method languageFilter

Method that adds the language filter to the pipeline query if the language is specified
"""
def languageFilter(pipeline, language):
    match = {
        '$match': {
            'language': language
        }
    }
    pipeline.append(match)

"""
Method popularityFilter

Method that adds the popularity filter to the pipeline query if the popularity is specified
"""
def popularityFilter(pipeline, minPop, maxPop):
    match = {
        '$match': {
            'popularity': {
                '$gte': float(minPop),
                '$lte': float(maxPop)
            }
        }
    }
    pipeline.append(match)

"""
Method amountOfSongsFilter

Method that adds the amount of songs filter to the pipeline query if the amount of songs is specified
"""
def amountOfSongsFilter(pipeline, amountOfSongs):
    limit = {
        '$limit': amountOfSongs
    }
    pipeline.append(limit)


"""
Method removeRepeatedGenres

Method that receives a list of genres and returns a list of genres without repeated genres
"""

def removeRepeatedGenres(genres):
    genresList = []
    for genre in genres:
        if genre not in genresList:
            genresList.append(genre)
    return genresList

# ====================================================================================================
# API Endpoints

"""
Facets Endpoint 
This endpoint returns the artist list, the genres list and the languages list that have a relation with the lyrics searched
"""
@app.route('/facets/list/<string:phrase>', methods=['GET'])
def facets(phrase):
    try:
        client = MongoClient(str(uri))

        db = client.get_database(str(DatabaseName))

        collection = db.get_collection(str(LyricsCollection))

        pipeline = [
            {
                '$search': {
                    'index': 'default',
                    'text': {
                        'query': phrase,
                        'path': 'lyric'
                    }
                }
            },
            {
                '$facet': {
                    'languageFacet': [
                        {
                            '$group': {
                                '_id': '$language',
                            }
                        }
                    ],
                    'genresFacet': [
                        {
                            '$group': {
                                '_id': '$genres',
                            }
                        }
                    ],
                    'artistFacet': [
                        {
                            '$group': {
                                '_id': '$artist'
                            }
                        }
                    ]

                }
            }
        ]

        results = collection.aggregate(pipeline)

        languages = []
        artists = []
        genres = []

        for document in results:
            for language in document['languageFacet']:
                tmpLanguage = {"name": language['_id']}
                languages.append(tmpLanguage)

            for artist in document['artistFacet']:
                tmpArtist = {"name": artist['_id']}
                artists.append(tmpArtist)

            for genre in document['genresFacet']:
                tmp = genre['_id']
                if tmp[0] == " ":
                    tmp = tmp[1:]
                tmpGenre = {"name": tmp}
                genres.append(tmpGenre)

        return {"languages": languages, "artists": artists, "genres": removeRepeatedGenres(genres)}
    except pymongo.errors.PyMongoError as e:
        return {"Error":str(e)}


"""
Search Endpoint

This endpoint returns the songs that have a relation with the lyrics searched and the filters applied
"""

@app.route('/search/<string:phrase>/<string:artist>/<string:language>/<string:genre>/<string:minPop>/<string:maxPop>/<string:amountOfSongs>', methods=['GET'])
def search(phrase, artist, language, genre, minPop, maxPop, amountOfSongs):
    try:
        client = MongoClient(str(uri))

        db = client.get_database(str(DatabaseName))

        collection = db.get_collection(str(LyricsCollection))

        searchPipeline = [
            {
                '$search': {
                    'index': 'default',
                    'text': {
                        'query': phrase,
                        'path': 'lyric'
                    }
                }
            }
        ]

        highlightsPipeline = [
            {
                '$search': {
                    'index': 'default',
                    'text': {
                        'query': phrase,
                        'path': 'lyric'
                    },
                    'highlight': {
                        'path': 'lyric'
                    }
                }
            },
            {
                '$project': {
                    'highlights': {'$meta': 'searchHighlights'}
                }
            }
        ]

        if artist != "null":
            artistFilter(searchPipeline, artist)
        
        if language != "null":
            languageFilter(searchPipeline, language)

        if genre != "null":
            genreFilter(searchPipeline, genre)
        
        if minPop != "-1" and maxPop != "-1":
            popularityFilter(searchPipeline, minPop, maxPop)
        
        if amountOfSongs != "-1":
            amountOfSongsFilter(searchPipeline, int(amountOfSongs))

        results = collection.aggregate(searchPipeline)
        highlights = collection.aggregate(highlightsPipeline)

        data = []

        for document in results:
            tempId = str(document['_id'])
            tempDoc = {'_id': tempId,'artist': document['artist'], 'songLink': document['songLink'],
                       'songName': document['songName'], 'popularity': document['popularity']}
            tempHighlights = []
            for highlight in highlights:
                if str(highlight['_id']) == tempId:
                    tempHighlights = highlight['highlights']
                    break

            highestScore = 0
            highestHighlight = None
            for highlightedPhrase in tempHighlights:
                if highlightedPhrase['score'] > highestScore:
                    highestScore = highlightedPhrase['score']
                    highestHighlight = highlightedPhrase

            try:
                processedHighlights = mainPhrase(highestHighlight['texts'])
                tempDoc['highlights'] = processedHighlights[1]
                tempDoc['lyric'] = shortLyric(document['lyric'], processedHighlights[0])
            except:
                pass
            data.append(tempDoc)

        return {"data": data}
    except pymongo.errors.PyMongoError as e:
        return {"Error":str(e)}    


"""
Details Endpoint

This endpoint returns the details of a song based on its link
"""
@app.route('/details/<string:artist>/<string:songName>', methods=['GET'])
def details(artist, songName):
    try:
        client = MongoClient(str(uri))

        db = client.get_database(str(DatabaseName))

        collection = db.get_collection(str(LyricsCollection))

        songLink = "/" + artist + "/" + songName

        pipeline = [
            {
                '$search': {
                    'index': 'default',
                    'text': {
                        'query': songLink,
                        'path': 'songLink'
                    }
                }
            },
            {
                '$limit': 1
            }
        ]

        results = collection.aggregate(pipeline)

        data = []
        for document in results:
            tempDoc = {'artist': document['artist'], 'genres': document['genres'], 'popularity': document['popularity'],
                       'songs': document['songs'], 'songLink': document['songLink'], 'songName': document['songName'], 'lyric': document['lyric']}
            data.append(tempDoc)

        return {"data": data}
    except pymongo.errors.PyMongoError as e:
        return {"Error":str(e)}


# Run the app
if __name__ == '__main__':
    app.run(debug=True)
