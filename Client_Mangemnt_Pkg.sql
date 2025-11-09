
----- CLIENT MANAGEMENT PACKAGE --------


CREATE OR REPLACE PACKAGE Client_Management_Pkg AS
    -- Role Procedures
    PROCEDURE Insert_Role(p_RoleName IN VARCHAR2, p_Permissions IN VARCHAR2);
    PROCEDURE Update_Role(p_RoleID IN NUMBER, p_RoleName IN VARCHAR2, p_Permissions IN VARCHAR2);
    PROCEDURE Delete_Role(p_RoleID IN NUMBER);

    -- Region Procedures
    PROCEDURE Insert_Region(p_RegionName IN VARCHAR2);
    PROCEDURE Update_Region(p_RegionID IN NUMBER, p_RegionName IN VARCHAR2);
    PROCEDURE Delete_Region(p_RegionID IN NUMBER);

    -- State-Region Mapping Procedures
    PROCEDURE Insert_State_Region(p_StateCode IN VARCHAR2, p_RegionID IN NUMBER);
    PROCEDURE Update_State_Region(p_StateCode IN VARCHAR2, p_RegionID IN NUMBER);
    PROCEDURE Delete_State_Region(p_StateCode IN VARCHAR2);

    -- User Procedures
    PROCEDURE Insert_User(p_UserName IN VARCHAR2, p_Password IN VARCHAR2, p_RoleID IN NUMBER);
    PROCEDURE Update_User(p_UserID IN NUMBER, p_UserName IN VARCHAR2, p_Password IN VARCHAR2, p_RoleID IN NUMBER);
    PROCEDURE Delete_User(p_UserID IN NUMBER);

    -- Client Procedures
    PROCEDURE Insert_Client(
        p_FirstName IN VARCHAR2, p_LastName IN VARCHAR2, p_Email IN VARCHAR2,
        p_PhoneNumber IN VARCHAR2, p_CompanyName IN VARCHAR2, p_Street IN VARCHAR2,
        p_State IN VARCHAR2, p_City IN VARCHAR2, p_ZipCode IN VARCHAR2, p_UserID IN NUMBER
    );
    PROCEDURE Update_Client(
        p_ClientID IN NUMBER, p_FirstName IN VARCHAR2 DEFAULT NULL, p_LastName IN VARCHAR2 DEFAULT NULL,
        p_Email IN VARCHAR2 DEFAULT NULL, p_PhoneNumber IN VARCHAR2 DEFAULT NULL,
        p_CompanyName IN VARCHAR2 DEFAULT NULL, p_Street IN VARCHAR2 DEFAULT NULL,
        p_State IN VARCHAR2 DEFAULT NULL, p_City IN VARCHAR2 DEFAULT NULL, p_ZipCode IN VARCHAR2 DEFAULT NULL
    );
    PROCEDURE Delete_Client(p_ClientID IN NUMBER);
END Client_Management_Pkg;
/

