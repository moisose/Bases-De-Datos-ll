/*
	INSTITUTO TECNOLÓGICO DE COSTA RICA
		CAMPUS TECNOLÓGICO CARTAGO
	ESCUELA DE INGENIERIA EN COMPUTACION
		BASES DE DATOS 2 - IC4302 
			PROYECTO OPCIONAL
                
	Profesor: Nereo Campos Araya
    
			   Estudiantes: 
			   

    
			I SEMESTRE, 2023
*/

DROP DATABASE IF EXISTS WindyUI;
CREATE DATABASE WindyUI;

USE WindyUI;

#----------------------------------------------TABLES-----------------------------------------------
#Table Station 
#
DROP TABLE IF EXISTS Station;
CREATE TABLE Station (
		idStation VARCHAR(11) PRIMARY KEY,
		latitude REAL,
		longitude REAL,
		elevation REAL,
		stateCode VARCHAR(2),
		stationName VARCHAR(50),
		gsnFlag VARCHAR(3),
		hcnCrnFlag VARCHAR(3),
		wmold VARCHAR(3),
		countryCode VARCHAR(2)
);
	
#Table States 
DROP TABLE IF EXISTS Country;
CREATE TABLE Country (
		countryCode VARCHAR(2) PRIMARY KEY,
		countryName VARCHAR(50)
);

#Table States 
DROP TABLE IF EXISTS State;
CREATE TABLE State (
		stateCode VARCHAR(2) PRIMARY KEY,
		stateName VARCHAR(50)
);

#Table Files
DROP TABLE IF EXISTS textFile;
CREATE TABLE textFile (
		fileCode INT PRIMARY KEY AUTO_INCREMENT,
		fileName VARCHAR(50),  
		url VARCHAR(100),
		processedDay DATE,
		fileMd5 INT,
		fileState VARCHAR(20)
);

#FOREING KEYS-------------------------------------------------------

#Station with country
ALTER TABLE Station
	ADD CONSTRAINT StationXCountry FOREIGN KEY (CountryCode) REFERENCES Country(countryCode);
#Station with state
ALTER TABLE Station
	ADD CONSTRAINT StationXState FOREIGN KEY (stateCode) REFERENCES State(stateCode);	
	


#Pruebas


#CALL createState("CF", "CALIFORNIA");
#SELECT * FROM state;
#CALL createCountry("EU", "Estados");
#SELECT * FROM country;

#CALL createStation("PRUEBA2", 12.8, 12.2, 21, NULL, "NOMBRE", "123", "123", "123", NULL);

#SELECT * FROM station;

#SELECT COUNT(*) FROM country WHERE countryCode = "EU"
	