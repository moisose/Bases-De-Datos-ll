#-------------------------------CRUD PROCEDURES-------------------------------
DROP PROCEDURE IF EXISTS createStation;
DROP PROCEDURE IF EXISTS createCountry;
DROP PROCEDURE IF EXISTS createState;


#-----------------------------------CREATES-----------------------------------
#STATION______________________________________________________________________
DELIMITER $$
CREATE PROCEDURE createStation (idStationVar VARCHAR(11), latitudeVar REAL, longitudeVar REAL,
											elevationVar REAL, stateCodeVar VARCHAR(2), stationNameVar VARCHAR(50),
											gsnFlagVar VARCHAR(3), hcnCrnFlagVar VARCHAR(3), wmoldVar VARCHAR(3),
											countryCodeVar VARCHAR(2))
BEGIN
	#Verifies if there is an important value in NULL
	IF idStationVar IS NULL OR stationNameVar IS NULL OR countryCodeVar IS NULL THEN
			SELECT "Error, valores en NULL";
	#Verifies if the station already exists
	ELSEIF (SELECT COUNT(*) FROM station WHERE idStation = idStationVar) THEN
			SELECT "Error, la estación ya existe";
	#Verifies if the state exists, if there is a state
	ELSEIF (SELECT COUNT(*) FROM state WHERE stateCode = stateCodeVar) = 0 AND 
			stateCodeVar IS NOT NULL THEN
			SELECT "Error con el state code";
	#Verifies if the country exists
	ELSEIF (SELECT COUNT(*) FROM country WHERE countryCode = countryCodeVar) = 0 THEN
			SELECT "Error con el country code";
	ELSE 
		INSERT INTO station (idStation, latitude, longitude, elevation, stateCode, 
									stationName, gsnFlag, hcnCrnFlag, wmold, countryCode)
						VALUES(idStationVar, latitudeVar, longitudeVar, elevationVar, 
									stateCodeVar, stationNameVar, gsnFlagVar, hcnCrnFlagVar,
									wmoldVar, countryCodeVar);
	END IF;

END;
$$

#COUNTRY______________________________________________________________________
DELIMITER $$
CREATE PROCEDURE createCountry (countryCodeVar VARCHAR(2), countryNameVar VARCHAR(50))
BEGIN
	IF (SELECT COUNT(*) FROM country WHERE countryCode = countryCodeVar) != 0 THEN
		SELECT "Error al crear el country";
	ELSE 
		INSERT INTO country (countryCode, countryName)
				VALUES (countryCodeVar, countryNameVar);
		SELECT "Se ha creado" AS "Resultado";
	END IF;

END;
$$

#STATE________________________________________________________________________
DELIMITER $$
CREATE PROCEDURE createState (stateCodeVar VARCHAR(2), stateNameVar VARCHAR(50))
BEGIN
	IF (SELECT COUNT(*) FROM state WHERE stateCode = stateCodeVar) != 0 THEN
		SELECT "Error al crear el state";
	ELSE
		INSERT INTO state (stateCode, stateName)
				VALUES (stateCodeVar, stateNameVar);
		SELECT "Se ha creado" AS "Resultado";
	END IF;

END;
$$

#FILE_________________________________________________________________________





#---------------------------------_--READ-----------_------------------------
#STATION______________________________________________________________________
#COUNTRY______________________________________________________________________
#STATE________________________________________________________________________
#FILE_________________________________________________________________________


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