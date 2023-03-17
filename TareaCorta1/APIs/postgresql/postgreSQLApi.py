from flask import Flask
from flask_restful import Api, Resource
import psycopg2
import csv
import random
import os

app = Flask(__name__)
api = Api(app)

# Configuración de conexión a la base de datos
conn = psycopg2.connect(
    host="localhost",
    database="babynames",
    user="postgres",
    password="mypassword"
)

#print(os.getenv('MARIADBHOST'), os.getenv('MARIADBPASS'), os.getenv('MARIADB_DB'))

#Lista de datos extraídos del csv
data = []


# Función que lee los datos del archivo csv
def csvReader():
    with open('../babynames.csv', newline='') as archivo:
        lector_csv = csv.reader(archivo, delimiter=',', quotechar='"')
        counter = 0
        
        for fila in lector_csv:
            counter += 1
            data.append(fila)
            if counter >= 1000:
                break

class BabyName(Resource):
    def get(self):
        try:
            # Leer todos los registros de la tabla
            cur = conn.cursor()
            cur.execute("SELECT * FROM BabyName")
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except:
            return {'status': 'failed'}
        
api.add_resource(BabyName, '/babynames')

if __name__ == '__main__':
    csvReader()
    print(len(data))
    app.run(debug=True)


"""
COMANDOS:

cd TareaCorta1/APIs/postgresql
python postgreSQLApi.py
"""