# Imports
from flask import Flask, flash, request, send_file
from flask_restful import Api, Resource, reqparse
from werkzeug.utils import secure_filename
import os
import pyodbc
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from ssl import SSLContext, PROTOCOL_TLSv1_2, CERT_NONE
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
import io


"""
Connections

Here you can find the connection string to connect to the Azure database, cassandra and blob storage
"""

# ===========================================================================
# Azure Database Connection

driver = "{ODBC Driver 18 for SQL Server}"
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

conn = pyodbc.connect(conn_str)

# ===========================================================================
# Cassandra Connection

# Defines the connection string for Cosmos DB and Cassandra
contact_points = ['tfex-cosmos-db-26555.cassandra.cosmos.azure.com']
port = 10350
usernameVar = 'tfex-cosmos-db-26555'
passwordVar = 'wd5uWOiL7UGaYv9W4oyh9VQOEr0FN8JphA71qwM6rnchowByWmv5ldDSfTndVgv9IgsvKEebInagACDbQB5BSw=='
keyspace = 'tfex-cosmos-cassandra-keyspace'

auth_provider = PlainTextAuthProvider(username=usernameVar, password=passwordVar)
ssl_context = SSLContext(PROTOCOL_TLSv1_2)
ssl_context.verify_mode = CERT_NONE

# Creates a Cluster object and a Cassandra session
cluster = Cluster(
    contact_points=contact_points, 
    port=port, 
    auth_provider=auth_provider,
    ssl_context=ssl_context
)
session = cluster.connect(keyspace)

# ===========================================================================
# Blob Storage Connection
account_url = "https://filesmanagertiburoncines.blob.core.windows.net"
default_credential = DefaultAzureCredential()
blob_service_client = BlobServiceClient(account_url, credential=default_credential)

# Definition of the API
app = Flask(__name__)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
api = Api(app)



# ===========================================================================
# Arguments Parsing for each resource

# args User_
parserUser = reqparse.RequestParser()
parserUser.add_argument("userId", type=str, required=True)
parserUser.add_argument("userName", type=str)
parserUser.add_argument("userBirthDay", type=str)
parserUser.add_argument("userEmail", type=str)
parserUser.add_argument("idCampus", type=int)

# args Campus
parserCampus = reqparse.RequestParser()
parserCampus.add_argument("campusId", type=int, required=True)
parserCampus.add_argument("campusName", type=str)

# args Course
parserCourse = reqparse.RequestParser()
parserCourse.add_argument("courseId", type=int, required=True)
parserCourse.add_argument("courseName", type=str)
parserCourse.add_argument("facultyId", type=int)
parserCourse.add_argument("credits", type=int)
parserCourse.add_argument("periodTypeId", type=int)
parserCourse.add_argument("hoursPerWeek", type=int)
parserCourse.add_argument("description", type=str)

# args SchoolPeriod
parserSchoolPeriod = reqparse.RequestParser()
parserSchoolPeriod.add_argument("periodId", type=int, required=True)
parserSchoolPeriod.add_argument("periodTypeId", type=int)
parserSchoolPeriod.add_argument("startDate", type=str)
parserSchoolPeriod.add_argument("endDate", type=str)
parserSchoolPeriod.add_argument("statusId", type=int)

# args Grade
parserGrade = reqparse.RequestParser()
parserGrade.add_argument("userId", type=str, required=True)
parserGrade.add_argument("schoolPeriodId", type=int)

# args Enrollment
parserEnrollment = reqparse.RequestParser()
parserEnrollment.add_argument("userId", type=str, required=True)
parserEnrollment.add_argument("courseGroupId", type=int)
parserEnrollment.add_argument("schoolPeriodId", type=int)
parserEnrollment.add_argument("timeOfDay", type=str)

# args File
parserFile = reqparse.RequestParser()
parserFile.add_argument("fileId", type=int, required=True)
parserFile.add_argument("userId", type=str, required=True)
parserFile.add_argument("fileTypeId", type=int)
parserFile.add_argument("periodId", type=int)
parserFile.add_argument("creationDate", type=str)
parserFile.add_argument("modificationDate", type=str)
parserFile.add_argument("name", type=str)
parserFile.add_argument("description", type=str)
parserFile.add_argument("ver", type=int)

# args Blob

