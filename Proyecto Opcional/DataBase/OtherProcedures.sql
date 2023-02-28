USE weather;
#---------------------------OTHER PROCEDURES------------------------------------------

/*
____________________________________________________________________________
-> Procedure for update and create files
-> @restrictions: Values null on file name, url or status
-> @param: file name, url, md5 and status
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS loadFile;
CREATE PROCEDURE loadFile (fileNameVar VARCHAR(50), urlVar VARCHAR(100), fileMd5Var VARCHAR(130), 
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
END;												
$$

#CALL loadFile("PRUEBA", "HPPT.JJKWOK.COM", 2879, "Descargado");

/*
____________________________________________________________________________
-> Procedure for update and create folder files alows null in md5
-> @restrictions: Values null on file name, url or status
-> @param: file name, url, md5 and status
-> @output: result
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS loadFileFolder;
CREATE PROCEDURE loadFileFolder (fileNameVar VARCHAR(50), urlVar VARCHAR(100), fileMd5Var VARCHAR(130), 
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
END;												
$$

#CALL loadFileFolder("PRUEBA", "HPPT.JJKWOK.COM", NULL, "Listado");

