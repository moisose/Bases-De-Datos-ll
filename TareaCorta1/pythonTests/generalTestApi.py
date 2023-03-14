from flask import Flask
from flask_restful import Api, Resource
from flask_mysqldb import MySQL


app = Flask(__name__)
api = Api(app)

counter = 0


class Testing(Resource):
    def get(self):
        global counter
        counter += 1
        return {"info" : "this is the test " + str(counter)}

class HelloWorld(Resource):
    def get(self):
        return {"hello": "world"}

api.add_resource(HelloWorld, '/helloworld')
api.add_resource(Testing, '/')

if __name__ == '__main__':
    app.run(debug=True)