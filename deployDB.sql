SELECT "Deploying/Updating database for WhatsHappening" as "";

CREATE DATABASE IF NOT EXISTS WhatsHappening;

USE WhatsHappening;

SELECT "WhatsHappening DB Exists" as "";


DELIMITER $$

SELECT "generating table deployment procedure" as ""$$

DROP PROCEDURE IF EXISTS deployDB_WH$$
CREATE PROCEDURE deployDB_WH() BEGIN



#To allow for both creation and modification of columns we first attempt to ADD the column
#	this does nothing if a column exists
#	then we CHANGE the column attributes to the desired spec

#Continues past errors for trying to add an existing column or delete a non-existant index
DECLARE CONTINUE HANDLER FOR 1060, 1091 BEGIN END;

SELECT "Creating/updating tables" as "";

##### USERS ############################################################
CREATE TABLE IF NOT EXISTS users(uid INT NOT NULL PRIMARY KEY);
ALTER TABLE users ADD uid INT;
ALTER TABLE users ADD username VARCHAR(20);
ALTER TABLE users ADD password VARCHAR(20);
ALTER TABLE users ADD fullname VARCHAR(50);
ALTER TABLE users ADD email VARCHAR(255);

ALTER TABLE users CHANGE uid uid INT NOT NULL AUTO_INCREMENT;
ALTER TABLE users CHANGE username username VARCHAR(20) NOT NULL;
ALTER TABLE users CHANGE password password VARCHAR(20) NOT NULL;
ALTER TABLE users CHANGE fullname fullname VARCHAR(40) NOT NULL;
ALTER TABLE users CHANGE email email VARCHAR(255) NOT NULL;
ALTER TABLE users DROP INDEX constraint_unique_user;
ALTER TABLE users ADD CONSTRAINT constraint_unique_user UNIQUE(username);
ALTER TABLE users DROP PRIMARY KEY, ADD PRIMARY KEY (uid);

SELECT "    users table done" as "";

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
ALTER TABLE events ADD sin_lat FLOAT;	#helper fields for speeding up event querying
ALTER TABLE events ADD cos_cos FLOAT;
ALTER TABLE events ADD cos_sin FLOAT;

ALTER TABLE events CHANGE eid eid INT NOT NULL AUTO_INCREMENT;
ALTER TABLE events CHANGE uid uid INT NOT NULL;
ALTER TABLE events CHANGE name name VARCHAR(60) NOT NULL;
ALTER TABLE events CHANGE description description VARCHAR(255);
ALTER TABLE events CHANGE etime etime DATETIME NOT NULL;
ALTER TABLE events CHANGE lat lat FLOAT NOT NULL;
ALTER TABLE events CHANGE lon lon FLOAT NOT NULL;
ALTER TABLE events CHANGE address address VARCHAR(80);
ALTER TABLE events CHANGE sin_lat sin_lat FLOAT NOT NULL COMMENT 'sin(lat) in radians';
ALTER TABLE events CHANGE cos_cos cos_cos FLOAT NOT NULL COMMENT 'cos(lat)*cos(lon) in radians';
ALTER TABLE events CHANGE cos_sin cos_sin FLOAT NOT NULL COMMENT 'cos(lat)*sin(lon) in radians';
ALTER TABLE events DROP INDEX lat_lon_idx;                                                                                                                                                                                                                                                                                                                  
ALTER TABLE events ADD INDEX lat_lon_idx (lat, lon);
ALTER TABLE events DROP FOREIGN KEY fk_uid;
ALTER TABLE events ADD CONSTRAINT fk_uid FOREIGN KEY (uid) REFERENCES users(uid);
ALTER TABLE events DROP PRIMARY KEY, ADD PRIMARY KEY (eid);

SELECT "    events table done" as "";


END $$ ###procedure deployDB_WH()

SELECT "Generating geodistance function" AS ""$$

DROP FUNCTION IF EXISTS geodistance$$
CREATE FUNCTION geodistance(sin_lat1 FLOAT,
                              cos_cos1 FLOAT, cos_sin1 FLOAT,
                              sin_lat2 FLOAT,
                              cos_cos2 FLOAT, cos_sin2 FLOAT)
      RETURNS FLOAT
