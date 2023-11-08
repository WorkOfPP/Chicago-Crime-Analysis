CREATE TABLE IF NOT EXISTS dim_time  (
    time_key INT NOT NULL auto_increment,
    fulltime time,
    hour int,
    minute int,
    second int,
    ampm varchar(2),
    PRIMARY KEY(time_key)
) ENGINE=InnoDB AUTO_INCREMENT=1000;


delimiter //

DROP PROCEDURE IF EXISTS timedimbuild;
CREATE PROCEDURE timedimbuild ()
BEGIN
    DECLARE v_full_date DATETIME;

    DELETE FROM dim_time;

    SET v_full_date = '2009-03-01 00:00:00';
    WHILE v_full_date < '2009-03-02 00:00:00' DO

        INSERT INTO dim_time (
            fulltime ,
            hour ,
            minute ,
            second ,
            ampm
        ) VALUES (
            TIME(v_full_date),
            HOUR(v_full_date),
            MINUTE(v_full_date),
            SECOND(v_full_date),
            DATE_FORMAT(v_full_date,'%p')
        );

        SET v_full_date = DATE_ADD(v_full_date, INTERVAL 1 SECOND);
    END WHILE;
END;

//
delimiter ;

-- call the stored procedure
call timedimbuild();