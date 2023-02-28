USE weather;
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
											elevationVar REAL, stateCodeVar VARCHAR(2), stationNameVar VARCHAR(100),
											gsnFlagVar VARCHAR(3), hcnCrnFlagVar VARCHAR(3), wmoldVar VARCHAR(50),
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
CREATE PROCEDURE createCountry (countryCodeVar VARCHAR(2), countryNameVar VARCHAR(100))
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
CREATE PROCEDURE createState (stateCodeVar VARCHAR(2), stateNameVar VARCHAR(100))
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
CREATE PROCEDURE createTextFile (fileNameVAR VARCHAR(50), urlVAR VARCHAR(100),
										fileMd5VAR VARCHAR(130), fileStatusVar VARCHAR(20))
BEGIN
	IF ISNULL(fileNameVAR) OR ISNULL(urlVAR) THEN 
		SELECT "There are values NULL";
	ELSEIF (SELECT COUNT(*) FROM textFile WHERE fileName = fileNameVAR) != 0 THEN
		SELECT "The File already exists";
	ELSE
		INSERT INTO textFile (FileName, url, fileMd5, fileStatus, processedDay)
									VALUES (fileNameVar, urlVar, fileMd5Var, fileStatusVar, (SELECT DATE(NOW())));
											#(SELECT DATE_FORMAT(NOW(), "%m-%d-%Y")));
		SELECT "The file has been created";
	END IF;

END;
$$

#CALL createTextFile ("Prueba.txt","jaksls.com", 1672, "Descargado" );


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
										stationNameVar VARCHAR(100), countryCodeVar VARCHAR(2))
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
CREATE PROCEDURE readCountry (countryCodeVar VARCHAR(2), countryNameVar VARCHAR(100))
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
CREATE PROCEDURE readState (stateCodeVar VARCHAR(2), stateNameVar VARCHAR(100))
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
CREATE PROCEDURE readTextFile ( fileNameVAR VARCHAR(50), urlVAR VARCHAR(100),
										fileStatusVar VARCHAR(20))
BEGIN
		IF (SELECT COUNT(*) FROM textFile WHERE fileName = IFNULL(fileNameVAR, fileName) AND
													url = IFNULL(urlVAR, url) AND 
													fileStatus = IFNULL(fileStatusVar, fileStatus)) = 0 THEN
			SELECT "There is no file with those specifications " AS "Result";
		ELSE
			SELECT fileName, url, fileMd5, fileStatus, processedDay FROM textFile 
					WHERE fileName = IFNULL(fileNameVAR, fileName) 
					AND url = IFNULL(urlVAR, url) AND fileStatus = IFNULL(fileStatusVar, fileStatus);
		END IF;
END;
$$
#CALL readTextFile(NULL, NULL, NULL);

