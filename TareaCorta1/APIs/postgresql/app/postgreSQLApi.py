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
    host=os.getenv('PGSQL_HOST'),
    database=os.getenv('PGSQL_DB'),
    user=os.getenv('PGSQLUSER'),
    password=os.getenv('PGSQL_PASS'),
    port=os.getenv('PGSQL_PORT'), 
)

#Lista de datos extraídos del csv
data = []


# Función que lee los datos del archivo csv
def csvReader():
    with open('/app/babynames.csv', newline='') as archivo:
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
            cur.execute("SELECT * FROM babynames.babyname")
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            return {'status': str(e)}
        
    def post(self):
        try:
            args = random.choice(data)
            birthyear = args[0]
            gender = args[1]
            ethnicity = args[2]
            nm = args[3]
            cnt = args[4]
            rnk = args[5]
            cur = conn.cursor()
            cur.callproc('babynames.sp_BabyName_Insert', (birthyear, gender, ethnicity, nm, cnt, rnk))
            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}

    def put(self):
        # Actualizar un registro existente en la tabla
        try:
            args = random.choice(data)
            id = random.choice(self.get()["data"])[0]
            birthyear = args[0]
            gender = args[1]
            ethnicity = args[2]
            nm = args[3]
            cnt = args[4]
            rnk = args[5]
            cur = conn.cursor()
            cur.callproc('babynames.sp_BabyName_Update', (id, birthyear, gender, ethnicity, nm, cnt, rnk))
            conn.commit()
            cur.close()
            return {'status': 'success', 'idUpdated': id, "data":args}
        except Exception as e:
            return {'status': str(e)}

    def delete(self):
        try:
        # Eliminar un registro de la tabla
            id = random.choice(self.get()["data"])[0]
            cur = conn.cursor()
            cur.callproc('babynames.sp_BabyName_Delete', (id,))
            conn.commit()
            cur.close()
            return {'status': 'success', 'id': id}
        except Exception as e:
            return {'status': str(e)}
        
api.add_resource(BabyName, '/babynames')

if __name__ == '__main__':
    csvReader()
    print(len(data))
    app.run(debug=True)


"""
COMANDOS:

cd TareaCorta1/APIs/postgresql/app
python postgreSQLApi.py
"""