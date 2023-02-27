#-------------------------------CRUD PROCEDURES-------------------------------

#-----------------------------------CREATES-----------------------------------
/*
STATION______________________________________________________________________
-> Creates a station
-> @restrictions: idStationVar, stationNameVar, countryCodeVar can`t be null
						If the station have a state, it have to exists
						The country have to exists
-> @param: Station id, latitude, longitude, elevation, state code, station name, gsn flag
				hcn flag, wmold, countrycode
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS createStation;
CREATE PROCEDURE createStation (idStationVar VARCHAR(11), latitudeVar REAL, longitudeVar REAL,
											elevationVar REAL, stateCodeVar VARCHAR(2), stationNameVar VARCHAR(50),
											gsnFlagVar VARCHAR(3), hcnCrnFlagVar VARCHAR(3), wmoldVar VARCHAR(3),
											countryCodeVar VARCHAR(2))
BEGIN
	#Verifies if there is an important value in NULL
	IF idStationVar IS NULL OR stationNameVar IS NULL OR countryCodeVar IS NULL THEN
			SELECT "There are values NULL";
	#Verifies if the station already exists
	ELSEIF (SELECT COUNT(*) FROM station WHERE idStation = idStationVar) THEN
			SELECT "The station already exists";
	#Verifies if the state exists, if there is a state
	ELSEIF (SELECT COUNT(*) FROM state WHERE stateCode = stateCodeVar) = 0 AND 
			stateCodeVar IS NOT NULL THEN
			SELECT "There is no state with that code";
	#Verifies if the country exists
	ELSEIF (SELECT COUNT(*) FROM country WHERE countryCode = countryCodeVar) = 0 THEN
			SELECT "There is no country with that code";
	#Verifies if there is a station with the same code
	ELSEIF (SELECT COUNT(*) FROM station WHERE idStation = idStationVar) != 0 THEN
			SELECT "The station already exists";
	ELSE 
		INSERT INTO station (idStation, latitude, longitude, elevation, stateCode, 
									stationName, gsnFlag, hcnCrnFlag, wmold, countryCode)
						VALUES(idStationVar, latitudeVar, longitudeVar, elevationVar, 
									stateCodeVar, stationNameVar, gsnFlagVar, hcnCrnFlagVar,
									wmoldVar, countryCodeVar);
		SELECT "The station has been created";
	END IF;

END;
$$

/*
COUNTRY______________________________________________________________________
-> Creates a Country
-> @restrictions: 
-> @param: 
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS createCountry;
CREATE PROCEDURE createCountry (countryCodeVar VARCHAR(2), countryNameVar VARCHAR(50))
BEGIN
	IF ISNULL(countryCodeVar) OR ISNULL(countryNameVar) THEN
		SELECT "There are values NULL";
	ELSEIF (SELECT COUNT(*) FROM country WHERE countryCode = countryCodeVar) != 0 THEN
		SELECT "The country already exists"; 
	ELSE 
		INSERT INTO country (countryCode, countryName)
				VALUES (countryCodeVar, countryNameVar);
		SELECT "The country has been created";
	END IF;
END;
$$

/*
STATE________________________________________________________________________
-> Creates a state
-> @restrictions: 
-> @param: 
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS createState;
CREATE PROCEDURE createState (stateCodeVar VARCHAR(2), stateNameVar VARCHAR(50))
BEGIN
	IF ISNULL(stateCodeVar) OR ISNULL(stateNameVar) THEN 
		SELECT "There are values NULL";
	ELSEIF (SELECT COUNT(*) FROM state WHERE stateCode = stateCodeVar) != 0 THEN
		SELECT "The state already exists";
	ELSE
		INSERT INTO state (stateCode, stateName)
				VALUES (stateCodeVar, stateNameVar);
		SELECT "The state has been created";
	END IF;

END;
$$

/*
FILE_________________________________________________________________________
-> Creates a text file
-> @restrictions: 
-> @param: 
-> @output: result
*/

DELIMITER $$
DROP PROCEDURE IF EXISTS createTextFile;
CREATE PROCEDURE createTextFile ( fileCodeVAR INT, fileNameVAR VARCHAR(50), urlVAR VARCHAR(100),
										fileMd5VAR INT, fileStateVAR VARCHAR(20))
BEGIN
	IF ISNULL(fileCodeVAR) OR ISNULL(fileNameVAR) OR ISNULL(urlVAR) THEN 
		SELECT "There are values NULL";
	ELSEIF (SELECT COUNT(*) FROM textFile WHERE fileCode = fileCodeVAR) != 0 THEN
		SELECT "The File already exists";
	ELSE
		INSERT INTO textFile (fileCode, fileName, url, fileMd5, fileState, processedDay)
									VALUES (fileCodeVar, fileNameVar, urlVar, fileMd5Var, fileStateVar, (SELECT DATE(NOW())));
											#(SELECT DATE_FORMAT(NOW(), "%m-%d-%Y")));
		SELECT "The file has been created";
	END IF;

END;
$$

#CALL createTextFile (NULL, "Prueba.txt","jaksls.com", 1672, "Descargado" );


