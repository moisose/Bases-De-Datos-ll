from azure.storage.blob import BlobServiceClient
from flask import Flask, flash, request, send_file
from flask_cors import CORS

# Definition of the API
app = Flask(__name__)
CORS(app)

"""
Apache Lucene

Endpoints para traer opciones de:
artistas
lenguajes
generos

===================================
Endpoint para traer resultados que filtre por:
frase buscada
artista
lenguaje
genero
popularidad
numero de canciones

El endpoint devuelve: 
Nombre de la canción, artista, pequeño fragmento donde esté la palabra que se busca
===================================

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

@app.route('/', methods = ['GET'])
def main():
    return {"message": "Welcome to the API with example responses!"}

"""
artistas
lenguajes
generos
"""

@app.route('/facets/list', methods = ['GET'])
def facets():
    artists = [{"name":"Foster The People"}, {"name":"Tame Impala"}, {"name":"Mac Demarco"}]
    languages = [{"name":"Spanish"}, {"name":"English"}, {"name":"Portuguese"}]
    genres = [{"name":"Pop"}, {"name":"Rock"}, {"name":"Jazz"}, {"name":"Hip Hop"}]

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
@app.route('/search/<string:phrase>/<string:artist>/<string:language>/<string:gender>/<string:popularity>/<int:amountOfSongs>', methods = ['GET'])
def search(phrase, artist, language, gender, popularity, amountOfSongs):
    example1 = {"name":"Example 1", "artist":"Artist 1", "fragment":"This is phrase 1"}
    example2 = {"name":"Example 2", "artist":"Artist 2", "fragment":"This is phrase 2"}
    example3 = {"name":"Example 3", "artist":"Artist 3", "fragment":"This is phrase 3"}
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
@app.route('/details/<string:name>/<string:artist>', methods = ['GET'])
def details(name, artist):
    data = {"artist": "Artist 1", "genres": ["Genre 1", "Genre 2"], "songs": 10, "popularity": 10, "link": "https://www.google.com", "title": "Title 1", "lyrics": "Este es el verso 1\nEste es el verso 2\nEste es el verso 3\nEste es el verso 4\nEste es el verso 5\nEste es el verso 6\nEste es el verso 7\nEste es el verso 8\nEste es el verso 9\nEste es el verso 10"}
    return {"data": data}

# Run the app
if __name__ == '__main__': 
    app.run(debug=True)