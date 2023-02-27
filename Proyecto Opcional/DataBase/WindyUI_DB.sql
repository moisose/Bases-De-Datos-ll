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

DROP DATABASE IF EXISTS weather;
CREATE DATABASE weather;

USE weather;

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
		fileName VARCHAR(50) PRIMARY KEY,  
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
	



	
