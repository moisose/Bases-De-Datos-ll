"""
'Thunkable'
Este se encarga de conectar con la base de datos Azure SQL Server
y dar la información que necesite Thunkable

Información que se necesita:
Cursos que pueda matricular
Cursos que tenga matriculados
Lista de archivos que tenga en el blob storage
matriculas disponibles
hora de matricula para un estudiante en especifico

"""

import pyodbc
from flask import Flask
from flask_restful import Resource, Api

driver = "{ODBC Driver 17 for SQL Server}"
server = "tcp:tiburoncines-sqlserver.database.windows.net,1433"
database = "db01"
username = "el-adm1n"
password = "dT-Dog01@-bla" 
encrypt = "yes"
trustServerCertificate = "no"
connectionTimeout = "30"

conn_str = (
    f'DRIVER={driver};'
    f'SERVER={server};'
    f'DATABASE={database};'
    f'UID={username};'
    f'PWD={password};'
    f'Encrypt={encrypt};'
    f'TrustServerCertificate={trustServerCertificate};'
    f'Connection Timeout={connectionTimeout};'
)

cnxn = pyodbc.connect(conn_str)

app = Flask(__name__)
api = Api(app)

class Faculty(Resource):
    def get(self):
        cursor = cnxn.cursor()
        cursor.execute('SELECT * FROM Faculty')
        rows = cursor.fetchall()

        results = []
        for row in rows:
            results.append({
                'name': row.name
            })
        return results
    
class Courses(Resource):
    def get(self):
        cursor = cnxn.cursor()
        cursor.callproc('getCourses',(id,))
        rows = cursor.fetchall()

        results = []
        for row in rows:
            results.append({
                'name': row.name
            })
        return results
    
    def post(self):
        pass
    
api.add_resource(Faculty, '/azure/faculty')
api.add_resource(Courses, '/azure/courses')

if __name__ == '__main__':
    app.run(debug=True)
