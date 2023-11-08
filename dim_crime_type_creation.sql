SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
-- -----------------------------------------------------
-- Schema chicago_crime
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Table `chicago_crime`.`dim_crime_type`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `chicago_crime`.`dim_crime_type` (
  `crime_type_key` INT NOT NULL AUTO_INCREMENT,
  `primary_type` VARCHAR(100) NOT NULL,
  `crime_description` VARCHAR(100) NOT NULL,
  `iucr` VARCHAR(34) NOT NULL,
  PRIMARY KEY (`crime_type_key`),
INDEX `primary_type` (`primary_type` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Now insert data into dim_crime_type table
-- -----------------------------------------------------

INSERT INTO `chicago_crime`.`dim_crime_type` (iucr,primary_type, crime_description)
(SELECT iucr, primary_type, description
FROM `chicago_crime`.`chicago_crime`
GROUP BY iucr, primary_type, description);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;