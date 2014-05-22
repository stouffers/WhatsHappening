developed with mysql5.6 and tomcat7

Database is initialized with the /deployDB.sql script

there needs to be '/src/db.properties' initialized as such:
MYSQL_DB_DRIVER_CLASS=com.mysql.jdbc.Driver
MYSQL_DB_NAME=WhatsHappening
MYSQL_DB_URL=jdbc:mysql://localhost/
MYSQL_DB_USERNAME=
MYSQL_DB_PASSWORD=

--- more to come
