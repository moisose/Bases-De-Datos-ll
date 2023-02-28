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
CREATE PROCEDURE loadFile (fileNameVar VARCHAR(50), urlVar VARCHAR(100), fileMd5Var INT, 
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
CREATE PROCEDURE loadFileFolder (fileNameVar VARCHAR(50), urlVar VARCHAR(100), fileMd5Var VARCHAR(10000), 
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

/*
____________________________________________________________________________
-> Procedure that verifies if a folder file has the same md5
-> @restrictions: Values null on file name or md5
-> @param: file name and md5
-> @output: result
*/
DELIMITER $$
DROP FUNCTION IF EXISTS sameFolderFileMD5;
CREATE FUNCTION sameFolderFileMD5 (fileNameVar VARCHAR(50), fileMd5Var VARCHAR(10000)) RETURNS BOOL
BEGIN
		IF ISNULL(fileNameVar) OR ISNULL(fileMd5Var) THEN
			RETURN TRUE;
		ELSEIF (SELECT COUNT(*) FROM textFile WHERE fileName = fileNameVar) = 0 THEN
			RETURN TRUE;
		ELSEIF (SELECT fileMd5 FROM textFile WHERE fileName = fileNameVar) = fileMd5Var THEN
			CALL updateTextFile(fileNameVar, NULL, NULL, NULL, "PROCESSED");
			RETURN TRUE;
		ELSE
			CALL updateTextFile(fileNameVar, NULL, NULL, fileMd5Var, "DOWNLOADED");
			RETURN FALSE;
		END IF;
END;												
$$

#textfileCALL sameFolderFileMD5("PRUEBA", 1111);

