# Imports
import os
from azure.storage.blob import BlobServiceClient
from flask import Flask, flash, request, send_file
from flask_cors import CORS

# Mongo Atlas imports
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

"""

USERNAME='MelSaFer'
PASSWORD='3trZoWOalvOKN7tQ'
DATABASE='OpenLyricsSearch'
ARTISTS_COLLECTION='artistsCollection'
LYRICS_COLLECTION='lyricsCollection'
ARTISTS_FILE='artists-data.csv'
LYRICS_FILE='lyrics-data.csv'

"""
"""
#Env Variables------------------------------------------------------------------------------------		
UserName= os.getenv('USERNAME')
Password= os.getenv('PASSWORD')
DatabaseName= os.getenv('DATABASENAME')
ArtistsCollection= os.getenv('ARTISTS_COLLECTION')
LyricsCollection= os.getenv('LYRICS_COLLECTION')

"""
UserName = 'MelSaFer'
Password = '3trZoWOalvOKN7tQ'
DatabaseName = 'OpenLyricsSearch'
ArtistsCollection = 'artistsCollection'
LyricsCollection = 'lyricsCollection'
# """

uri = "mongodb+srv://" + str(UserName) + ":" + str(Password) + \
    "@mangos.ybmshbl.mongodb.net/" + str(DatabaseName)

# Definition of the API
app = Flask(__name__)
CORS(app)

# Link del api: https://main-app.politebush-c6efad18.eastus.azurecontainerapps.io/


def shortLyric(lyric):
    jumps = 0
    index = len(lyric)

    for i, char in enumerate(lyric):
        if char == '\n':
            jumps += 1
            if jumps == 4:
                index = i
                break

    return lyric[:index]


@app.route('/', methods=['GET'])
def main():
    return {"message": "Welcome to the API with example responses!"}


"""
Este endpoint devuelve la lista de artistas, lenguajes y generos de las canciones que contienen la letra especifica
"""


@app.route('/facets/list/<string:phrase>', methods=['GET'])
def facets(phrase):
    try:
        client = MongoClient(uri)

        # Obtener una referencia a la base de datos
        db = client.get_database(DatabaseName)

        # Obtener una referencia a la colección
        collection = db.get_collection(LyricsCollection)

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
                                '_id': None,
                                'allGenres': {'$push': '$genres'}
                            }
                        },
                        {
                            '$project': {
                                '_id': 0,
                                'allGenres': {'$concatArrays': '$allGenres'}
                            }
                        },
                        {
                            '$project': {
                                'flattenedArray': {
                                    '$reduce': {
                                        'input': "$allGenres",
                                        'initialValue': [],
                                        'in': {'$concatArrays': ["$$value", "$$this"]}
                                    }
                                }
                            }
                        },
                        {'$unwind': "$flattenedArray"},
                        {'$group': {'_id': "$flattenedArray"}},
                        {'$project': {'_id': 0, 'genres': "$_id"}}
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

        # Close the connection
        client.close()

        languages = []
        artists = []
        genres = []

        # Procesar los resultados
        for document in results:
            for language in document['languageFacet']:
                tmpLanguage = {"name": language['_id']}
                languages.append(tmpLanguage)

            for artist in document['artistFacet']:
                tmpArtist = {"name": artist['_id']}
                artists.append(tmpArtist)

            for genre in document['genresFacet']:
                tmp = genre['genres']
                if tmp[0] == " ":
                    tmp = tmp[1:]
                tmpGenre = {"name": tmp}
                genres.append(tmpGenre)

        return {"languages": languages, "artists": artists, "genres": genres}
    except Exception as e:
        return {"Error": e}


"""
Endpoint Search

Recibe:
frase buscada (obligatorio)
artista (opcional)
lenguaje (opcional)
genero (opcional)
popularidad (opcional)
numero de canciones (opcional)

El endpoint devuelve: 
Nombre de la canción, artista, pequeño fragmento donde esté la palabra que se busca

"""


@app.route('/search/phrase/<string:phrase>', methods=['GET'])
def searchPhrase(phrase):
    try:
        client = MongoClient(uri)

        # Obtener una referencia a la base de datos
        db = client.get_database(DatabaseName)

        # Obtener una referencia a la colección
        collection = db.get_collection(LyricsCollection)

        pipeline = [
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

        results = collection.aggregate(pipeline)

        # Close the connection
        client.close()
        data = []
        # Procesar los resultados
        for document in results:
            tempDoc = {"name": document['songName'], "artist": document['artist'], "lyric": shortLyric(
                document['lyric']), "songLink": document['songLink']}
            data.append(tempDoc)

        return {"data": data}
    except Exception as e:
        return {"Error": e}


@app.route('/search/<string:phrase>/<string:artist>/<string:language>/<string:gender>/<int:minPop>/<int:maxPop>/<int:amountOfSongs>', methods=['GET'])
def search(phrase, artist, language, gender, minPop, maxPop, amountOfSongs):

    try:
        client = MongoClient(uri)

        # Obtener una referencia a la base de datos
        db = client.get_database(DatabaseName)

        # Obtener una referencia a la colección
        collection = db.get_collection(LyricsCollection)

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
                '$match': {
                    'artist': artist,
                    'language': language,
                    'gender': gender,
                    'popularity': {'$gte': minPop, '$lte': maxPop}
                }
            },
            {
                '$project': {
                    '_id': 0
                }
            }
        ]

        results = collection.aggregate(pipeline)

        # Close the connection
        client.close()
        data = []
        # Procesar los resultados
        for document in results:
            tempDoc = {"name": document['name'], "artist": document['artist'],
                       "lyric": document['lyric'], "songLink": document['songLink']}

        return {"data": data}
    except Exception as e:
        return {"Error": e}


