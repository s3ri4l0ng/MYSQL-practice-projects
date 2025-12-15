-- User roles&permissions

CREATE ROLE analyst_role;
CREATE ROLE etl_role;
CREATE ROLE dba_role;

GRANT ALL PRIVILEGES
ON drugservice.*
TO dba_role;

-- etl permissions
GRANT SELECT, INSERT, UPDATE
ON drugservice.drugs
TO etl_role;

GRANT SELECT, INSERT, UPDATE
ON drugservice.facilities
TO etl_role; -- This means they can load and clean data, they cannot drop tables, they cannot manage users

-- analyst role
GRANT SELECT
ON drugservice.drugs
TO analyst_role;

GRANT SELECT
ON drugservice.facilities
TO analyst_role; -- safe for reporting and no data modification

-- creating users
CREATE USER 'db_admin'@'%''localhost'
IDENTIFIED BY 'StrongDBAPassword!';

CREATE USER 'etl_user'@'localhost'
IDENTIFIED BY 'StrongETLPassword!';

CREATE USER 'analyst_user'@'localhost'
IDENTIFIED BY 'StrongAnalystPassword!';




