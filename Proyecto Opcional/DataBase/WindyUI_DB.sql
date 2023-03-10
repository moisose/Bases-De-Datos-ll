/*
	INSTITUTO TECNOLÓGICO DE COSTA RICA
		CAMPUS TECNOLÓGICO CARTAGO
	ESCUELA DE INGENIERIA EN COMPUTACION
		BASES DE DATOS 2 - IC4302 
			PROYECTO OPCIONAL
                
	Profesor: Nereo Campos Araya
    
			   Estudiantes: 
	Fiorella Zelaya Coto - 2021
	Isaac Araya Solano
	Joxan Fuertes Villegas - 
	Melany Salas Fernández - 2021121147
	Moises Solano Espinoza -2021
	
			   

    
			I SEMESTRE, 2023
*/

#DROP DATABASE IF EXISTS weather;
CREATE DATABASE IF NOT EXISTS weather;

USE weather;

#----------------------------------------------TABLES-----------------------------------------------
#Table Station 
#
DROP TABLE IF EXISTS station;
CREATE TABLE station (
		idStation VARCHAR(11) PRIMARY KEY,
		latitude REAL,
		longitude REAL,
		elevation REAL,
		stateCode VARCHAR(2),
		stationName VARCHAR(100),
		gsnFlag VARCHAR(3),
		hcnCrnFlag VARCHAR(3),
		wmold VARCHAR(50),
		countryCode VARCHAR(2)
);
	
#Table States 
DROP TABLE IF EXISTS country;
CREATE TABLE country (
		countryCode VARCHAR(2) PRIMARY KEY,
		countryName VARCHAR(100)
);

#Table States 
DROP TABLE IF EXISTS state;
CREATE TABLE state (
		stateCode VARCHAR(2) PRIMARY KEY,
		stateName VARCHAR(100)
);

#Table Files
DROP TABLE IF EXISTS textFile;
CREATE TABLE textFile (
		fileName VARCHAR(50) PRIMARY KEY,  
		url VARCHAR(100),
		processedDay DATE,
		fileMd5 VARCHAR(130),
		fileStatus VARCHAR(20)
);


#FOREING KEYS-------------------------------------------------------
#Station with country
ALTER TABLE station
	ADD CONSTRAINT StationXCountry FOREIGN KEY (CountryCode) REFERENCES Country(countryCode);
#Station with state
ALTER TABLE station
	ADD CONSTRAINT StationXState FOREIGN KEY (stateCode) REFERENCES State(stateCode);	
	



	
