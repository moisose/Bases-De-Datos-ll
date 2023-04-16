"""
Este archivo define una aplicacion que utiliza la sesión de Cassandra para subir los logs de
la aplicación de Thunkable a Cosmos DB de Cassandra.

Debe solicitar siempre el usuario y luego lo que se quiera agregar al log.

"""

from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from ssl import SSLContext, PROTOCOL_TLSv1_2, CERT_NONE


# Define el string de conexión a Cosmos DB de Cassandra
contact_points = ['tfex-cosmos-db-26555.cassandra.cosmos.azure.com']
port = 10350
usernameVar = 'tfex-cosmos-db-26555'
passwordVar = 'wd5uWOiL7UGaYv9W4oyh9VQOEr0FN8JphA71qwM6rnchowByWmv5ldDSfTndVgv9IgsvKEebInagACDbQB5BSw=='
keyspace = 'tfex-cosmos-cassandra-keyspace'

auth_provider = PlainTextAuthProvider(username=usernameVar, password=passwordVar)
ssl_context = SSLContext(PROTOCOL_TLSv1_2)
ssl_context.verify_mode = CERT_NONE

# Crea un objeto Cluster y una sesión de Cassandra
cluster = Cluster(
    contact_points=contact_points, 
    port=port, 
    auth_provider=auth_provider,
    ssl_context=ssl_context
)
session = cluster.connect(keyspace)

# 'tfex-cosmos-cassandra-keyspace'.
# Define una clase de recurso que utiliza la sesión de Cassandra para hacer consultas
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
    

    

def main():
    c1 = CassandraConnector()
    
    c1.fileLoaded("Isaac4918")

if __name__ == '__main__':
    main()