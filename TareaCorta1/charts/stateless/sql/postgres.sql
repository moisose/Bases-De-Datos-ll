-- SQLINES DEMO *** ---------------------------------------
-- SQLINES DEMO ***              localhost
-- SQLINES DEMO ***              10.11.2-MariaDB - mariadb.org binary distribution
-- SQLINES DEMO ***              Win64
-- SQLINES DEMO ***              11.3.0.6295
-- SQLINES DEMO *** ---------------------------------------

/* SQLINES DEMO *** ARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/* SQLINES DEMO *** tf8 */;
/* SQLINES DEMO *** tf8mb4 */;
/* SQLINES DEMO *** REIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/* SQLINES DEMO *** L_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/* SQLINES DEMO *** L_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


SET TRANSACTION READ WRITE;

CREATE TABLE IF NOT EXISTS babyname (
  id serial,
  birthyear int DEFAULT NULL,
  gender varchar(10) DEFAULT NULL,
  ethnicity varchar(50) DEFAULT NULL,
  bbyName VARCHAR(50) DEFAULT NULL,
  cnt int DEFAULT NULL,
  rnk int DEFAULT NULL,
  PRIMARY KEY (id)
) ;

create or replace procedure sp_BabyName_Delete(
   p_id INT
)
language plpgsql    
as $$
begin
  DELETE FROM BabyName
  WHERE id = p_id;
end;$$;

create or replace procedure sp_BabyName_Insert(
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_bbyName VARCHAR(50),
   p_cnt INT,
   p_rnk INT
)
language plpgsql    
as $$
begin
  INSERT INTO BabyName (birthyear, gender, ethnicity, bbyName, cnt, rnk)
  VALUES (p_birthyear, p_gender, p_ethnicity, p_bbyName, p_cnt, p_rnk);
end;$$;

create or replace procedure sp_BabyName_Select(
   p_id INT
)
language plpgsql    
as $$
declare
  result_record BabyName%rowtype;
begin
  SELECT *
  INTO result_record
  FROM BabyName
  WHERE id = p_id;
  
  -- Print the result
  RAISE NOTICE 'Result: %, %', result_record.name, result_record.gender;
end;$$;

create or replace procedure sp_BabyName_Update(
   p_id INT,
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_bbyName VARCHAR(50),
   p_cnt INT,
   p_rnk INT
)
language plpgsql    
as $$
begin
  UPDATE BabyName
  SET birthyear = p_birthyear,
      gender = p_gender,
      ethnicity = p_ethnicity,
      bbyName = p_bbyName,
      cnt = p_cnt,
      rnk = p_rnk
  WHERE id = p_id;
end;$$;
