-- Drop the crms_admin user if it exists (requires DBA privileges)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER crms_admin CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF; -- ORA-01918: user does not exist
END;
/

-- Create the crms_admin user with a secure password
CREATE USER crms_admin IDENTIFIED BY "CrmsAdmin#123";

-- Grant basic privileges to crms_admin
GRANT CONNECT, RESOURCE TO crms_admin;
GRANT CREATE SESSION TO crms_admin WITH ADMIN OPTION;
GRANT CREATE TABLE TO crms_admin;

-- Set unlimited quota on the DATA tablespace for crms_admin
ALTER USER crms_admin QUOTA UNLIMITED ON DATA;

-- Grant additional privileges to allow creating various database objects
GRANT CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER TO crms_admin;

-- Grant privileges to manage other users
GRANT CREATE USER TO crms_admin;
GRANT DROP USER TO crms_admin;
