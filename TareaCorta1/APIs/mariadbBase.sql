CREATE TABLE BabyName (
  id INT AUTO_INCREMENT PRIMARY KEY,
  birthyear INT,
  gender VARCHAR(10),
  ethnicity VARCHAR(50),
  nm INT,
  cnt INT,
  rnk INT
);

CREATE PROCEDURE sp_BabyName_Insert (
  IN p_birthyear INT,
  IN p_gender VARCHAR(10),
  IN p_ethnicity VARCHAR(50),
  IN p_nm INT,
  IN p_cnt INT,
  IN p_rnk INT
)
BEGIN
  INSERT INTO BabyName (birthyear, gender, ethnicity, nm, cnt, rnk)
  VALUES (p_birthyear, p_gender, p_ethnicity, p_nm, p_cnt, p_rnk);
END;


CREATE PROCEDURE sp_BabyName_Select (
  IN p_id INT
)
BEGIN
  SELECT *
  FROM BabyName
  WHERE id = p_id;
END;

CREATE PROCEDURE sp_BabyName_Update (
  IN p_id INT,
  IN p_birthyear INT,
  IN p_gender VARCHAR(10),
  IN p_ethnicity VARCHAR(50),
  IN p_nm INT,
  IN p_cnt INT,
  IN p_rnk INT
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
END;


CREATE PROCEDURE sp_BabyName_Delete (
  IN p_id INT
)
BEGIN
  DELETE FROM BabyName
  WHERE id = p_id;
END;

