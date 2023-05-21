# Imports
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

UserName = 'MelSaFer'
Password = '3trZoWOalvOKN7tQ'
DatabaseName = 'OpenLyricsSearch'
ArtistsCollection = 'artistsCollection'
LyricsCollection = 'lyricsCollection'

uri = "mongodb+srv://" + str(UserName) + ":" + str(Password) + \
    "@mangos.ybmshbl.mongodb.net/" + str(DatabaseName)

# Definition of the API
app = Flask(__name__)
CORS(app)

# Link del api: https://main-app.politebush-c6efad18.eastus.azurecontainerapps.io/


@app.route('/', methods=['GET'])
def main():
    return {"message": "Welcome to the API with example responses!"}


"""
Este endpoint devuelve la lista de artistas, lenguajes y generos de las canciones que contienen la letra especifica
"""


@app.route('/facets/list/<string:phrase>', methods=['GET'])
def facets(phrase):
    artists = [{"name": "Foster The People"}, {
        "name": "Tame Impala"}, {"name": "Mac Demarco"}]
    languages = [{"name": "Spanish"}, {
        "name": "English"}, {"name": "Portuguese"}]
    genres = [{"name": "Pop"}, {"name": "Rock"},
              {"name": "Jazz"}, {"name": "Hip Hop"}]

    return {"artists": artists, "languages": languages, "genres": genres}


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


@app.route('/search/<string:phrase>/<string:artist>/<string:language>/<string:gender>/<string:popularity>/<int:amountOfSongs>', methods=['GET'])
def search(phrase, artist, language, gender, popularity, amountOfSongs):
    example1 = {"name": "Example 1", "artist": "Artist 1",
                "fragment": "This is phrase 1"}
    example2 = {"name": "Example 2", "artist": "Artist 2",
                "fragment": "This is phrase 2"}
    example3 = {"name": "Example 3", "artist": "Artist 3",
                "fragment": "This is phrase 3"}
    data = [example1, example2, example3]
    return {"data": data}


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


@app.route('/details/<string:name>/<string:artist>', methods=['GET'])
def details(name, artist):
    data = {"artist": "Artist 1", "genres": ["Genre 1", "Genre 2"], "songs": 10, "popularity": 10, "link": "https://www.google.com", "title": "Title 1",
            "lyrics": "Este es el verso 1\nEste es el verso 2\nEste es el verso 3\nEste es el verso 4\nEste es el verso 5\nEste es el verso 6\nEste es el verso 7\nEste es el verso 8\nEste es el verso 9\nEste es el verso 10"}
    return {"data": data}


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
        #             ],
        #             'genresFacet': [
        #                 {
        #                     '$group': {
        #                         '_id': '$genres',
        #                         'documents': {'$push': '$$ROOT'}
        #                     }
        #                 }
        #             ]
        #         }
        #     }
        # ]

        # Query que agrupa los documentos por artista y por género y devuelve los documentos que coinciden con la búsqueda y se hace el
        # match con el artista
        pipeline = [
            {
                '$search': {
                    'index': 'default',
                    'text': {
                        'query': 'Quando',
                        'path': 'lyric'
                    }
                }
            },
            {
                '$match': {
                    'artist': 'Ivete Sangalo'
                }
            },
            {
                '$facet': {
                    'artistFacet': [
                        {
                            '$group': {
                                '_id': '$artist',
                                'documents': {'$push': '$$ROOT'}
                            }
                        }
                    ],
                    'genresFacet': [
                        {
                            '$group': {
                                '_id': '$genres',
                                'documents': {'$push': '$$ROOT'}
                            }
                        }
                    ]
                }
            }
        ]

        # Ejecutar la consulta y obtener los resultados
        result = collection.aggregate(pipeline)

        results = []

        # Procesar los resultados
        for document in result:
            # Hacer algo con el documento
            results.append(str(document))
            # print(document)

        return {"data": results}
    except Exception as e:
        return {"Error": str(e)}


# Run the app
if __name__ == '__main__':
    app.run(debug=True)
