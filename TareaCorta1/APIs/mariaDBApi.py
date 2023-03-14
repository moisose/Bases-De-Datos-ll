from flask import Flask
from flask_restful import Api, Resource
from flask_mysqldb import MySQL


app = Flask(__name__)
api = Api(app)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
app.config['MYSQL_DB'] = 'database_name'
mysql = MySQL(app)

class MariaDB(Resource):
    def get(self, name):
        try:
            cur = mysql.connection.cursor()
            cur.execute("INSERT INTO Persona (nombre) VALUES ('" + name +"');")
            data = cur.fetchall()
            cur.close()
            return "Request succeded."
        except:
            return ("INSERT INTO Persona (nombre) VALUES ('" + name +"');")
        
    """ def post(self, name):
        try:
            cur = mysql.connection.cursor()
            cur.execute("INSERT INTO Persona (nombre) VALUES ('" + name +"');")
            data = cur.fetchall()
            cur.close()
            return "Request succeded."
        except:
            return ("INSERT INTO Persona (nombre) VALUES ('" + name +"');")

    def put(self, name):
        try:
            cur = mysql.connection.cursor()
            cur.execute("INSERT INTO Persona (nombre) VALUES ('" + name +"');")
            data = cur.fetchall()
            cur.close()
            return "Request succeded."
        except:
            return ("INSERT INTO Persona (nombre) VALUES ('" + name +"');")

    def delete(self, name):
        try:
            cur = mysql.connection.cursor()
            cur.execute("INSERT INTO Persona (nombre) VALUES ('" + name +"');")
            data = cur.fetchall()
            cur.close()
            return "Request succeded."
        except:
            return ("INSERT INTO Persona (nombre) VALUES ('" + name +"');") """

api.add_resource(MariaDB, '/mariadb/<string:name>')

if __name__ == '__main__':
    app.run(debug=True)


"""

CREATE TABLE Persona (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);



"""