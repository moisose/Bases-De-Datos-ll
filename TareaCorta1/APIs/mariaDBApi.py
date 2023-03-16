from flask import Flask, request
from flask_restful import Api, Resource, reqparse
from flask_mysqldb import MySQL
import os

app = Flask(__name__)
api = Api(app)

#print(os.getenv('MARIADBHOST'), os.getenv('MARIADBPASS'), os.getenv('MARIADB_DB'))

# Configuración de conexión a la base de datos
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = "root"
app.config['MYSQL_PASSWORD'] = 'Idas4918'
app.config['MYSQL_DB'] = 'babynames'
mysql = MySQL(app)

# Configuración del analizador de argumentos
parser = reqparse.RequestParser()
parser.add_argument('birthyear')
parser.add_argument('gender')
parser.add_argument('ethnicity')
parser.add_argument('nm')
parser.add_argument('cnt')
parser.add_argument('rnk')
parser.add_argument('id')

class BabyName(Resource):
    def get(self):
        # Leer todos los registros de la tabla
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM BabyName")
        rows = cur.fetchall()
        cur.close()
        return {'data': rows}

    def post(self):
        # Insertar un nuevo registro en la tabla
        args = parser.parse_args()
        birthyear = args['birthyear']
        gender = args['gender']
        ethnicity = args['ethnicity']
        nm = args['nm']
        cnt = args['cnt']
        rnk = args['rnk']
        cur = mysql.connection.cursor()
        cur.callproc('sp_BabyName_Insert', (birthyear, gender, ethnicity, nm, cnt, rnk))
        mysql.connection.commit()
        cur.close()
        return {'status': 'success', 'data': args}

    def put(self):
        # Actualizar un registro existente en la tabla
        args = parser.parse_args()
        id = args['id']
        birthyear = args['birthyear']
        gender = args['gender']
        ethnicity = args['ethnicity']
        nm = args['nm']
        cnt = args['cnt']
        rnk = args['rnk']
        cur = mysql.connection.cursor()
        cur.callproc('sp_BabyName_Update', (id, birthyear, gender, ethnicity, nm, cnt, rnk))
        mysql.connection.commit()
        cur.close()
        return {'status': 'success', 'data': args}

    def delete(self):
        # Eliminar un registro de la tabla
        args = parser.parse_args()
        id = args['id']
        cur = mysql.connection.cursor()
        cur.callproc('sp_BabyName_Delete', (id))
        mysql.connection.commit()
        cur.close()
        return {'status': 'success', 'data': args}

class BabyNameById(Resource):
    def get(self, id):
        # Leer un registro específico de la tabla según su ID
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM BabyName WHERE id = %s", (id))
        row = cur.fetchone()
        cur.close()
        if row is not None:
            return {'data': row}
        else:
            return {'status': 'error', 'message': 'No se encontró el registro con el ID especificado'}
        
api.add_resource(BabyName, '/babynames')
api.add_resource(BabyNameById, '/babynames/int:id')

if __name__ == '__main__':
    app.run(debug=True)


"""

CREATE TABLE Persona (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);


En este ejemplo, se crean dos recursos (clases) que manejan las solicitudes de la API. La clase "BabyName" maneja las solicitudes GET, POST, PUT y DELETE para la tabla completa,
mientras que la clase "BabyNameById" maneja la solicitud GET para un registro específico de la tabla.

Para las solicitudes POST y PUT, los valores de los campos se toman de los argumentos de la solicitud utilizando el analizador de argumentos de Flask-Restful. 
Luego, se llama al procedimiento almacenado correspondiente en la base de datos utilizando la conexión MySQL. Para la solicitud DELETE, 
se elimina el registro con el ID especificado utilizando el procedimiento almacenado correspondiente.

En general, este ejemplo debe proporcionarte una buena base para crear tu propia API en Flask-Restful que trabaje con una base de datos MariaDB y 
procedimientos almacenados. Solo asegúrate de ajustar las configuraciones de conexión de la base de datos en la sección "Configuración de conexión a la base de datos" 
para que coincidan con tu propia base de datos.

"""