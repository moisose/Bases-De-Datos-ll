import unittest

from app import * 

class test_mariadb(unittest.TestCase):

    def test_createCountry(self):
        result = executeProcedure("createCountry", ["CR", "Costa Rica"])
        self.assertEqual(result[0][0], "The country has been created")

