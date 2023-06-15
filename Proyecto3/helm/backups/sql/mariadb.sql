-- --------------------------------------------------------
-- Host:                         localhost
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


-- Dumping database structure for babynames
DROP DATABASE IF EXISTS `babynames`;
CREATE DATABASE IF NOT EXISTS `babynames` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `babynames`;

-- Dumping structure for table babynames.babyname
DROP TABLE IF EXISTS `babyname`;
CREATE TABLE IF NOT EXISTS `babyname` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `birthyear` int(11) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `ethnicity` varchar(50) DEFAULT NULL,
  `bbyName` VARCHAR(50) DEFAULT NULL,
  `cnt` int(11) DEFAULT NULL,
  `rnk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=LATIN1_SWEDISH_CI;

-- Data exporting was unselected.

-- Dumping structure for procedure babynames.sp_BabyName_Delete
DROP PROCEDURE IF EXISTS `sp_BabyName_Delete`;
DELIMITER //
CREATE PROCEDURE `sp_BabyName_Delete`(
   p_id INT
)
BEGIN
  DELETE FROM BabyName
  WHERE id = p_id;
END//
DELIMITER ;

-- Dumping structure for procedure babynames.sp_BabyName_Insert
DROP PROCEDURE IF EXISTS `sp_BabyName_Insert`;
DELIMITER //
CREATE PROCEDURE `sp_BabyName_Insert`(
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_bbyName VARCHAR(50),
   p_cnt INT,
   p_rnk INT
)
BEGIN
  INSERT INTO BabyName (birthyear, gender, ethnicity, bbyName, cnt, rnk)
  VALUES (p_birthyear, p_gender, p_ethnicity, p_bbyName, p_cnt, p_rnk);
END//
DELIMITER ;

-- Dumping structure for procedure babynames.sp_BabyName_Select
DROP PROCEDURE IF EXISTS `sp_BabyName_Select`;
DELIMITER //
CREATE PROCEDURE `sp_BabyName_Select`(
   p_id INT
)
BEGIN
  SELECT *
  FROM BabyName
  WHERE id = p_id;
END//
DELIMITER ;

-- Dumping structure for procedure babynames.sp_BabyName_Update
DROP PROCEDURE IF EXISTS `sp_BabyName_Update`;
DELIMITER //
CREATE PROCEDURE `sp_BabyName_Update`(
   p_id INT,
   p_birthyear INT,
   p_gender VARCHAR(10),
   p_ethnicity VARCHAR(50),
   p_bbyName VARCHAR(50),
   p_cnt INT,
   p_rnk INT
)
BEGIN
  UPDATE BabyName
  SET birthyear = p_birthyear,
      gender = p_gender,
      ethnicity = p_ethnicity,
      bbyName = p_bbyName,
      cnt = p_cnt,
      rnk = p_rnk
  WHERE id = p_id;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