"""

Endpoint de detalles:
Recibe: Nombre y artista de la canción
Devuelve:
Full Documento especifico que se pide

Nombre del artista
generos
cantidad de canciones
popularidad
link
titulo de la cancion
letra completa

"""


@app.route('/details/<string:artist>/<string:songName>', methods=['GET'])
def details(artist, songName):
    try:
        client = MongoClient(uri)

        # Obtener una referencia a la base de datos
        db = client.get_database(DatabaseName)

        # Obtener una referencia a la colección
        collection = db.get_collection(LyricsCollection)
        
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

        # Close the connection
        client.close()
        data = []
        # Procesar los resultados
        for document in results:
            tempDoc = {'artist': document['artist'], 'genres': document['genres'], 'popularity': document['popularity'], 'songs': document['songs'], 'songLink': document['songLink'], 'songName': document['songName'], 'lyric': document['lyric']}
            data.append(tempDoc)
        
        return {"data": data}
    except Exception as e:
        return {"Error": e}


@app.route('/test', methods=['GET'])
def test():
    try:
        client = MongoClient(uri)

        # Obtener una referencia a la base de datos
        db = client.get_database(DatabaseName)

        # Obtener una referencia a la colección
        collection = db.get_collection(LyricsCollection)

        # Ejecutar una consulta utilizando un índice específico

        # Query que agrupa los documentos por artista y por género y la cantidad de documentos que coinciden con la búsqueda
        # pipeline = [
        #         {
        #         '$search': {
        #             'index': 'default',
        #             'text': {
        #                 'query': 'Quando',
        #                 'path': 'lyric'
        #             }
        #         }
        #     },
        #     {
        #         '$facet': {
        #             'artistFacet': [
        #                 {
        #                     '$bucketAuto': {
        #                         'groupBy': '$artist',
        #                         'buckets': 10,
        #                         'output': {
        #                             'count': { '$sum': 1 }
        #                         }
        #                     }
        #                 }
        #             ],
        #             'genresFacet': [
        #                 {
        #                     '$bucketAuto': {
        #                         'groupBy': '$genres',
        #                         'buckets': 10,
        #                         'output': {
        #                             'count': { '$sum': 1 }
        #                         }
        #                     }
        #                 }
        #             ]
        #         }
        #     }
        # ]

        # Query que agrupa los documentos por artista y por género y devuelve los documentos que coinciden con la búsqueda
        # pipeline = [
        #     {
        #         '$search': {
        #             'index': 'default',
        #             'text': {
        #                 'query': 'Quando',
        #                 'path': 'lyric'
        #             }
        #         }
        #     },
        #     {
        #         '$facet': {
        #             'artistFacet': [
        #                 {
        #                     '$group': {
        #                         '_id': '$artist',
        #                         'documents': {'$push': '$$ROOT'}
        #                     }
        #                 }
        #             ]
        #         }
        #     }
        # ]

        # Query que agrupa los documentos por artista y por género y devuelve los documentos que coinciden con la búsqueda y se hace el
        # match con el artista
        # pipeline = [
        #     {
        #         '$search': {
        #             'index': 'default',
        #             'text': {
        #                 'query': 'Quando',
        #                 'path': 'lyric'
        #             }
        #         }
        #     },
        #     {
        #         '$facet': {
        #             'languageFacet': [
        #                 {
        #                     '$group': {
        #                         '_id': '$language',
        #                     }
        #                 }
        #             ],
        #             'genresFacet': [
        #                 {
        #                     '$group': {
        #                         '_id': None,
        #                         'allGenres': {'$push': '$genres'}
        #                     }
        #                 },
        #                 {
        #                     '$project': {
        #                         '_id': 0,
        #                         'allGenres': {'$concatArrays': '$allGenres'}
        #                     }
        #                 },
        #                 {
        #                     '$project': {
        #                         'flattenedArray': {
        #                             '$reduce': {
        #                                 'input': "$allGenres",
        #                                 'initialValue': [],
        #                                 'in': {'$concatArrays': ["$$value", "$$this"]}
        #                             }
        #                         }
        #                     }
        #                 },
        #                 {'$unwind': "$flattenedArray"},
        #                 {'$group': {'_id': "$flattenedArray"}},
        #                 {'$project': {'_id': 0, 'genres': "$_id"}}
        #             ],
        #             'artistFacet': [
        #                 {
        #                     '$group': {
        #                         '_id': '$artist'
        #                     }
        #                 }
        #             ]
        #         }
        #     }
        # ]

        # /pink-floyd/another-brick-in-the-wall-part-1-2-3.html
        #/pabllo-vittar/parabens-part-psirico.html
        pipeline = [
            {
                '$search': {
                    'index': 'default',
                    'text': {
                        'query': '/pink-floyd/another-brick-in-the-wall-part-1-2-3.html',
                        'path': 'songLink'
                    }
                }
            },
            {
                '$limit': 1
            }
        ]

        # Ejecutar la consulta y obtener los resultados
        results = collection.aggregate(pipeline)

        result = []

        # Procesar los resultados
        for document in results:
            # Hacer algo con el documento
            result.append(str(document))
            # print(document)

        return {"data": result}
    except Exception as e:
        return {"Error": str(e)}


# Run the app
if __name__ == '__main__':
    app.run(debug=True)
