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
from flask_cors import CORS


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

# Definition of the API
app = Flask(__name__)
CORS(app)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
app.config['AZURE_STORAGE_CONNECTION_STRING'] = 'DefaultEndpointsProtocol=https;AccountName=filesmanagertiburoncines;AccountKey=CkgCBqebOGWP5we26jpV1TIP49C+Wxp2Nf5qJFNEI4i26LUdEX4bSMYfP/yRAYY9RBbGi5tV0QoN+AStTBd8Ew==;EndpointSuffix=core.windows.net'
app.config['AZURE_STORAGE_CONTAINER_NAME'] = 'documents'


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
        self.submit(user, "Loaded File.")

    def modifyFile(self, user):
        self.submit(user, "Modified File.")

    def deleteFile(self, user):
        self.submit(user, "Deleted File.")

    def userInfoRequested(self, user):
        self.submit(user, "Requested his/her information.")

    def userInfoUpdated(self, user):
        self.submit(user, "Updated his/her information.")

    def userDeleted(self, user):
        self.submit(user, "Deleted his/her account.")

    def signUp(self, user):
        self.submit(user, "Signed up.")

    def userLogin(self, user):
        self.submit(user, "Logged in.")

    def userLogout(self, user):
        self.submit(user, "Logged out.")

    def enrollCourse(self, user):
        self.submit(user, "Enrolled a Course.")

    def unregisterCourse(self, user):
        self.submit(user, "Unregistered a Course.")

    def availableCourses(self, user):
        self.submit(user, "Viewed available courses.")

    def viewEnrollmentDates(self, user):
        self.submit(user, "Viewed enrollment date.")

    def resetPassword(self, user):
        self.submit(user, "Reset the Password.")

    def viewGradeAverage(self, user):
        self.submit(user, "Viewed grade average.")

    def getEnrollmentReport(self, user):
        self.submit(user, "Viewed enrollment report.")

    def viewEnrolledCourses(self, user):
        self.submit(user, "Viewed enrolled courses.")


logManager = CassandraConnector()

# ***************************************************************************
# Resources
# ***************************************************************************
# Main method of the API, just a welcome message
@app.route('/', methods = ['GET'])
def main():
    return {"message": "Welcome to the API!"}

# ===========================================================================
# Blob Storage

# Uploads a file to the blob storage
@app.route('/blobstorage/upload', methods = ['POST'])
def blobUpload():
    if 'file' not in request.files:
        flash('No file part')
        return "<p>Upload File!</p>"
    file = request.files['file']
    if file.filename == '':
        return  "<p>Upload No name!</p>"
    filename = secure_filename(file.filename)
    blob_service_client = BlobServiceClient.from_connection_string(app.config['AZURE_STORAGE_CONNECTION_STRING'])
    container_client = blob_service_client.get_container_client(app.config['AZURE_STORAGE_CONTAINER_NAME'])
    blob_client = container_client.get_blob_client(filename)
    blob_client.upload_blob(file)
    return   "<p>Uploaded!</p>"

# Downloads a file from the blob storage
@app.route('/blobstorage/download/<string:filename>', methods = ['GET'])
def blobDownload(filename):
    try:
        blob_service_client = BlobServiceClient.from_connection_string(app.config['AZURE_STORAGE_CONNECTION_STRING'])
        container_client = blob_service_client.get_container_client(app.config['AZURE_STORAGE_CONTAINER_NAME'])
        blob_client = container_client.get_blob_client(filename)
        stream = io.BytesIO()
        blob_client.download_blob().download_to_stream(stream)
        stream.seek(0)
        response = send_file(stream, download_name=filename, as_attachment=True)
        return response
    except Exception as e:
        return {'status': str(e)}

# Deletes a file from the blob storage
@app.route('/blobstorage/delete/<string:filename>', methods = ['DELETE'])
def blobDelete(filename):
    blob_service_client = BlobServiceClient.from_connection_string(app.config['AZURE_STORAGE_CONNECTION_STRING'])
    container_client = blob_service_client.get_container_client(app.config['AZURE_STORAGE_CONTAINER_NAME'])
    blob_client = container_client.get_blob_client(filename)
    deleted = False
    try:
        blob_client.delete_blob()
        deleted = True
    except:
        deleted = False
    
    if deleted:
        return f"File {filename} deleted."
    else:
        return f"File {filename} not found."

# ===========================================================================
# User

# Read procedure that returns the information of the user
@app.route('/user/info/<string:userId>', methods = ['GET'])
def getUser(userId):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spReadUser_ @userId=?", (userId,))
        rows = cur.fetchall()
        cur.close()
        logManager.userInfoRequested(userId)

        data = []
        for row in rows:
            result = {"userId": row[0], "userName": row[1], "userBirthDay": str(row[2]), "userEmail": row[3]}
            data.append(result)

        return {'data': data}
    except Exception as e:
        return {'status': str(e)}

# Create procedure that creates a new user
@app.route('/user/create/<string:userId>/<string:userName>/<string:userBirthDay>/<string:userEmail>/<int:idCampus>/<boolean:isStudent>', methods = ['POST'])
def createUser(userId, userName, userBirthDay, userEmail, idCampus, isStudent):
    try:
        student = 0
        if isStudent:
            student = 1

        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spCreateUser_ ?,?,?,?,?,?", (userId, userName, userBirthDay, userEmail, idCampus, student))

        conn.commit()
        cur.close()
        logManager.signUp(userId)
        return {'status': 'User successfully created'}
    except Exception as e:
        return {'status': str(e)}

