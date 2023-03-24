from flask import Flask
from flask_restful import Api, Resource
from flask_mysqldb import MySQL
import csv
import random
import os


app = Flask(__name__)
api = Api(app)

#Lista de datos extraídos del csv
data = []

# Configuración de conexión a la base de datos
app.config['MYSQL_HOST'] = os.getenv('MARIADBHOST')
app.config['MYSQL_USER'] = os.getenv('MARIADBUSER')
app.config['MYSQL_PASSWORD'] = os.getenv('MARIADBPASSWORD')
app.config['MYSQL_DB'] = os.getenv('MARIADB_DB')
app.config['MYSQL_PORT'] = int(os.getenv('MARIADBPORT'))
mysql = MySQL(app)

# ruta del archivo dentro del contenedor de docker
#ruta_archivo = os.environ.get('ARCHIVO_CSV')

# Función que lee los datos del archivo csv
def csvReader():
    with open(str("/app/babynames.csv"), newline='') as archivo:
        lector_csv = csv.reader(archivo, delimiter=',', quotechar='"')
        counter = 0
        
        for fila in lector_csv:
            counter += 1
            data.append(fila)
            # if counter >= 2000:
            #     break

class BabyName(Resource):
    def get(self):
        # Leer todos los registros de la tabla
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM babynames.babyname")
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
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
            cur = mysql.connection.cursor()
            cur.execute("USE babynames;")
            cur.callproc('babynames.sp_BabyName_Insert', (birthyear, gender, ethnicity, nm, cnt, rnk))
            mysql.connection.commit()
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
            cur = mysql.connection.cursor()
            cur.execute("USE babynames;")
            cur.callproc('babynames.sp_BabyName_Update', (id, birthyear, gender, ethnicity, nm, cnt, rnk))
            mysql.connection.commit()
            cur.close()
            return {'status': 'success', 'idUpdated': id, "data":args}
        except Exception as e:
            return {'status': str(e)}

    def delete(self):
        try:
        # Eliminar un registro de la tabla
            id = random.choice(self.get()["data"])[0]
            cur = mysql.connection.cursor()
            cur.execute("USE babynames;")
            cur.callproc('babynames.sp_BabyName_Delete', (id,))
            mysql.connection.commit()
            cur.close()
            return {'status': 'success', 'id': id}
        except:
            return {'status': 'failed'}
        
api.add_resource(BabyName, '/babynames')

if __name__ == '__main__':
    csvReader()
    app.run(debug=True, host="0.0.0.0", port=5000)
    #app.run(host="0.0.0.0", port=5000)


"""
COMANDOS:

cd TareaCorta1/APIs/mariadb/app
python3 mariaDBApi.py
"""
