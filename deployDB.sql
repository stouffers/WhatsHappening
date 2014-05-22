
CREATE DATABASE IF NOT EXISTS WhatsHappening;

USE WhatsHappening;

SELECT "WhatsHappening DB Exists" as "";

DROP PROCEDURE IF EXISTS deployDB_WH;
DROP PROCEDURE IF EXISTS haversine_query;

DELIMITER <(-_-v)

CREATE PROCEDURE deployDB_WH() BEGIN


#To allow for both creation and modification of columns we first attempt to ADD the column
#	this does nothing if a column exists
#	then we CHANGE the column attributes to the desired spec

#Continues past errors for trying to add an existing column or delete a non-existant index
DECLARE CONTINUE HANDLER FOR 1060, 1091 BEGIN END;


##### USERS ############################################################
CREATE TABLE IF NOT EXISTS users(uid INT NOT NULL PRIMARY KEY);
ALTER TABLE users ADD uid INT;
ALTER TABLE users ADD username VARCHAR(20);
ALTER TABLE users ADD password VARCHAR(20);
ALTER TABLE users ADD fullname VARCHAR(50);
ALTER TABLE users ADD email VARCHAR(255);

ALTER TABLE users 
CHANGE uid uid INT NOT NULL AUTO_INCREMENT,
CHANGE username username VARCHAR(20) NOT NULL,
CHANGE password password VARCHAR(20) NOT NULL,
CHANGE fullname fullname VARCHAR(40) NOT NULL,
CHANGE email email VARCHAR(255) NOT NULL,
DROP INDEX constraint_unique_user, 
ADD CONSTRAINT constraint_unique_user UNIQUE(username),
DROP PRIMARY KEY,
ADD PRIMARY KEY (uid);

SELECT "users table done" as "";

##### EVENTS ###########################################################
CREATE TABLE IF NOT EXISTS events(eid INT NOT NULL PRIMARY KEY);
ALTER TABLE events ADD eid INT;
ALTER TABLE events ADD uid INT;
ALTER TABLE events ADD name VARCHAR(50);
ALTER TABLE events ADD description VARCHAR(255);
ALTER TABLE events ADD etime DATETIME;
ALTER TABLE events ADD lat FLOAT;
ALTER TABLE events ADD lon FLOAT;
ALTER TABLE events ADD address VARCHAR(80);

ALTER TABLE events DROP FOREIGN KEY fk_uid;

ALTER TABLE events 
CHANGE eid eid INT NOT NULL AUTO_INCREMENT, 
CHANGE uid uid INT NOT NULL, 
CHANGE name name VARCHAR(60) NOT NULL, 
CHANGE description description VARCHAR(255),
CHANGE etime etime DATETIME NOT NULL, 
CHANGE lat lat FLOAT(10,6) NOT NULL, 
CHANGE lon lon FLOAT(10,6) NOT NULL, 
CHANGE address address VARCHAR(80),
ADD CONSTRAINT fk_uid FOREIGN KEY (uid) REFERENCES users(uid),
DROP PRIMARY KEY,
ADD PRIMARY KEY (eid);


SELECT "events table done" as "";



#END; ###handler for 1060

END <(-_-v) ###procedure deployDB_WH()

CALL deployDB_WH() <(-_-v)

SELECT "Generating event query stored procedure" as ""<(-_-v)

CREATE PROCEDURE haversine_query(IN centerLat FLOAT, IN centerLon FLOAT, IN radius FLOAT, 
								 IN lowerLimit INT, IN upperLimit INT,
								 OUT eid INT, OUT distance FLOAT) 
BEGIN
	SELECT eid, ( radius * ACOS( COS( RADIANS(centerLat) ) * COS( RADIANS( lat ) ) 
								 * COS( RADIANS( lng ) - RADIANS(centerLon) )
								 + SIN( RADIANS(centerLat) ) * SIN(RADIANS(lat)) ) ) 
								 AS distance 
	FROM events
	HAVING distance < 25 
	ORDER BY distance 
	LIMIT lowerLimit , upperLimit;
END <(-_-v)

SELECT "Script complete" as ""<(-_-v)

DELIMITER ;