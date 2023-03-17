from flask import Flask, request
from flask_restful import Api, Resource, reqparse
from flask_mysqldb import MySQL
import csv
import random
import os

app = Flask(__name__)
api = Api(app)

#print(os.getenv('MARIADBHOST'), os.getenv('MARIADBPASS'), os.getenv('MARIADB_DB'))

#Lista de datos extraídos del csv
data = []

# Configuración de conexión a la base de datos
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = 'Idas4918'
app.config['MYSQL_DB'] = 'babynames'
app.config['MYSQL_PORT'] = 3306 
mysql = MySQL(app)

# Función que lee los datos del archivo csv
def csvReader():
    with open('babynames.csv', newline='') as archivo:
        lector_csv = csv.reader(archivo, delimiter=',', quotechar='"')
        counter = 0
        
        for fila in lector_csv:
            counter += 1
            data.append(fila)
            if counter >= 1000:
                break
    #print("=====>", len(data))

class BabyName(Resource):
    def get(self):
        # Leer todos los registros de la tabla
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM BabyName")
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except:
            return {'status': 'failed'}

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
            cur.callproc('sp_BabyName_Insert', (birthyear, gender, ethnicity, nm, cnt, rnk))
            mysql.connection.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except:
            return {'status': 'failed'}

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
            cur.callproc('sp_BabyName_Update', (id, birthyear, gender, ethnicity, nm, cnt, rnk))
            mysql.connection.commit()
            cur.close()
            return {'status': 'success', 'idUpdated': id, "data":args}
        except:
            return {'status': 'failed'}

    def delete(self):
        try:
        # Eliminar un registro de la tabla
            id = random.choice(self.get()["data"])[0]
            cur = mysql.connection.cursor()
            cur.callproc('sp_BabyName_Delete', (id,))
            mysql.connection.commit()
            cur.close()
            return {'status': 'success', 'id': id}
        except:
            return {'status': 'failed'}
        
api.add_resource(BabyName, '/babynames')
#api.add_resource(BabyNameById, '/babynames/int:id')

if __name__ == '__main__':
    csvReader()
    app.run(debug=True)


"""

CREATE TABLE Persona (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);
USE babynames;
SELECT * FROM babyname;
#INSERT INTO `babyname` (`birthyear`, `gender`, `ethnicity`, `bbyName`, `cnt`, `rnk`)
#VALUES (2010, 'F', 'Hispanic', 'Sophia', 1000, 1);


"""