"""
Este archivo define una aplicacion que utiliza la sesión de Cassandra para subir los logs de
la aplicación de Thunkable a Cosmos DB de Cassandra.

Debe solicitar siempre el usuario y luego lo que se quiera agregar al log.

"""

from cassandra.cluster import Cluster


# Define el string de conexión a Cosmos DB de Cassandra
contact_points = ['tfex-cosmos-db-28370.cassandra.cosmos.azure.com']
port = 10350
username = 'tfex-cosmos-db-28370'
password = 'dGLl4TrKU5tA3cg4VKHuz5lMvePtHgmp9fxB5x2GTKpdl6LReTyztzLjR3EkVwNHnAn3M4enzs0GACDbUhI7LQ=='
keyspace = 'tfex-cosmos-cassandra-keyspace'

# Crea un objeto Cluster y una sesión de Cassandra
cluster = Cluster(
    contact_points=contact_points, 
    port=port, 
    auth_provider=(
        ('username', username), 
        ('password', password)
    ),
    ssl_context=True
)
session = cluster.connect(keyspace)

# Define una clase de recurso que utiliza la sesión de Cassandra para hacer consultas
class CassandraConnector():
    def subidaDeArchivo(self, user):
        session.execute('SELECT * FROM "tfex-cosmos-cassandra-keyspace"."userlogs"')
        return {'results': 'true'}
    def eliminarArchivo(self, user):
        session.execute('SELECT * FROM "tfex-cosmos-cassandra-keyspace"."userlogs"')
        return {'results': 'true'}

# Agrega la clase de recurso a la API

def main():
    pass

if __name__ == '__main__':
    main()