SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
-- -----------------------------------------------------
-- Schema chicago_crime
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Table `chicago_crime`.`fact_crime`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `chicago_crime`.`fact_crime` (
  `crime_key` INT NOT NULL,
  `date_key` BIGINT NOT NULL,
  `time_key` INT NOT NULL,
  `location_key` INT NOT NULL,
  `crime_type_key` INT NOT NULL,
  `case_number` VARCHAR(45) NOT NULL,
  `arrest` VARCHAR(10) NOT NULL,
  `domestic` VARCHAR(10) NOT NULL,
  `fbi_code` VARCHAR(10) NOT NULL,
  `updated_on` DATE NULL DEFAULT NULL,

  PRIMARY KEY (`crime_key`),
  CONSTRAINT `dim_date_fact_crime_fk`FOREIGN KEY (`date_key`)
    REFERENCES `chicago_crime`.`dim_date` (`date_key`)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_time_fact_crime_fk`FOREIGN KEY (`time_key`)
    REFERENCES `chicago_crime`.`dim_time` (`time_key`)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_location_fact_crime_fk`FOREIGN KEY (`location_key`)
    REFERENCES `chicago_crime`.`dim_location` (`location_key`)
	ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_crime_type_fact_crime_fk`FOREIGN KEY (`crime_type_key`)
    REFERENCES `chicago_crime`.`dim_crime_type` (`crime_type_key`)
	ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_date_fact_crime_fk` ON `chicago_crime`.`fact_crime` (`date_key` ASC);
CREATE INDEX `dim_time_fact_crime_fk` ON `chicago_crime`.`fact_crime` (`time_key` ASC);
CREATE INDEX `dim_location_fact_crime_fk` ON `chicago_crime`.`fact_crime` (`location_key` ASC);
CREATE INDEX `dim_crime_type_fact_crime_fk` ON `chicago_crime`.`fact_crime` (`crime_type_key` ASC);
-- -----------------------------------------------------
-- Now insert data into fact_crime table
-- -----------------------------------------------------
#DROP TABLE chicago_crime.fact_crime;

INSERT INTO chicago_crime.fact_crime
(crime_key, date_key, time_key, location_key, crime_type_key,
 case_number, 
 arrest, 
 domestic, 
 fbi_code, 
 updated_on)
SELECT
	c.crime_id AS crime_key, 
    d.date_key,
    t.time_key,
    l.location_key,
    ct.crime_type_key,
    c.case_number,
    c.arrest,
    c.domestic,
    c.fbi_code,
    c.updated_date
FROM chicago_crime.chicago_crime c
inner JOIN chicago_crime.dim_date d ON DATE_FORMAT(STR_TO_DATE(c.date,'%m/%d/%Y %h:%i:%s %p'), "%Y-%m-%d") = d.date
inner join chicago_crime.dim_time t ON DATE_FORMAT(STR_TO_DATE(c.date,'%m/%d/%Y %h:%i:%s %p'), "%h:%i:%s") = t.fulltime AND DATE_FORMAT(STR_TO_DATE(c.date,'%m/%d/%Y %h:%i:%s %p'), "%p") = t.ampm
inner JOIN chicago_crime.dim_location l on (c.location_description <=> l.location_description AND c.beat <=> l.beat 
AND c.block <=> l.block AND CAST(c.district AS CHAR) <=> l.district AND c.ward <=> l.ward
AND c.community_area <=> l.community_area AND c.x_coordinate <=> l.x_coordinate AND c.y_coordinate <=> l.y_coordinate AND c.longitude <=> l.longitude AND c.latitude <=> l.latitude)
inner JOIN chicago_crime.dim_crime_type ct on c.iucr = ct.iucr;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;