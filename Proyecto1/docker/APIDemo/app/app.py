from flask import Flask
from flask_restful import Api, Resource, reqparse
import pyodbc

#conn = pyodbc.connect('Driver={ODBC Driver 18 for SQL Server};Server=tcp:tiburoncines-sqlserver.database.windows.net,1433;Database=db01;Uid=el-adm1n;Pwd={your_password_here};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;')

app = Flask(__name__)
api = Api(app)



#args User_
parser = reqparse.RequestParser()
parser.add_argument("userId", type=str, required=True)
parser.add_argument("userName", type=str)
parser.add_argument("userBirthDay", type=str)
parser.add_argument("userEmail", type=str)
parser.add_argument("idCampus", type=int)

#args Campus
parser2 = reqparse.RequestParser()
parser2.add_argument("idCampus", type=int, required=True)
parser2.add_argument("campusName", type=str)


data = []

class User(Resource):
    def get(self):
        # Leer todos los registros de la tabla
        try:
            cur = conn.cursor()
            cur.execute("SELECT * FROM User_")
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}

    def post(self):
        try:
            args = parser.parse_args()
            userId = args["userId"]
            userName = args["userName"]
            userBirthDay = args["userBirthDay"]
            userEmail = args["userEmail"]
            idCampus = args["idCampus"]

            cur = conn.cursor()

            #params = (14, "Dinsdale")
            #crsr.execute("{CALL usp_UpdateFirstName (?,?)}", params)
            #return_value = crsr.fetchval()

            cur.execute("USE db01;")
            cur.execute("INSERT INTO User_ (userId, userName, birthDate, email, idCampus) VALUES (?, ?, ?, ?, ?)", (userId, userName, userBirthDay, userEmail, idCampus))

            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}

    def put(self):
        # Actualizar un registro existente en la tabla
        try:
            args = parser.parse_args()
            userId = args["userId"]
            userName = args["userName"]
            userBirthDay = args["userBirthDay"]
            userEmail = args["userEmail"]
            idCampus = args["idCampus"]

            cur = conn.cursor()
            cur.execute("USE db01;")
            cur.execute('UPDATE db01 SET userName = ?, birthDate = ?, email = ?, idCampus = ? WHERE id = ?', (userName, userBirthDay, userEmail, idCampus, userId))
            conn.commit()
            cur.close()
            return {'status': 'success', 'idUpdated': id, "data":args}
        except Exception as e:
            return {'status': str(e)}

    def delete(self):
        try:
        # Eliminar un registro de la tabla
            args = parser.parse_args()
            userId = args["userId"]

            cur = conn.cursor()
            cur.execute("USE db01;")
            cur.execute('DELETE FROM db01 WHERE id = ?', (id,))
            conn.commit()
            cur.close()
            return {'status': 'success', 'id': id}
        except:
            return {'status': 'failed'}

class Campus(Resource):
    def get(self):
        # Leer todos los registros de la tabla
        try:
            cur = conn.cursor()
            cur.execute("SELECT * FROM Campus")
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}

        
api.add_resource(User, '/user')
api.add_resource(Campus, '/campus')

if __name__ == '__main__': 
    app.run(debug=True)