# Update procedure that updates the information of the user
@app.route('/user/update/<string:userId>/<string:userName>/<string:userBirthDay>/<string:userEmail>/<int:idCampus>', methods = ['PUT'])
def updateUser(userId, userName, userBirthDay, userEmail, idCampus):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute('EXEC spUpdateUser_ ?,?,?,?,?', (userId, userName, userBirthDay, userEmail, idCampus))
        conn.commit()
        cur.close()
        logManager.userInfoUpdated(userId)
        return {'status': 'success', 'idUpdated': userId}
    except Exception as e:
        return {'status': str(e)}

# Delete procedure that deletes a user
@app.route('/user/delete/<string:userId>', methods = ['DELETE'])
def deleteUser(userId):
    try:
    # Eliminar un registro de la tabla
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute('EXEC spDeleteUser ?', (userId,))
        conn.commit()
        cur.close()
        logManager.userDeleted(userId)
        return {'status': 'Deleted successfully!', 'userId': userId}
    except Exception as e:
        return {'status': str(e)}

# ===========================================================================
# Campus

# Read procedure that returns the information of all the campuses
@app.route('/campus/list', methods = ['GET'])
def getListOfCampus():
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("SELECT * FROM Campus")
        rows = cur.fetchall()
        cur.close()
        return {'data': rows}
    except Exception as e:
        return {'status': str(e)}


# ===========================================================================
# Course    

# Method to get the courses a student can enroll
@app.route('/course/<string:userId>', methods = ['GET'])
def getCourses(userId):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spGetCourses @userId=?", (userId,))
        rows = cur.fetchall()
        cur.close()

        data = []
        for row in rows:
            result = {}
            result['groupId'] = row[0]
            result['courseId'] = row[1]
            result['courseName'] = row[2]
            result['credits'] = row[3]
            result['evaluationDescription'] = row[4]
            result['score'] = row[5]

            data.append(result)

        return {"data": data}
    except Exception as e:
        return {'status': str(e)}

# ===========================================================================
# SchoolPeriod

# Read procedure that returns the information of a school period
@app.route('/schoolperiod/info/<int:SchoolPeriodId>', methods = ['GET'])
def getSchoolPeriod(SchoolPeriodId):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spReadSchoolPeriod", (SchoolPeriodId,))
        rows = cur.fetchall()
        cur.close()
        return {'data': rows}
    except Exception as e:
        return {'status': str(e)}

# ===========================================================================
# Grade

# Read procedure that returns the average grade of a student
@app.route('/grade/average/<string:userId>/<int:schoolPeriodId>', methods = ['GET'])
def getAverageGrade(userId, schoolPeriodId):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spGetGradeAverage", (userId, schoolPeriodId))
        rows = cur.fetchall()
        cur.close()
        return {'data': rows}
    except Exception as e:
        return {'status': str(e)}

# ===========================================================================
# Enrollment

# Post procedure that enrolls a student in a course if possible
@app.route('/enrollment/enroll/<string:userId>/<int:courseGroupId>/<int:schoolPeriodId>', methods = ['POST'])
def enrollStudent(userId, courseGroupId, schoolPeriodId):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spEnrollment", (userId, schoolPeriodId, courseGroupId))
        conn.commit()
        cur.close()
        return {'status': 'success'}
    except Exception as e:
        return {'status': str(e)}

# Post procedure that unenrolls a student from a course if possible
@app.route('/enrollment/unenroll/<string:userId>/<int:courseGroupId>', methods = ['POST'])
def unenrollStudent(userId, courseGroupId):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spUnregister", (userId, courseGroupId))
        conn.commit()
        cur.close()
        return {'status': 'success'}
    except Exception as e:
        return {'status': str(e)}

# Read procedure that returns the enrollment time of a student
@app.route('/enrollment/time/<string:userId>/<int:schoolPeriodId>', methods = ['GET'])
def getEnrollmentTime(userId, schoolPeriodId):
    try:
        time = 0
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spEnrollmentTimeSchedule", (userId, schoolPeriodId, time))
        cur.close()
        return {'data': time}
    except Exception as e:
        return {'status': str(e)}

# ===========================================================================
# File

# Read procedure that returns the information of a file
@app.route('/file/info/<int:fileName>', methods = ['GET'])
def getFileInfo(fileName):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spReadFile", (fileName, ))
        rows = cur.fetchall()
        cur.close()
        return {'data': rows}
    except Exception as e:
        print(e)
        return {'status': str(e)}

# Post procedure that uploads a file to the database
# userId
# fileTypeId 
# periodId
# creationDate
# modificationDate
# name
# description
# version
@app.route('/file/upload/<string:userId>/<int:fileTypeId>/<int:periodId>/<string:creationDate>/<string:modificationDate>/<string:name>/<string:description>', methods = ['POST'])
def uploadFile(userId, fileTypeId, periodId, creationDate, modificationDate, name, description):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spCreateFile", (userId, fileTypeId, periodId, creationDate, modificationDate, name, description))
        conn.commit()
        cur.close()
        return {'status': 'success'}
    except Exception as e:
        return {'status': str(e)}

# Delete procedure that deletes a file
@app.route('/file/delete/<int:fileId>', methods = ['DELETE'])
def deleteFile(fileId):
    try:
        cur = conn.cursor()
        cur.execute("USE db01;")
        cur.execute("EXEC spDeleteFile", (fileId,))
        conn.commit()
        cur.close()
        return {'status': 'Deleted successfully', 'fileId': fileId}
    except Exception as e:
        return {'status': str(e)}


"""
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
            cur.execute("USE db01;")
            cur.execute("EXEC spUpdateFile", (fileId, fileTypeId, periodId, creationDate, modificationDate, fileName, description, ver))
            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}

"""


# Run the app
if __name__ == '__main__': 
    app.run(debug=True)