CREATE OR REPLACE PACKAGE BODY Client_Management_Pkg AS
    -- Implementations for all declared procedures
        ------------------------------ ROLE Table Procedures ---------------------------------
    PROCEDURE Insert_Role(
        p_RoleName IN VARCHAR2,
        p_Permissions IN VARCHAR2
    ) AS
    BEGIN
        IF p_RoleName IS NULL OR p_Permissions IS NULL THEN
            RAISE_APPLICATION_ERROR(-20010, 'Role name and permissions cannot be NULL.');
        END IF;
    
        INSERT INTO ROLE (ROLENAME, PERMISSIONS) VALUES (p_RoleName, p_Permissions);
        DBMS_OUTPUT.PUT_LINE('Role inserted: ' || p_RoleName || ' with Permissions: ' || p_Permissions);
        COMMIT;
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20011, 'Duplicate RoleName detected: ' || p_RoleName);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20012, 'Unexpected error: ' || SQLERRM);
    END;
    
    PROCEDURE Update_Role(
        p_RoleID IN NUMBER,
        p_RoleName IN VARCHAR2,
        p_Permissions IN VARCHAR2
    ) AS
    BEGIN
        IF p_RoleID IS NULL THEN
            RAISE_APPLICATION_ERROR(-20013, 'RoleID cannot be NULL.');
        END IF;
    
        UPDATE ROLE SET ROLENAME = p_RoleName, PERMISSIONS = p_Permissions WHERE ROLEID = p_RoleID;
        
        -- Check if any rows were updated
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20016, 'No rows updated. RoleID does not exist: ' || p_RoleID);
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Role updated: ID=' || p_RoleID || ', Name=' || p_RoleName);
        COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20014, 'Unexpected error: ' || SQLERRM);
    END;
    
    
    PROCEDURE Delete_Role(
        p_RoleID IN NUMBER
    ) AS
        l_exists NUMBER;
    BEGIN
        -- Check if the RoleID exists
        SELECT COUNT(*) INTO l_exists FROM ROLE WHERE ROLEID = p_RoleID;
        IF l_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20015, 'RoleID does not exist: ' || p_RoleID);
        END IF;
    
        -- Delete the role
        DELETE FROM ROLE WHERE ROLEID = p_RoleID;
        DBMS_OUTPUT.PUT_LINE('Role deleted: ID=' || p_RoleID);
        COMMIT;
    END;
    
    
    -------------------------------- REGION Table Procedures -----------------------------
    
    PROCEDURE Insert_Region(
        p_RegionName IN VARCHAR2
    ) AS
    BEGIN
        IF p_RegionName IS NULL THEN
            RAISE_APPLICATION_ERROR(-20020, 'Region name cannot be NULL.');
        END IF;
    
        INSERT INTO REGION (REGION_NAME) VALUES (p_RegionName);
        DBMS_OUTPUT.PUT_LINE('Region inserted: ' || p_RegionName);
        COMMIT;
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20021, 'Duplicate RegionName detected: ' || p_RegionName);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20022, 'Unexpected error: ' || SQLERRM);
    END;
    
    
    PROCEDURE Update_Region(
        p_RegionID IN NUMBER,
        p_RegionName IN VARCHAR2
    ) AS
    BEGIN
        IF p_RegionID IS NULL OR p_RegionName IS NULL THEN
            RAISE_APPLICATION_ERROR(-20023, 'RegionID and Region name cannot be NULL.');
        END IF;
    
        UPDATE REGION SET REGION_NAME = p_RegionName WHERE REGION_ID = p_RegionID;
        
        -- Check if any rows were updated
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20016, 'No rows updated. Region_ID does not exist: ' || p_RegionID);
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Region updated: ID=' || p_RegionID || ', Name=' || p_RegionName);
        COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20024, 'Unexpected error: ' || SQLERRM);
    END;
    
    
    PROCEDURE Delete_Region(
        p_RegionID IN NUMBER
    ) AS
        l_exists NUMBER;
    BEGIN
        -- Check if the RegionID exists
        SELECT COUNT(*) INTO l_exists FROM REGION WHERE REGION_ID = p_RegionID;
        IF l_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20025, 'RegionID does not exist: ' || p_RegionID);
        END IF;
    
        -- Delete the region
        DELETE FROM REGION WHERE REGION_ID = p_RegionID;
        DBMS_OUTPUT.PUT_LINE('Region deleted: ID=' || p_RegionID);
        COMMIT;
    END;
    
    
    -------------------- STATE_REGION_MAPPING Table Procedures ---------------------
    
    PROCEDURE Insert_State_Region(
        p_StateCode IN VARCHAR2,
        p_RegionID IN NUMBER
    ) AS
        l_count NUMBER;
    BEGIN
        -- Validate RegionID existence
        SELECT COUNT(*) INTO l_count FROM REGION WHERE REGION_ID = p_RegionID;
        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20030, 'RegionID does not exist.');
        END IF;
    
        -- Insert mapping
        INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES (p_StateCode, p_RegionID);
        DBMS_OUTPUT.PUT_LINE('State-Region mapping inserted: StateCode=' || p_StateCode || ', RegionID=' || p_RegionID);
        COMMIT;
    END;
    
    
    PROCEDURE Update_State_Region(
        p_StateCode IN VARCHAR2,
        p_RegionID IN NUMBER
    ) AS
        l_count NUMBER;
    BEGIN
        -- Validate RegionID existence
        SELECT COUNT(*) INTO l_count FROM REGION WHERE REGION_ID = p_RegionID;
        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20031, 'RegionID does not exist.');
        END IF;
    
        -- Update mapping
        UPDATE STATE_REGION_MAPPING SET REGION_ID = p_RegionID WHERE STATE_CODE = p_StateCode;
        DBMS_OUTPUT.PUT_LINE('State-Region mapping updated: StateCode=' || p_StateCode || ', RegionID=' || p_RegionID);
        COMMIT;
    END;
    
    
    PROCEDURE Delete_State_Region(
        p_StateCode IN VARCHAR2
    ) AS
        l_count NUMBER;
    BEGIN
        -- Validate StateCode existence
        SELECT COUNT(*) INTO l_count FROM STATE_REGION_MAPPING WHERE STATE_CODE = p_StateCode;
        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20032, 'StateCode does not exist.');
        END IF;
    
        -- Delete mapping
        DELETE FROM STATE_REGION_MAPPING WHERE STATE_CODE = p_StateCode;
        DBMS_OUTPUT.PUT_LINE('State-Region mapping deleted: StateCode=' || p_StateCode);
        COMMIT;
    END;
    
    
    
    -------------------------- USERTABLE Table Procedures --------------------------------
    
    PROCEDURE Insert_User(
        p_UserName IN VARCHAR2,
        p_Password IN VARCHAR2,
        p_RoleID IN NUMBER
    ) AS
        l_count NUMBER;
    BEGIN
        -- Validate RoleID existence
        SELECT COUNT(*) INTO l_count FROM ROLE WHERE ROLEID = p_RoleID;
        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20040, 'RoleID does not exist.');
        END IF;
    
        -- Insert user
        INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES (p_UserName, p_Password, p_RoleID);
        DBMS_OUTPUT.PUT_LINE('User inserted: ' || p_UserName);
        COMMIT;
    END;
    
    
    PROCEDURE Update_User(
        p_UserID IN NUMBER,
        p_UserName IN VARCHAR2,
        p_Password IN VARCHAR2,
        p_RoleID IN NUMBER
    ) AS
        l_count NUMBER;
    BEGIN
        -- Validate UserID existence
        SELECT COUNT(*) INTO l_count FROM USERTABLE WHERE USERID = p_UserID;
        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20043, 'UserID does not exist.');
        END IF;
    
        -- Update user
        UPDATE USERTABLE SET USERNAME = p_UserName, PASSWORD = p_Password, ROLEID = p_RoleID WHERE USERID = p_UserID;
        DBMS_OUTPUT.PUT_LINE('User updated: ID=' || p_UserID);
        COMMIT;
    END;
    
    
    PROCEDURE Delete_User(
        p_UserID IN NUMBER
    ) AS
        l_count NUMBER;
    BEGIN
        -- Validate UserID existence
        SELECT COUNT(*) INTO l_count FROM USERTABLE WHERE USERID = p_UserID;
        IF l_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20045, 'UserID does not exist.');
        END IF;
    
        -- Delete user
        DELETE FROM USERTABLE WHERE USERID = p_UserID;
        DBMS_OUTPUT.PUT_LINE('User deleted: ID=' || p_UserID);
        COMMIT;
    END;
    
    
    ------------------ CLIENT Table Procedures ----------------------------------
    
    PROCEDURE Insert_Client(
        p_FirstName IN VARCHAR2,
        p_LastName IN VARCHAR2,
        p_Email IN VARCHAR2,
        p_PhoneNumber IN VARCHAR2,
        p_CompanyName IN VARCHAR2,
        p_Street IN VARCHAR2,
        p_State IN VARCHAR2,
        p_City IN VARCHAR2,
        p_ZipCode IN VARCHAR2,
        p_UserID IN NUMBER
    ) AS
        l_user_exists NUMBER;
        l_state_exists NUMBER;
        v_EmailValidation VARCHAR2(50);
    BEGIN
        -- Validate UserID existence
        SELECT COUNT(*) INTO l_user_exists FROM USERTABLE WHERE USERID = p_UserID;
        IF l_user_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20050, 'UserID does not exist.');
        END IF;
    
        -- Validate State existence
        SELECT COUNT(*) INTO l_state_exists FROM STATE_REGION_MAPPING WHERE STATE_CODE = p_State;
        IF l_state_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20051, 'State code does not exist.');
        END IF;
    
        -- Insert Client
        INSERT INTO CLIENT (FIRSTNAME, LASTNAME, EMAIL, PHONENUMBER, COMPANYNAME, STREET, STATE, CITY, ZIPCODE, USERID)
        VALUES (p_FirstName, p_LastName, p_Email, p_PhoneNumber, p_CompanyName, p_Street, p_State, p_City, p_ZipCode, p_UserID);
        DBMS_OUTPUT.PUT_LINE('Client inserted: ' || p_FirstName || ' ' || p_LastName);
        
        -- Validate client email
        v_EmailValidation := Validate_Client_Email(p_Email);

        IF v_EmailValidation = 'Email exists.' THEN
        RAISE_APPLICATION_ERROR(-20100, 'Email already exists: ' || p_Email);
        END IF;

        COMMIT;
    END;
    
    
    PROCEDURE Update_Client(
        p_ClientID IN NUMBER,
        p_FirstName IN VARCHAR2 DEFAULT NULL,
        p_LastName IN VARCHAR2 DEFAULT NULL,
        p_Email IN VARCHAR2 DEFAULT NULL,
        p_PhoneNumber IN VARCHAR2 DEFAULT NULL,
        p_CompanyName IN VARCHAR2 DEFAULT NULL,
        p_Street IN VARCHAR2 DEFAULT NULL,
        p_State IN VARCHAR2 DEFAULT NULL,
        p_City IN VARCHAR2 DEFAULT NULL,
        p_ZipCode IN VARCHAR2 DEFAULT NULL
    ) AS
        l_client_exists NUMBER;
    BEGIN
        -- Validate ClientID existence
        SELECT COUNT(*) INTO l_client_exists FROM CLIENT WHERE CLIENTID = p_ClientID;
        IF l_client_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20054, 'ClientID does not exist.');
        END IF;
    
        -- Update Client details
        UPDATE CLIENT
        SET FIRSTNAME = NVL(p_FirstName, FIRSTNAME),
            LASTNAME = NVL(p_LastName, LASTNAME),
            EMAIL = NVL(p_Email, EMAIL),
            PHONENUMBER = NVL(p_PhoneNumber, PHONENUMBER),
            COMPANYNAME = NVL(p_CompanyName, COMPANYNAME),
            STREET = NVL(p_Street, STREET),
            STATE = NVL(p_State, STATE),
            CITY = NVL(p_City, CITY),
            ZIPCODE = NVL(p_ZipCode, ZIPCODE)
        WHERE CLIENTID = p_ClientID;
    
        DBMS_OUTPUT.PUT_LINE('Client updated: ID=' || p_ClientID);
        COMMIT;
    END;
    
    
    PROCEDURE DELETE_CLIENT(
        p_ClientID IN NUMBER
    ) AS
        l_exists NUMBER;
    BEGIN
        -- Validate if Client exists
        SELECT COUNT(*) INTO l_exists
        FROM CLIENT
        WHERE CLIENTID = p_ClientID;
    
        IF l_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Client ID does not exist.');
        END IF;
    
        -- Delete the client
        DELETE FROM CLIENT
        WHERE CLIENTID = p_ClientID;
    
        DBMS_OUTPUT.PUT_LINE('Client deleted successfully: ' || p_ClientID);
    
        COMMIT;
    END;
    
END Client_Management_Pkg;
/