parserBlob = reqparse.RequestParser()
parserBlob.add_argument('userId', type=str, help='User ID', required=True)
parserBlob.add_argument('name', type=str, help='User Name', required=False)
parserBlob.add_argument('age', type=int, help='Age', required=False)
parserBlob.add_argument('filename', type=str, help='Filename', required=False)


# ===========================================================================
# Cassandra class
# Used to send the log messages to cassandra
class CassandraConnector():
    def submit(self, user, log):
        session.execute("INSERT INTO userlogs (user_id, logline) VALUES ('"+user+"', '"+log+"')")
        return "Submited"

    def deleteAll(self):
        session.execute("TRUNCATE userlogs")
        return "Deleted all"

    def loadFile(self, user):
        self.submit(user, "Loaded File")

    def modifyFile(self, user):
        self.submit(user, "Modified File")

    def deleteFile(self, user):
        self.submit(user, "Deleted File")

    def signUp(self, user):
        self.submit(user, "Signed up")

    def userLogin(self, user):
        self.submit(user, "Logged in")

    def userLogout(self, user):
        self.submit(user, "Logged out")

    def enrollCourse(self, user):
        self.submit(user, "Enrolled a Course")

    def unregisterCourse(self, user):
        self.submit(user, "Unregistered a Course")

    def availableCourses(self, user):
        self.submit(user, "Viewed available courses")

    def viewEnrollmentDates(self, user):
        self.submit(user, "Viewed enrollment date")

    def resetPassword(self, user):
        self.submit(user, "Reset the Password")

    def viewGradeAverage(self, user):
        self.submit(user, "Viewed grade average")

    def getEnrollmentReport(self, user):
        self.submit(user, "Viewed enrollment report")

    def viewEnrolledCourses(self, user):
        self.submit(user, "Viewed enrolled courses")


# ===========================================================================
# Resources

class Main(Resource):
    def get(self):
        return "<p>Api creado!</p>"

class BlobStorage(Resource):
    def post(self):
        if 'file' not in request.files:
            flash('No file part')
            return "<p>Upload File!</p>"
        file = request.files['file']
        if file.filename == '':
            return  "<p>Upload No name!</p>"
        filename = secure_filename(file.filename)
        blob_client = blob_service_client.get_blob_client(container='documents', blob=filename)
        blob_client.upload_blob(file)
        return   "<p>Upload!</p>"
    
    def get(self):
        args = parserBlob.parse_args() # Args parsing
        filename = args["filename"]
        blob_client = blob_service_client.get_blob_client(container='documents', blob=filename)
        stream = io.BytesIO()
        blob_client.download_blob().download_to_stream(stream)
        stream.seek(0)
        return send_file(stream, attachment_filename=filename, as_attachment=True)
    
    def delete(self, filename):
        blob_client = blob_service_client.get_blob_client(container='documents', blob=filename)
        deleted = blob_client.delete_blob()
        if deleted:
            return f"File {filename} deleted."
        else:
            return f"File {filename} not found."


class User(Resource):
    # Read procedure that returns the information of the user
    def get(self):
        try:
            args = parserUser.parse_args() # Args parsing
            userId = args["userId"]

            cur = conn.cursor()
            cur.execute("spReadUser", (userId,))
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}

    # Create procedure that creates a new user
    def post(self):
        try:
            args = parserUser.parse_args()
            userId = args["userId"]
            userName = args["userName"]
            userBirthDay = args["userBirthDay"]
            userEmail = args["userEmail"]
            idCampus = args["idCampus"]

            cur = conn.cursor()

            cur.execute("USE db01;")
            cur.execute("spCreateUser", (userId, userName, userBirthDay, userEmail, idCampus))

            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}

    # Update procedure that updates the information of a user
    def put(self):
        try:
            args = parserUser.parse_args()
            userId = args["userId"]
            userName = args["userName"]
            userBirthDay = args["userBirthDay"]
            userEmail = args["userEmail"]
            idCampus = args["idCampus"]

            cur = conn.cursor()
            cur.execute("USE db01;")
            cur.execute('spUpdateUser', (userId, userName, userBirthDay, userEmail, idCampus))
            conn.commit()
            cur.close()
            return {'status': 'success', 'idUpdated': id, "data":args}
        except Exception as e:
            return {'status': str(e)}

    # Delete procedure that deletes a user
    def delete(self):
        try:
        # Eliminar un registro de la tabla
            args = parserUser.parse_args()
            userId = args["userId"]

            cur = conn.cursor()
            cur.execute("USE db01;")
            cur.execute('spDeleteUser', (id,))
            conn.commit()
            cur.close()
            return {'status': 'success', 'id': id}
        except:
            return {'status': 'failed'}

