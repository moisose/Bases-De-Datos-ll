from flask import Flask, request, jsonify
import psycopg2

app = Flask(__name__)

# Configuración de la base de datos
conn = psycopg2.connect(
    host="localhost",
    database="database_name",
    user="username",
    password="password"
)

# Ruta principal del API
@app.route('/')
def index():
    return 'Welcome to the API'

# Rutas de ejemplo
@app.route('/users')
def get_users():
    cur = conn.cursor()
    cur.execute('SELECT * FROM users')
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/users/<int:user_id>')
def get_user(user_id):
    cur = conn.cursor()
    cur.execute('SELECT * FROM users WHERE id=%s', (user_id,))
    data = cur.fetchone()
    cur.close()
    return jsonify(data)

# Ejecutar el servidor
if __name__ == '__main__':
    app.run(debug=True)
