from flask import Flask, request
from flask_restful import Resource, Api
from pymongo import MongoClient
import random

# Initialize Flask app
app = Flask(__name__)
api = Api(app)

# Connect to MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client.mydatabase

# Define a resource for handling requests
class BabyName(Resource):
    def get(self):
        data = db.my_collection.find()
        result = []
        for item in data:
            result.append({
                "id": str(item["_id"]),
                "name": item["name"],
                "age": item["age"]
            })
        return result

    def post(self):
        data = request.get_json()
        db.my_collection.insert_one({
            "name": data["name"],
            "age": data["age"]
        })
        return {'status': 'success'}


# Add the resource to the API
api.add_resource(BabyName, '/babynames')

if __name__ == '__main__':
    app.run(debug=True)


"""

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

"""