#-------------------------------------READ------------------------------------
#
/*
STATION______________________________________________________________________
-> 
-> @restrictions: 
-> @param: 
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS readStation;
CREATE PROCEDURE readStation (idStationVar VARCHAR(11), stateCodeVar VARCHAR(2), 
										stationNameVar VARCHAR(50), countryCodeVar VARCHAR(2))
BEGIN

		IF ( SELECT COUNT(*) FROM station WHERE idStation = IFNULL(idStationVar, idStation) 
														AND stationName = IFNULL(stationNameVar, stationName) 
														AND countryCode = IFNULL(countryCodeVar, countryCode) 
														AND (stateCode = IFNULL(stateCodeVar, stateCode) OR ISNULL(stateCode))) = 0 THEN
				SELECT "There is no station with those specifications " AS "Result";
		ELSE
			SELECT idStation, stationName, countryCode, Latitude, longitude, elevation, stateCode, gsnFlag, hcnCrnFlag, wmold
					FROM station WHERE idStation = IFNULL(idStationVar, idStation) AND 
											stationName = IFNULL(stationNameVar, stationName) AND
											countryCode = IFNULL(countryCodeVar, countryCode) AND
											(stateCode = IFNULL(stateCodeVar, stateCode) OR ISNULL(stateCode));
		END IF;
END;
$$

/*
COUNTRY______________________________________________________________________
-> 
-> @restrictions: 
-> @param: 
-> @output: result
*/

DELIMITER $$
DROP PROCEDURE IF EXISTS readCountry;
CREATE PROCEDURE readCountry (countryCodeVar VARCHAR(2), countryNameVar VARCHAR(50))
BEGIN
		IF (SELECT COUNT(*) FROM country WHERE countryCode = IFNULL(countryCodeVar, countryCode) 
													AND countryName = IFNULL(countryNameVar, countryName)) = 0 THEN
			SELECT "There is no Country with those specifications " AS "Result";
		ELSE
			SELECT countryCode, countryName FROM country 
				WHERE countryCode = IFNULL(countryCodeVar, countryCode) AND
						countryName = IFNULL(countryNameVar, countryName);
		END IF;
END;
$$
/*
STATE________________________________________________________________________
-> 
-> @restrictions: 
-> @param: 
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS readState;
CREATE PROCEDURE readState (stateCodeVar VARCHAR(2), stateNameVar VARCHAR(50))
BEGIN
		IF (SELECT COUNT(*) FROM state WHERE stateCode = IFNULL(stateCodeVar, stateCode) 
													AND stateName = IFNULL(stateNameVar, stateName)) = 0 THEN
			SELECT "There is no State with those specifications " AS "Result";
		ELSE
			SELECT stateCode, stateName FROM state 
				WHERE stateCode = IFNULL(stateCodeVar, stateCode) AND
						stateName = IFNULL(stateNameVar, stateName);
		END IF;
END;
$$
/*
FILE_________________________________________________________________________
-> 
-> @restrictions: 
-> @param: 
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS readTextFile;
CREATE PROCEDURE readTextFile ( fileCodeVAR INT, fileNameVAR VARCHAR(50), urlVAR VARCHAR(100),
										fileStateVAR VARCHAR(20))
BEGIN
		IF (SELECT COUNT(*) FROM textFile WHERE fileCode = IFNULL(fileCodeVAR, fileCode) 
													AND fileName = IFNULL(fileNameVAR, fileName) AND
													url = IFNULL(urlVAR, url) AND 
													fileState = IFNULL(fileStateVAR, fileState)) = 0 THEN
			SELECT "There is no file with those specifications " AS "Result";
		ELSE
			SELECT fileCode, fileName, url, fileMd5, fileState, processedDay FROM textFile 
					WHERE fileCode = IFNULL(fileCodeVAR, fileCode) AND fileName = IFNULL(fileNameVAR, fileName) 
					AND url = IFNULL(urlVAR, url) AND fileState = IFNULL(fileStateVAR, fileState);
		END IF;
END;
$$
#CALL readTextFile(NULL, NULL, NULL, NULL);

#-----------------------------------UPDATE-----------------------------------
#STATION______________________________________________________________________
#COUNTRY______________________________________________________________________
#STATE________________________________________________________________________
#FILE_________________________________________________________________________

#-----------------------------------DELETE-----------------------------------
#STATION______________________________________________________________________
#COUNTRY______________________________________________________________________
#STATE________________________________________________________________________
#FILE_________________________________________________________________________




#Pruebas


#CALL createState(NULL, "CALIFORNIA");
#SELECT * FROM state;
#CALL createCountry(NULL, "Estados");
#SELECT * FROM country;

#CALL createStation("PRUEBA2", 12.8, 12.2, 21, NULL, "NOMBRE", "123", "123", "123", "EU");

#SELECT * FROM station;

#SELECT COUNT(*) FROM country WHERE countryCode = "EU"
#CALL readStation("HEKL", NULL, NULL, NULL);
#CALL readCountry(NULL, NULL);
#CALL readState("EH", NULL);


#SELECT * FROM station;

							
