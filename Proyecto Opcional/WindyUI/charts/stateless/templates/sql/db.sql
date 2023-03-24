-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.11.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for weather
DROP DATABASE IF EXISTS `weather`;
CREATE DATABASE IF NOT EXISTS `weather` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `weather`;

-- Dumping structure for table weather.country
DROP TABLE IF EXISTS `country`;
CREATE TABLE IF NOT EXISTS `country` (
  `countryCode` varchar(2) NOT NULL,
  `countryName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`countryCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for procedure weather.createCountry
DROP PROCEDURE IF EXISTS `createCountry`;
DELIMITER //
CREATE PROCEDURE `createCountry`(countryCodeVar VARCHAR(2), countryNameVar VARCHAR(100))
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
END//
DELIMITER ;

-- Dumping structure for procedure weather.createState
DROP PROCEDURE IF EXISTS `createState`;
DELIMITER //
CREATE PROCEDURE `createState`(stateCodeVar VARCHAR(2), stateNameVar VARCHAR(100))
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

END//
DELIMITER ;

-- Dumping structure for procedure weather.createStation
DROP PROCEDURE IF EXISTS `createStation`;
DELIMITER //
CREATE PROCEDURE `createStation`(idStationVar VARCHAR(11), latitudeVar REAL, longitudeVar REAL,
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

END//
DELIMITER ;

-- Dumping structure for procedure weather.createTextFile
DROP PROCEDURE IF EXISTS `createTextFile`;
DELIMITER //
CREATE PROCEDURE `createTextFile`(fileNameVAR VARCHAR(50), urlVAR VARCHAR(100),
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

END//
DELIMITER ;

-- Dumping structure for procedure weather.deleteCountry
DROP PROCEDURE IF EXISTS `deleteCountry`;
DELIMITER //
CREATE PROCEDURE `deleteCountry`(countryCodeV VARCHAR(2))
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
END//
DELIMITER ;

-- Dumping structure for procedure weather.deleteState
DROP PROCEDURE IF EXISTS `deleteState`;
DELIMITER //
CREATE PROCEDURE `deleteState`(stateCodeV VARCHAR(2))
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
END//
DELIMITER ;

-- Dumping structure for procedure weather.deleteStation
DROP PROCEDURE IF EXISTS `deleteStation`;
DELIMITER //
CREATE PROCEDURE `deleteStation`(idStationV INT)
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
END//
DELIMITER ;

-- Dumping structure for procedure weather.deleteTextFile
DROP PROCEDURE IF EXISTS `deleteTextFile`;
DELIMITER //
CREATE PROCEDURE `deleteTextFile`(fileNameV VARCHAR(50))
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
END//
DELIMITER ;

-- Dumping structure for procedure weather.loadFile
DROP PROCEDURE IF EXISTS `loadFile`;
DELIMITER //
CREATE PROCEDURE `loadFile`(fileNameVar VARCHAR(50), urlVar VARCHAR(100), fileMd5Var VARCHAR(130), 
									fileStatusVar VARCHAR(20))
BEGIN
		IF ISNULL(fileNameVar) OR ISNULL(urlVar) OR ISNULL(fileMd5Var) OR ISNULL(fileStatusVar) THEN
			SELECT "There are values NULL";
		ELSEIF (SELECT COUNT(*) FROM textFile WHERE fileName = fileNameVar) = 0 THEN
			CALL createTextFile(fileNameVar, urlVar, fileMd5Var, fileStatusVar);
			SELECT "The file has been created";
		ELSEIF (SELECT fileMd5 FROM textFile WHERE fileName = fileNameVar) = fileMd5Var THEN
			#CALL createTextFile(fileNameVar, urlVar, fileMd5Var, fileStatusVar);country
			SELECT "The file has no changes";
		ELSE
			CALL updateTextFile(fileNameVar, NULL, (SELECT DATE(NOW())), fileMd5Var, fileStatusVar);
		END IF;
END//
DELIMITER ;

-- Dumping structure for procedure weather.loadFileFolder
DROP PROCEDURE IF EXISTS `loadFileFolder`;
DELIMITER //
CREATE PROCEDURE `loadFileFolder`(fileNameVar VARCHAR(50), urlVar VARCHAR(100), fileMd5Var VARCHAR(130), 
												fileStatusVar VARCHAR(20))
BEGIN
		IF ISNULL(fileNameVar) OR ISNULL(urlVar) OR ISNULL(fileStatusVar) THEN
			SELECT "There are values NULL";
		ELSEIF (SELECT COUNT(*) FROM textFile WHERE fileName = fileNameVar) = 0 THEN
			CALL createTextFile(fileNameVar, urlVar, fileMd5Var, fileStatusVar);
			SELECT "The file has been created";
		# md5 will never be the same because, NULL is always passed
		ELSEIF (SELECT fileMd5 FROM textFile WHERE fileName = fileNameVar) = fileMd5Var THEN
			SELECT "The file has no changes";
		ELSE
			CALL updateTextFile(fileNameVar, NULL, (SELECT DATE(NOW())), NULL, fileStatusVar);
		END IF;
END//
DELIMITER ;

-- Dumping structure for procedure weather.readCountry
DROP PROCEDURE IF EXISTS `readCountry`;
DELIMITER //
CREATE PROCEDURE `readCountry`(countryCodeVar VARCHAR(2), countryNameVar VARCHAR(100))
BEGIN
		IF (SELECT COUNT(*) FROM country WHERE countryCode = IFNULL(countryCodeVar, countryCode) 
													AND countryName = IFNULL(countryNameVar, countryName)) = 0 THEN
			SELECT "There is no Country with those specifications " AS "Result";
		ELSE
			SELECT countryCode, countryName FROM country 
				WHERE countryCode = IFNULL(countryCodeVar, countryCode) AND
						countryName = IFNULL(countryNameVar, countryName);
		END IF;
END//
DELIMITER ;

-- Dumping structure for procedure weather.readState
DROP PROCEDURE IF EXISTS `readState`;
DELIMITER //
CREATE PROCEDURE `readState`(stateCodeVar VARCHAR(2), stateNameVar VARCHAR(100))
BEGIN
		IF (SELECT COUNT(*) FROM state WHERE stateCode = IFNULL(stateCodeVar, stateCode) 
													AND stateName = IFNULL(stateNameVar, stateName)) = 0 THEN
			SELECT "There is no State with those specifications " AS "Result";
		ELSE
			SELECT stateCode, stateName FROM state 
				WHERE stateCode = IFNULL(stateCodeVar, stateCode) AND
						stateName = IFNULL(stateNameVar, stateName);
		END IF;
END//
DELIMITER ;

-- Dumping structure for procedure weather.readStation
DROP PROCEDURE IF EXISTS `readStation`;
DELIMITER //
CREATE PROCEDURE `readStation`(idStationVar VARCHAR(11), stateCodeVar VARCHAR(2), 
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
END//
DELIMITER ;

-- Dumping structure for procedure weather.readTextFile
DROP PROCEDURE IF EXISTS `readTextFile`;
DELIMITER //
CREATE PROCEDURE `readTextFile`( fileNameVAR VARCHAR(50), urlVAR VARCHAR(100),
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
END//
DELIMITER ;

-- Dumping structure for procedure weather.sameFolderFileMD5
DROP PROCEDURE IF EXISTS `sameFolderFileMD5`;
DELIMITER //
CREATE PROCEDURE `sameFolderFileMD5`(fileNameVar VARCHAR(50), fileMd5Var VARCHAR(10000), OUT sameMD5 INT)
BEGIN
		IF ISNULL(fileNameVar) THEN
			SET sameMD5 = 1;
		ELSEIF (SELECT COUNT(*) FROM textFile WHERE fileName = fileNameVar) = 0 THEN
			SET sameMD5 = 1;
		ELSEIF (SELECT fileMd5 FROM textFile WHERE fileName = fileNameVar) = fileMd5Var THEN
			SET sameMD5 = 1;
			CALL updateTextFile(fileNameVar, NULL, NULL, NULL, "PROCESSED");
		ELSE
			SET sameMD5 = 0;
			CALL updateTextFile(fileNameVar, NULL, NULL, fileMd5Var, "DOWNLOADED");
		END IF;

END//
DELIMITER ;

-- Dumping structure for table weather.state
DROP TABLE IF EXISTS `state`;
CREATE TABLE IF NOT EXISTS `state` (
  `stateCode` varchar(2) NOT NULL,
  `stateName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`stateCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table weather.station
DROP TABLE IF EXISTS `station`;
CREATE TABLE IF NOT EXISTS `station` (
  `idStation` varchar(11) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `elevation` double DEFAULT NULL,
  `stateCode` varchar(2) DEFAULT NULL,
  `stationName` varchar(100) DEFAULT NULL,
  `gsnFlag` varchar(3) DEFAULT NULL,
  `hcnCrnFlag` varchar(3) DEFAULT NULL,
  `wmold` varchar(50) DEFAULT NULL,
  `countryCode` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`idStation`),
  KEY `StationXCountry` (`countryCode`),
  KEY `StationXState` (`stateCode`),
  CONSTRAINT `StationXCountry` FOREIGN KEY (`countryCode`) REFERENCES `country` (`countryCode`),
  CONSTRAINT `StationXState` FOREIGN KEY (`stateCode`) REFERENCES `state` (`stateCode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table weather.textfile
DROP TABLE IF EXISTS `textfile`;
CREATE TABLE IF NOT EXISTS `textfile` (
  `fileName` varchar(50) NOT NULL,
  `url` varchar(100) DEFAULT NULL,
  `processedDay` date DEFAULT NULL,
  `fileMd5` varchar(130) DEFAULT NULL,
  `fileStatus` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`fileName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for procedure weather.updateCountry
DROP PROCEDURE IF EXISTS `updateCountry`;
DELIMITER //
CREATE PROCEDURE `updateCountry`(countryCodeVar VARCHAR(2), countryNameVar VARCHAR(100))
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
	
END//
DELIMITER ;

-- Dumping structure for procedure weather.updateState
DROP PROCEDURE IF EXISTS `updateState`;
DELIMITER //
CREATE PROCEDURE `updateState`(stateCodeVar VARCHAR(2), stateNameVar VARCHAR(100))
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
	
END//
DELIMITER ;

-- Dumping structure for procedure weather.updateStation
DROP PROCEDURE IF EXISTS `updateStation`;
DELIMITER //
CREATE PROCEDURE `updateStation`(idStationVar VARCHAR(11), latitudeVar REAL, longitudeVar REAL,
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
	
END//
DELIMITER ;

-- Dumping structure for procedure weather.updateTextFile
DROP PROCEDURE IF EXISTS `updateTextFile`;
DELIMITER //
CREATE PROCEDURE `updateTextFile`(fileNameVAR VARCHAR(100), urlVAR VARCHAR(100), processedDayVar DATE,
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
	
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