#-----------------------------------UPDATE-----------------------------------
/*
STATION______________________________________________________________________
-> 
-> @restrictions: 
-> @param: 
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE if EXISTS updateStation;
CREATE PROCEDURE updateStation (idStationVar VARCHAR(11), latitudeVar REAL, longitudeVar REAL,
											elevationVar REAL, stateCodeVar VARCHAR(2), stationNameVar VARCHAR(100),
											gsnFlagVar VARCHAR(3), hcnCrnFlagVar VARCHAR(3), wmoldVar VARCHAR(50),
											countryCodeVar VARCHAR(2))
BEGIN 
	# an id is required to modify
	IF (idStationVar IS NULL) THEN 
		SELECT "You must enter the id to be able to modify the station." AS "Result";
	# check that the station exists	
	ELSEIF (SELECT COUNT(*) FROM station WHERE station.idStation = idStationVar) = 0 THEN
		SELECT "The station does not exist." AS "Result";
	# check that the country exists	
	ELSEIF (SELECT COUNT(*) FROM country WHERE country.countryCode = countryCodeVar) = 0 THEN
		SELECT "The new country does not exist." AS "Result";
	# check that the state exists
	ELSEIF (SELECT COUNT(*) FROM state WHERE state.stateCode = stateCodeVar) = 0 THEN
		SELECT "The new state does not exist." AS "Result";
	# the desired data is modified
	ELSE
		UPDATE station SET station.latitude = IFNULL(latitudeVar, station.latitude),
        station.longitude = IFNULL(longitudeVar, station.longitude),
        station.elevation = IFNULL(elevationVar, station.elevation),
        station.stateCode = IFNULL(stateCodeVar, station.stateCode),
        station.stationName = IFNULL(stationNameVar, station.stationName),
        station.gsnFlag = IFNULL(gsnFlagVar, station.gsnFlag),
        station.hcnCrnFlag = IFNULL(hcnCrnFlagVar, station.hcnCrnFlag),
        station.wmold = IFNULL(wmoldVar, station.wmold),
        station.countryCode = IFNULL(countryCodeVar, station.countryCode)
        
        
        WHERE station.idStation = idStationVar;
        SELECT "The station has been successfully modified.";
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
DROP PROCEDURE if EXISTS updateCountry;
CREATE PROCEDURE updateCountry (countryCodeVar VARCHAR(2), countryNameVar VARCHAR(100))
BEGIN 
	# an id is required to modify
	IF (countryCodeVar IS NULL) THEN 
		SELECT "You must enter the id to be able to modify the country." AS "Result";
	# check that the country exists	
	ELSEIF (SELECT COUNT(*) FROM country WHERE country.countryCode = countryCodeVar) = 0 THEN
		SELECT "The country does not exist." AS "Result";
	# check that the country name does not exists	
	ELSEIF (SELECT COUNT(*) FROM country WHERE country.countryName = countryNameVar) = 1 THEN
		SELECT "The new country name already exist." AS "Result";
	# the desired data is modified
	ELSE
		UPDATE country SET country.countryName = IFNULL(countryNameVar, country.countryName)  
        
        WHERE country.countryCode = countryCodeVar;
        SELECT "The country has been successfully modified.";
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
DROP PROCEDURE if EXISTS updateState;
CREATE PROCEDURE updateState (stateCodeVar VARCHAR(2), stateNameVar VARCHAR(100))
BEGIN 
	# an id is required to modify
	IF (stateCodeVar IS NULL) THEN 
		SELECT "You must enter the id to be able to modify the country." AS "Result";
	# check that the country exists	
	ELSEIF (SELECT COUNT(*) FROM state WHERE state.stateCode = stateCodeVar) = 0 THEN
		SELECT "The state does not exist." AS "Result";
	# check that the state name does not exists	
	ELSEIF (SELECT COUNT(*) FROM state WHERE state.stateName = stateNameVar) = 1 THEN
		SELECT "The new state name already exist." AS "Result";
	# the desired data is modified
	ELSE
		UPDATE state SET state.stateName = IFNULL(stateNameVar, state.stateName)  
        
        WHERE state.stateCode = stateCodeVar;
        SELECT "The state has been successfully modified.";
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
DROP PROCEDURE IF EXISTS updateTextFile;
CREATE PROCEDURE updateTextFile (fileNameVAR VARCHAR(100), urlVAR VARCHAR(100), processedDayVar DATE,
										fileMd5VAR VARCHAR(130), fileStatusVAR VARCHAR(20))
BEGIN 
	# an id is required to modify
	IF (fileNameVAR IS NULL) THEN 
		SELECT "You must enter the fileName to be able to modify the country." AS "Result";
	# check that the textFile exists	
	ELSEIF (SELECT COUNT(*) FROM textfile WHERE textfile.fileName = fileNameVAR) = 0 THEN
		SELECT "The textFile does not exist." AS "Result";
	# check that the new url does not exists	
	ELSEIF (SELECT COUNT(*) FROM textfile WHERE textfile.url = urlVAR) = 1 THEN
		SELECT "The new url already exist." AS "Result";
	# the desired data is modified
	ELSE
		UPDATE textfile SET textfile.url = IFNULL(urlVAR, textfile.url),  
			textfile.processedDay = IFNULL(processedDayVar, textfile.processedDay),
			textfile.fileMd5 = IFNULL(fileMd5VAR, textfile.fileMd5),
			textfile.fileStatus = IFNULL(fileStatusVAR, textfile.fileStatus)
        
        WHERE textfile.fileName = fileNameVAR;
        SELECT "The textFile has been successfully modified.";
	END IF;
	
END;
$$

#-----------------------------------DELETE-----------------------------------
/*
STATION______________________________________________________________________
-> 
-> @restrictions: 
-> @param: 
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS deleteStation;
CREATE PROCEDURE deleteStation (idStationV INT)
BEGIN
	DECLARE message VARCHAR(60);
    # error handling - fk
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR - The station cannot be deleted." AS Result;
    
    IF (idStationV IS NULL) THEN
		SET message = "ERROR - Cannot enter null data";
	ELSEIF (SELECT COUNT(*) FROM station WHERE station.idStation = idStationV) = 0 THEN
		SET message = "ERROR - There is no station with the entered id.";
	ELSE
		DELETE FROM station WHERE station.idStation = idStationV;
		SET message = "Delete successfully.";
	END IF;
    SELECT message AS Result;
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
DROP PROCEDURE IF EXISTS deleteCountry;
CREATE PROCEDURE deleteCountry (countryCodeV VARCHAR(2))
BEGIN
	DECLARE message VARCHAR(60);
    # error handling - fk
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR - The country cannot be deleted." AS Result;
    
    IF (countryCodeV IS NULL) THEN
		SET message = "ERROR - Cannot enter null data";
	ELSEIF (SELECT COUNT(*) FROM country WHERE country.countryCode = countryCodeV) = 0 THEN
		SET message = "ERROR - There is no country with the entered code.";
	ELSE
		DELETE FROM country WHERE country.countryCode = countryCodeV;
		SET message = "Delete successfully.";
	END IF;
    SELECT message AS Result;
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
DROP PROCEDURE IF EXISTS deleteState;
CREATE PROCEDURE deleteState (stateCodeV VARCHAR(2))
BEGIN
	DECLARE message VARCHAR(60);
    # error handling - fk
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR - The state cannot be deleted." AS Result;
    
    IF (stateCodeV IS NULL) THEN
		SET message = "ERROR - Cannot enter null data";
	ELSEIF (SELECT COUNT(*) FROM state WHERE state.stateCode = stateCodeV) = 0 THEN
		SET message = "ERROR - There is no state with the entered code.";
	ELSE
		DELETE FROM state WHERE state.stateCode = stateCodeV;
		SET message = "Delete successfully.";
	END IF;
    SELECT message AS Result;
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
DROP PROCEDURE IF EXISTS deleteTextFile;
CREATE PROCEDURE deleteTextFile (fileNameV VARCHAR(50))
BEGIN
	DECLARE message VARCHAR(60);
    # error handling - fk
	DECLARE EXIT HANDLER FOR 1451 
		SELECT "ERROR - The textFile cannot be deleted." AS Result;
    
    IF (fileNameV IS NULL) THEN
		SET message = "ERROR - Cannot enter null data";
	ELSEIF (SELECT COUNT(*) FROM textfile WHERE textfile.fileName = fileNameV) = 0 THEN
		SET message = "ERROR - There is no textFile with the entered file name.";
	ELSE
		DELETE FROM textfile WHERE textfile.fileName = fileNameV;
		SET message = "Delete successfully.";
	END IF;
    SELECT message AS Result;
END;
$$


# ==============================================================================================
# ==============================================================================================
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



# ============
#CALL updateStation(null, null, null, null, null, null, null, null, null, null)




#INSERT INTO country (countryCode, countryName)
#				VALUES ("CR", "Costa Rica");
#CALL updateCountry("CR", "Costa Ricaa");
#SELECT * FROM country;	




#INSERT INTO state (stateCode, stateName)
#				VALUES ("AB", "ALBERTA");
				
#CALL updateState("AB", "ALBERTAA");

#SELECT * FROM state;		





#SELECT * FROM country;
#CALL deleteCountry("CR");				




#SELECT * FROM state;
#CALL deleteState("AB");