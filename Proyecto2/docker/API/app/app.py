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

uri = "mongodb+srv://" + str(UserName) + ":" + str(Password) + "@mangos.ybmshbl.mongodb.net/" + str(DatabaseName)

# Definition of the API
app = Flask(__name__)
CORS(app)

# Link del api: https://main-app.politebush-c6efad18.eastus.azurecontainerapps.io/


@app.route('/', methods=['GET'])
def main():
    return {"message": "Welcome to the API with example responses!"}


"""
artistas
lenguajes
generos
"""


@app.route('/facets/list', methods=['GET'])
def facets():
    artists = [{"name": "Foster The People"}, {
        "name": "Tame Impala"}, {"name": "Mac Demarco"}]
    languages = [{"name": "Spanish"}, {
        "name": "English"}, {"name": "Portuguese"}]
    genres = [{"name": "Pop"}, {"name": "Rock"},
              {"name": "Jazz"}, {"name": "Hip Hop"}]

    return {"artists": artists, "languages": languages, "genres": genres}


"""
Search

frase buscada
artista
lenguaje
genero
popularidad
numero de canciones

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
Nombre del artista
generos
cantidad de canciones
popularidad
link
titulo de la cancion
letra completa

doc['artist'] = row[0]
doc['genres'] = row[1].split(';')
doc['songs'] = row[2]
doc['popularity'] = row[3]
doc['link'] = row[4]

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
        pipeline = [
            {"$search": {
                "index": "LyricsIndex",
                "text": {
                    "query": "Quando",
                    "path": "lyric"
                    }
                }
            }
        ]

        """
        {
                "$search": {
                    "index": "default",
                    "text": {
                        "query": "rock",
                        "path": {
                            "wildcard": "*"
                            }
                    }
                }}
        """

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


"""
from pymongo import MongoClient

# Conexión a la base de datos de MongoDB Atlas
client = MongoClient("mongodb+srv://<username>:<password>@<cluster-url>/test?retryWrites=true&w=majority")
db = client["mydatabase"]  # Nombre de tu base de datos
collection = db["mycollection"]  # Nombre de tu colección

# Definir los campos de facetas que deseas incluir
facets = {
    "campo_faceta_1": [
        {"$sortByCount": "$campo_faceta_1"},
        {"$limit": 5}
    ],
    "campo_faceta_2": [
        {"$sortByCount": "$campo_faceta_2"},
        {"$limit": 5}
    ]
}

# Definir la consulta de búsqueda
query = {
    "campo_busqueda": "valor_búsqueda"
}

# Definir los campos que deseas recuperar en los resultados
projection = {
    "campo1": 1,
    "campo2": 1
}

# Realizar la búsqueda con facetas
result = collection.aggregate([
    {"$match": query},
    {"$facet": facets},
    {"$project": projection}
])

# Iterar sobre los resultados
for doc in result:
    print(doc)


===================================
from pymongo import MongoClient

# Conectar a la base de datos de MongoDB Atlas
client = MongoClient("mongodb+srv://<username>:<password>@<cluster-url>/<database>?retryWrites=true&w=majority")

# Obtener una referencia a la colección
db = client.get_database("<database>")
collection = db.get_collection("<collection>")

# Obtener la lista de índices
indexes = collection.list_indexes()

# Recorrer los índices y obtener las facetas
facets = []
for index in indexes:
    if "facets" in index.get("options", {}):
        facets.append(index["options"]["facets"])

# Imprimir las facetas
print(facets)


===================================

from pymongo import MongoClient

# Conectar a la base de datos de MongoDB Atlas
client = MongoClient("mongodb+srv://<username>:<password>@<cluster-url>/<database>?retryWrites=true&w=majority")

# Obtener una referencia a la base de datos
db = client.get_database("<database>")

# Obtener una referencia a la colección
collection = db.get_collection("<collection>")

# Ejecutar una consulta utilizando un índice específico
result = collection.find({"<campo>": "<valor>"}).hint("<nombre_indice>")

# Procesar los resultados
for document in result:
    # Hacer algo con el documento
    print(document)


"""
