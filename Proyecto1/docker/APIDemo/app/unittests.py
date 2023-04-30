import unittest
import requests
import os

filename = 'example_file.txt'
baseurl = 'https://main-app.ambitiousdune-6b5fa4be.eastus.azurecontainerapps.io/'
userId = 'fFri4sRcE0P6oKHtdZ7INR2jwwl2'
schoolPeriodId = '5'
courseGroupId = '6'

class test_api(unittest.TestCase):

    def testApi(self):   
        response = requests.get(baseurl)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"message":"Welcome to the API!"})

class test_blobstorage(unittest.TestCase):

    def test_blobUpload(self):
        url = baseurl+'blobstorage/upload/'+userId
        filename = 'example_file.txt'
        headers = {'Content-Type': 'multipart/form-data'}

        with open(filename, 'rb') as f:
            files = {'file': (filename, f)}
            response = requests.post(url, headers=headers, files=files)

        self.assertEqual(response.status_code, 200)

    def test_blobDownload(self):
<<<<<<< HEAD:Proyecto1/docker/APIDemo/app/unittests.py
        url = baseurl+'blobstorage/download/'+userId+'/'+'example_file.txt/2023-04-30 07:31'
=======
        url = baseurl+'blobstorage/download/'+userId+'/'+'Graph_Databases_for_Beginners2493.pdf/2023-04-30 00:13:47.743'
>>>>>>> 6d82aaadf099f539da0918c1d848cd6d362bd851:Proyecto1/docker/APIDemo/app/unittest.py
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

    def test_blobDelete(self):
<<<<<<< HEAD:Proyecto1/docker/APIDemo/app/unittests.py
        url = baseurl+'blobstorage/delete/'+userId+'/example_file.txt/2023-04-30 07:31'
=======
        url = baseurl+'blobstorage/delete/'+userId+'/Graph_Databases_for_Beginners2493.pdf/2023-04-30 00:13:47.743'
>>>>>>> 6d82aaadf099f539da0918c1d848cd6d362bd851:Proyecto1/docker/APIDemo/app/unittest.py
        response = requests.delete(url)
        self.assertEqual(response.status_code, 200)

class test_user(unittest.TestCase):
    
    def test_getUser(self):
        url = baseurl+'user/info/'+userId
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

    def test_createUser(self):
        url = baseurl+'user/create/idTest/nameTest/2003-06-24/emailTest/1/1'
        response = requests.post(url)
        self.assertEqual(response.status_code, 200)

    def test_updateUser(self):
        url = baseurl+'user/update/idTest/nameTest/2003-06-24/emailTest/1'
        response = requests.put(url)
        self.assertEqual(response.status_code, 200)

    def test_deleteUser(self):
        url = baseurl+'user/delete/idTest'
        response = requests.delete(url)
        self.assertEqual(response.status_code, 200)

class test_campus(unittest.TestCase):

    def test_getCampus(self):
        url = baseurl+'campus/list'
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

class test_course(unittest.TestCase):

    def test_getCourses(self):
        url = baseurl+'course/'+userId
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)

class test_schoolPeriod(unittest.TestCase):
    
    def test_getSchoolPeriod(self):
        url = baseurl+'schoolperiod/info/'+schoolPeriodId
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)


class test_enrollment(unittest.TestCase):

    def test_enrollStudent(self):
        url = baseurl+'enrollment/enroll/'+userId+'/'+courseGroupId
        response = requests.post(url)
        self.assertEqual(response.status_code, 200)

    def test_unenrollStudent(self):
        url = baseurl+'enrollment/unenroll/'+userId+'/'+courseGroupId
        response = requests.post(url)
        self.assertEqual(response.status_code, 200)

    def test_getEnrollmentTime(self):
        url = baseurl+'enrollment/time/'+userId
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)



if __name__=="__main__":
    unittest.main()
