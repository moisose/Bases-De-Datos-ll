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


-- SQLINES DEMO *** structure for babynames
DROP DATABASE IF EXISTS babynames;
CREATE DATABASE babynames /* SQLINES DEMO *** RACTER SET latin1 COLLATE latin1_swedish_ci */;
SET SCHEMA 'babynames';

-- SQLINES DEMO ***  for table babynames.babyname
DROP TABLE IF EXISTS babyname;
-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE SEQUENCE babyname_seq;

CREATE TABLE IF NOT EXISTS babyname (
  id int NOT NULL DEFAULT NEXTVAL ('babyname_seq'),
  birthyear int DEFAULT NULL,
  gender varchar(10) DEFAULT NULL,
  ethnicity varchar(50) DEFAULT NULL,
  bbyName VARCHAR(50) DEFAULT NULL,
  cnt int DEFAULT NULL,
  rnk int DEFAULT NULL,
  PRIMARY KEY (id)
) ;

/* SQLINES DEMO *** E=IFNULL(@OLD_SQL_MODE, '') */;
/* SQLINES DEMO *** _KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/* SQLINES DEMO *** ER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/* SQLINES DEMO *** ES=IFNULL(@OLD_SQL_NOTES, 1) */;
