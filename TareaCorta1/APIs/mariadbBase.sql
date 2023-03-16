#CREATE DATABASE BabyNames;


CREATE TABLE BabyName (
  id INT AUTO_INCREMENT PRIMARY KEY,
  birthyear INT,
  gender VARCHAR(10),
  ethnicity VARCHAR(50),
  nm INT,
  cnt INT,
  rnk INT
);

DELIMITER $$
USE BabyNames;
CREATE PROCEDURE sp_BabyName_Insert (
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_nm INT,
   p_cnt INT,
   p_rnk INT
)
BEGIN
  INSERT INTO BabyName (birthyear, gender, ethnicity, nm, cnt, rnk)
  VALUES (p_birthyear, p_gender, p_ethnicity, p_nm, p_cnt, p_rnk);
END;$$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_BabyName_Select (
   p_id INT
)
BEGIN
  SELECT *
  FROM BabyName
  WHERE id = p_id;
END;$$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_BabyName_Update (
   p_id INT,
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_nm INT,
   p_cnt INT,
   p_rnk INT
)
BEGIN
  UPDATE BabyName
  SET birthyear = p_birthyear,
      gender = p_gender,
      ethnicity = p_ethnicity,
      nm = p_nm,
      cnt = p_cnt,
      rnk = p_rnk
  WHERE id = p_id;
END;$$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_BabyName_Delete (
   p_id INT
)
BEGIN
  DELETE FROM BabyName
  WHERE id = p_id;
END;$$

DELIMITER ;

