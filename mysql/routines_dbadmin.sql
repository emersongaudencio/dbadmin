-- MySQL dump 10.13  Distrib 5.7.33, for Linux (x86_64)
--
-- Host: localhost    Database: dbadmin
-- ------------------------------------------------------
-- Server version	5.7.33-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'dbadmin'
--
/*!50003 DROP PROCEDURE IF EXISTS `report_schema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `report_schema`(IN p_schema_name varchar(50))
BEGIN
Select
(select schema_name from information_schema.schemata where schema_name=p_schema_name) as "DATABASE_NAME",
(SELECT Round( Sum( data_length + index_length ) / 1024 / 1024, 2 )
FROM information_schema.tables
WHERE table_schema=p_schema_name
GROUP BY table_schema) as "SIZE_DB_MB",
(select count(*) from information_schema.tables where table_schema=p_schema_name and table_type='base table') as "TABLES_COUNT",
(select count(*) from information_schema.statistics where table_schema=p_schema_name) as "INDEXES_COUNT",
(select count(*) from information_schema.views where table_schema=p_schema_name) as "VIEWS_COUNT",
(select count(*) from information_schema.routines where routine_type ='FUNCTION' and routine_schema=p_schema_name) as "FUNCTIONS_COUNT",
(select COUNT(*) from information_schema.routines where routine_type ='PROCEDURE' and routine_schema=p_schema_name) as "PROCEDURES_COUNT",
(select count(*) from information_schema.triggers where trigger_schema=p_schema_name) as "TRIGGERS_COUNT",
(select count(*) from information_schema.events where event_schema=p_schema_name) as "EVENTS_COUNT",
(select default_collation_name from information_schema.schemata where schema_name=p_schema_name)"DEFAULT_COLLATION_DATABASE",
(select default_character_set_name from information_schema.schemata where schema_name=p_schema_name)"DEFAULT_CHARSET_DATABASE",
(select sum((select count(*) from information_schema.tables where table_schema=p_schema_name and table_type='base table')+(select count(*) from information_schema.statistics where table_schema=p_schema_name)+(select count(*) from information_schema.views where table_schema=p_schema_name)+(select count(*) from information_schema.routines where routine_type ='FUNCTION' and routine_schema=p_schema_name)+(select COUNT(*) from information_schema.routines where routine_type ='PROCEDURE' and routine_schema=p_schema_name)+(select count(*) from information_schema.triggers where trigger_schema=p_schema_name)+(select count(*) from information_schema.events where event_schema=p_schema_name))) as "TOTAL_OBJECTS_DATABASE";
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `report_schema_count_rows` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `report_schema_count_rows`(p_schema_name varchar(128))
BEGIN
DECLARE done INT DEFAULT 0;
DECLARE TNAME CHAR(255);
DECLARE table_names CURSOR for
    SELECT CONCAT("`", TABLE_SCHEMA, "`.`", table_name, "`") FROM INFORMATION_SCHEMA.TABLES where TABLE_TYPE = 'BASE TABLE' and TABLE_SCHEMA = p_schema_name;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
OPEN table_names;

DROP TABLE IF EXISTS TABLES_ROWS_COUNTS;
CREATE TABLE TABLES_ROWS_COUNTS
  (
    TABLE_NAME CHAR(255),
    RECORD_COUNT INT
  ) ENGINE = innodb;

WHILE done = 0 DO
  FETCH NEXT FROM table_names INTO TNAME;
   IF done = 0 THEN
    SET @SQL_TXT = CONCAT("INSERT INTO TABLES_ROWS_COUNTS(SELECT '" , REPLACE(TNAME,"`","")  , "' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT FROM ", TNAME, ")");

    PREPARE stmt_name FROM @SQL_TXT;
    EXECUTE stmt_name;
    DEALLOCATE PREPARE stmt_name;
  END IF;
END WHILE;
CLOSE table_names;

INSERT INTO TABLES_ROWS_COUNTS (SELECT 'TOTAL' AS TABLE_NAME, SUM(RECORD_COUNT) AS TOTAL_DATABASE_RECORD_CT FROM TABLES_ROWS_COUNTS);
SELECT TABLE_NAME, RECORD_COUNT FROM TABLES_ROWS_COUNTS order by TABLE_NAME;
DROP TABLE IF EXISTS TABLES_ROWS_COUNTS;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-15 15:26:53