class Campus(Resource):
    # Read procedure that returns the information of all the campuses
    def get(self):
        try:
            cur = conn.cursor()
            cur.execute("SELECT * FROM Campus")
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}
        
class Course(Resource):
    # Read procedure that returns the information of all the courses of a user
    def get(self):
        try:
            args = parserCourse.parse_args()
            userId = args["userId"]

            cur = conn.cursor()
            cur.execute("EXEC spGetCourses", (userId,))
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}
    

class SchoolPeriod(Resource):
    # Read procedure that returns the information of a school period
    def get(self):
        try:
            args = parserSchoolPeriod.parse_args()
            SchoolPeriodId = args["periodId"]

            cur = conn.cursor()
            cur.execute("EXEC spReadSchoolPeriod", (SchoolPeriodId,))
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}
        
class Grade(Resource):
    # Read procedure that returns the average grade of a user
    def get(self):
        try:
            args = parserGrade.parse_args()
            userId = args["userId"]
            schoolPeriodId = args["schoolPeriodId"]

            cur = conn.cursor()
            cur.execute("EXEC spGetGradeAverage", (userId,schoolPeriodId))
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}

class Enrollment(Resource):
    # Post procedure that tries to enrolls a user in a course if possible
    def post(self):
        try:
            args = parserEnrollment.parse_args()
            userId = args["userId"]
            courseGroupId = args["courseGroupId"]
            schoolPeriodId = args["schoolPeriodId"]
            timeOfDay = args["timeOfDay"]

            cur = conn.cursor()
            cur.execute("EXEC spEnrollment", (userId, schoolPeriodId, courseGroupId, timeOfDay))
            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}
        
    # Delete procedure that unregisters a user from a course
    def delete(self):
        try:
            args = parserEnrollment.parse_args()
            userId = args["userId"]
            courseGroupId = args["courseGroupId"]

            cur = conn.cursor()
            cur.execute("EXEC spUnregister", (userId, courseGroupId))
            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}
        
class File(Resource):
    # Read procedure that returns the information of a file
    def get(self):
        try:
            args = parserFile.parse_args()
            fileName = args["fileName"]

            cur = conn.cursor()
            cur.execute("EXEC spReadFile", (fileName, ))
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}
    
    # Post procedure that creates a new file
    def post(self):
        try:
            args = parserFile.parse_args()
            userId = args["userId"]
            fileTypeId = args["fileTypeId"]
            periodId = args["periodId"]
            creationDate = args["creationDate"]
            modificationDate = args["modificationDate"]
            name = args["name"]
            description = args["description"]
            ver = args["ver"]

            cur = conn.cursor()
            cur.execute("EXEC spCreateFile", (userId, fileTypeId, periodId, creationDate, modificationDate, name, description, ver))
            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}
    
    # Put procedure that updates the information of a file
    def put(self):
        try:
            args = parserFile.parse_args()
            fileId = args["fileId"]
            fileName = args["fileName"]
            fileTypeId = args["fileTypeId"]
            periodId = args["periodId"]
            creationDate = args["creationDate"]
            modificationDate = args["modificationDate"]
            name = args["name"]
            description = args["description"]
            ver = args["ver"]

            cur = conn.cursor()
            cur.execute("EXEC spUpdateFile", (fileId, fileTypeId, periodId, creationDate, modificationDate, fileName, description, ver))
            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}
    
    # Delete procedure that deletes a file
    def delete(self):
        try:
            args = parserFile.parse_args()
            fileId = args["fileId"]

            cur = conn.cursor()
            cur.execute("EXEC spDeleteFile", (fileId,))
            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}

# API endpoints      
api.add_resource(User, '/user')
api.add_resource(Campus, '/campus')
api.add_resource(Course, '/course')
api.add_resource(SchoolPeriod, '/schoolperiod')
api.add_resource(Grade, '/grade')
api.add_resource(Enrollment, '/enrollment')
api.add_resource(File, '/file')
api.add_resource(BlobStorage, '/blob')
api.add_resource(Main, '/')


# Run the app
if __name__ == '__main__': 
    app.run(debug=True)
