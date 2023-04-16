from flask import Flask
from flask_restful import Api, Resource, reqparse
import pyodbc

conn = pyodbc.connect('Driver={ODBC Driver 18 for SQL Server};Server=tcp:tiburoncines-sqlserver.database.windows.net,1433;Database=db01;Uid=el-adm1n;Pwd={your_password_here};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;')

app = Flask(__name__)
api = Api(app)



#args User_
parserUser = reqparse.RequestParser()
parserUser.add_argument("userId", type=str, required=True)
parserUser.add_argument("userName", type=str)
parserUser.add_argument("userBirthDay", type=str)
parserUser.add_argument("userEmail", type=str)
parserUser.add_argument("idCampus", type=int)

#args Campus
parserCampus = reqparse.RequestParser()
parserCampus.add_argument("campusId", type=int, required=True)
parserCampus.add_argument("campusName", type=str)

#args Course
parserCourse = reqparse.RequestParser()
parserCourse.add_argument("courseId", type=int, required=True)
parserCourse.add_argument("courseName", type=str)
parserCourse.add_argument("facultyId", type=int)
parserCourse.add_argument("credits", type=int)
parserCourse.add_argument("periodTypeId", type=int)
parserCourse.add_argument("hoursPerWeek", type=int)
parserCourse.add_argument("description", type=str)

#args SchoolPeriod
parserSchoolPeriod = reqparse.RequestParser()
parserSchoolPeriod.add_argument("periodId", type=int, required=True)
parserSchoolPeriod.add_argument("periodTypeId", type=int)
parserSchoolPeriod.add_argument("startDate", type=str)
parserSchoolPeriod.add_argument("endDate", type=str)
parserSchoolPeriod.add_argument("statusId", type=int)

#args Grade
parserGrade = reqparse.RequestParser()
parserGrade.add_argument("userId", type=str, required=True)
parserGrade.add_argument("schoolPeriodId", type=int)

#args Enrollment
parserEnrollment = reqparse.RequestParser()
parserEnrollment.add_argument("userId", type=str, required=True)
parserEnrollment.add_argument("courseGroupId", type=int)
parserEnrollment.add_argument("schoolPeriodId", type=int)
parserEnrollment.add_argument("timeOfDay", type=str)

#args File
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


data = []

class User(Resource):
    def get(self):
        # Leer todos los registros de la tabla
        try:
            args = parserUser.parse_args()
            userId = args["userId"]

            cur = conn.cursor()
            cur.execute("spReadUser", (userId,))
            rows = cur.fetchall()
            cur.close()
            return {'data': rows}
        except Exception as e:
            print(e)
            return {'status': str(e)}

    def post(self):
        try:
            args = parserUser.parse_args()
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
            cur.execute("spCreateUser", (userId, userName, userBirthDay, userEmail, idCampus))

            conn.commit()
            cur.close()
            return {'status': 'success', 'data': args}
        except Exception as e:
            return {'status': str(e)}

    def put(self):
        # Actualizar un registro existente en la tabla
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
        
class Course(Resource):
    def get(self):
        # Leer todos los registros de la tabla
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
    def get(self):
        # Leer todos los registros de la tabla
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
    def get(self):
        # Leer todos los registros de la tabla
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
    def get(self):
        # Leer todos los registros de la tabla
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
        
api.add_resource(User, '/user')
api.add_resource(Campus, '/campus')
api.add_resource(Course, '/course')
api.add_resource(SchoolPeriod, '/schoolperiod')
api.add_resource(Grade, '/grade')
api.add_resource(Enrollment, '/enrollment')
api.add_resource(File, '/file')

if __name__ == '__main__': 
    app.run(debug=True)
