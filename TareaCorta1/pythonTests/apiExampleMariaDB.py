from flask import Flask, request, jsonify
from flask_mysqldb import MySQL

app = Flask(__name__)

# Configuración de la base de datos
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'password'
app.config['MYSQL_DB'] = 'database_name'
mysql = MySQL(app)

# Ruta principal del API
@app.route('/')
def index():
    return 'Welcome to the API'

# Rutas de ejemplo
@app.route('/users')
def get_users():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM users')
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/users/<int:user_id>')
def get_user(user_id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM users WHERE id=%s', (user_id,))
    data = cur.fetchone()
    cur.close()
    return jsonify(data)

# Ejecutar el servidor
if __name__ == '__main__':
    app.run(debug=True)

#http://localhost:5000/users