BEGIN  # returns distance between two coordinates as EARTH RADIANS
	RETURN acos(sin_lat1*sin_lat2 + cos_cos1*cos_cos2 + cos_sin1*cos_sin2);
END $$

SELECT "Generating event query stored procedure" as ""$$

DROP PROCEDURE IF EXISTS haversine_query$$
CREATE PROCEDURE haversine_query(IN centerLat FLOAT, IN centerLon FLOAT, 
								 IN earthRadius FLOAT, IN maxDistance FLOAT,
								 IN lowerLimit INT, IN upperLimit INT) 
BEGIN
	# Primer calculations for input center latitude and longitude
	#  used in geodistance formula
	DECLARE csin_lat FLOAT;
	DECLARE ccos_cos FLOAT;
	DECLARE ccos_sin FLOAT;
	
	#establishes inner and outer bounds for lat and lon to reduce the need for the
	#	geodistance calculation during the retrieval
	#   NOTE: This screws up the query by ommiting distances that cross
	#		180 longitude.  Sorry pacific islanders
	DECLARE maxRadDistance FLOAT;
	DECLARE lat_outer FLOAT;
	DECLARE lon_outer FLOAT;
	DECLARE lat_inner FLOAT;
	DECLARE lon_inner FLOAT;
	
	SET csin_lat = sin(radians(centerLat));
	SET ccos_cos = cos(radians(centerLat))*cos(radians(centerLon));
	SET ccos_sin = cos(radians(centerLat))*sin(radians(centerLon));
	
	SET maxRadDistance = maxDistance/earthRadius;
	SET lat_outer = degrees(1.06*maxRadDistance);
	SET lon_outer = degrees(1.06*maxRadDistance/cos(radians(centerLat)));
	SET lat_inner = degrees(maxRadDistance/sqrt(2));
	SET lon_inner = degrees(maxRadDistance/cos(radians(centerLat))/sqrt(2));
	
	SELECT  events.eid, 
			events.name,
			events.description,
			events.etime,
			events.lat,
			events.lon,
			events.address,
			users.uid,
			users.username,
			users.fullname,
			users.email,
			earthRadius*geodistance(events.sin_lat, events.cos_cos, events.cos_sin,
									csin_lat, ccos_cos, ccos_sin) AS distance
	FROM events LEFT JOIN users ON events.uid=users.uid
	WHERE 	lat BETWEEN centerLat-lat_outer AND centerLat+lat_outer
		AND	lon BETWEEN centerLon-lon_outer AND centerLon+lon_outer
	HAVING (	lat BETWEEN centerLat-lat_inner AND centerLat+lat_inner
			AND lon BETWEEN centerLon-lon_inner AND centerLon+lon_inner)
		OR distance<=maxDistance
	ORDER BY distance 
	LIMIT lowerLimit , upperLimit;
END $$

SELECT "Generating event insertion procedure" as ""$$
DROP PROCEDURE IF EXISTS event_insert$$
CREATE PROCEDURE event_insert(  IN newuid INT, IN newname VARCHAR(40), IN newdescription VARCHAR(255),
								IN newetime DATetime, IN newlat FLOAT, IN newlon FLOAT, IN newaddress VARCHAR(255))
BEGIN
	# Do primer calculations for input latitude and longitude
	DECLARE newsin_lat FLOAT;
	DECLARE newcos_cos FLOAT;
	DECLARE newcos_sin FLOAT;
	SET newsin_lat = sin(radians(newlat));
	SET newcos_cos = cos(radians(newlat))*cos(radians(newlon));
	SET newcos_sin = cos(radians(newlat))*sin(radians(newlon));
	INSERT INTO events(uid, name, description, etime, lat, lon, address, sin_lat, cos_cos, cos_sin)
		VALUES (newuid, newname, newdescription, newetime, newlat, newlon, newaddress, newsin_lat, newcos_cos, newcos_sin);
END $$

DELIMITER ;

CALL deployDB_WH();

SELECT "Script complete" as "";
