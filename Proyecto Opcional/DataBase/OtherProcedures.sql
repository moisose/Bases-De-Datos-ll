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
			#CALL createTextFile(fileNameVar, urlVar, fileMd5Var, fileStatusVar);
			SELECT "The file has no changes";
		ELSE
			CALL updateTextFile(fileNameVar, NULL, (SELECT DATE(NOW())), fileMd5Var, fileStatusVar);
		END IF;
END;												
$$

#CALL loadFile("PRUEBA", "HPPT.JJKWOK.COM", 2879, "Descargado");