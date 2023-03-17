-- Creacion de tabla
DROP TABLE IF EXISTS babyname;
CREATE TABLE IF NOT EXISTS babyname (
  id SERIAL PRIMARY KEY,
  birthyear INTEGER,
  gender VARCHAR(10),
  ethnicity VARCHAR(50),
  bbyName VARCHAR(50),
  cnt INTEGER,
  rnk INTEGER
);

-- Borrar información
DROP PROCEDURE IF EXISTS sp_BabyName_Delete;
CREATE OR REPLACE PROCEDURE sp_BabyName_Delete(
   p_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM BabyName
  WHERE id = p_id;
END;
$$;

-- Insertar elemento
DROP PROCEDURE IF EXISTS sp_BabyName_Insert;
CREATE OR REPLACE PROCEDURE sp_BabyName_Insert(
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_bbyName VARCHAR(50),
   p_cnt INT,
   p_rnk INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO BabyName (birthyear, gender, ethnicity, bbyName, cnt, rnk)
  VALUES (p_birthyear, p_gender, p_ethnicity, p_bbyName, p_cnt, p_rnk);
END;
$$;

-- Seleccion de elemento
DROP PROCEDURE IF EXISTS sp_BabyName_Select;
CREATE OR REPLACE PROCEDURE sp_BabyName_Select(
   p_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  SELECT *
  FROM BabyName
  WHERE id = p_id;
END;
$$;

-- Actualizacion datos
DROP PROCEDURE IF EXISTS sp_BabyName_Update;
CREATE OR REPLACE PROCEDURE sp_BabyName_Update(
   p_id INT,
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_bbyName VARCHAR(50),
   p_cnt INT,
   p_rnk INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE BabyName
  SET birthyear = p_birthyear,
      gender = p_gender,
      ethnicity = p_ethnicity,
      bbyName = p_bbyName,
      cnt = p_cnt,
      rnk = p_rnk
  WHERE id = p_id;
END;
$$;