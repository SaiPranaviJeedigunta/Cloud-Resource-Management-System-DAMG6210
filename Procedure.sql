------------------------------ ROLE Table Procedures ---------------------------------

CREATE OR REPLACE PROCEDURE Insert_Role(
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
/

CREATE OR REPLACE PROCEDURE Update_Role(
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
/

CREATE OR REPLACE PROCEDURE Delete_Role(
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
/

-------------------------------- REGION Table Procedures -----------------------------

CREATE OR REPLACE PROCEDURE Insert_Region(
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
/

CREATE OR REPLACE PROCEDURE Update_Region(
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
/

CREATE OR REPLACE PROCEDURE Delete_Region(
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
/

-------------------- STATE_REGION_MAPPING Table Procedures ---------------------

CREATE OR REPLACE PROCEDURE Insert_State_Region(
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
/

CREATE OR REPLACE PROCEDURE Update_State_Region(
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
/

CREATE OR REPLACE PROCEDURE Delete_State_Region(
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
/


-------------------------- USERTABLE Table Procedures --------------------------------

CREATE OR REPLACE PROCEDURE Insert_User(
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
/

CREATE OR REPLACE PROCEDURE Update_User(
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
/

CREATE OR REPLACE PROCEDURE Delete_User(
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
/

------------------ CLIENT Table Procedures ----------------------------------

CREATE OR REPLACE PROCEDURE Insert_Client(
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
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_Client(
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
/

CREATE OR REPLACE PROCEDURE DELETE_CLIENT(
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
/


------------------- PRICINGPLAN Table Procedures ---------------------------

CREATE OR REPLACE PROCEDURE Insert_PricingPlan(
    p_PlanName IN VARCHAR2,
    p_Description IN VARCHAR2
) AS
BEGIN
    INSERT INTO PRICINGPLAN (PLANNAME, DESCRIPTION) VALUES (p_PlanName, p_Description);
    DBMS_OUTPUT.PUT_LINE('Pricing plan inserted: ' || p_PlanName);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_PricingPlan(
    p_PlanID IN NUMBER,
    p_PlanName IN VARCHAR2,
    p_Description IN VARCHAR2
) AS
BEGIN

    
    UPDATE PRICINGPLAN SET PLANNAME = p_PlanName, DESCRIPTION = p_Description WHERE PLANID = p_PlanID;
    DBMS_OUTPUT.PUT_LINE('Pricing plan updated: ID=' || p_PlanID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Delete_PricingPlan(
    p_PlanID IN NUMBER
) AS
BEGIN

    DELETE FROM PRICINGPLAN WHERE PLANID = p_PlanID;
    DBMS_OUTPUT.PUT_LINE('Pricing plan deleted: ID=' || p_PlanID);
    COMMIT;
END;
/

--------------- PRICING DETAIL PROCEDURE -------------------

CREATE OR REPLACE PROCEDURE Insert_PricingDetail(
    p_PlanID IN NUMBER,
    p_ResourceTypeID IN NUMBER,
    p_UnitPrice IN FLOAT
) AS
    l_plan_exists NUMBER;
    l_resource_type_exists NUMBER;
BEGIN
    -- Validate PlanID existence
    SELECT COUNT(*) INTO l_plan_exists FROM PRICINGPLAN WHERE PLANID = p_PlanID;
    IF l_plan_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20220, 'PlanID does not exist: ' || p_PlanID);
    END IF;

    -- Validate ResourceTypeID existence
    SELECT COUNT(*) INTO l_resource_type_exists FROM RESOURCETYPE WHERE RESOURCETYPEID = p_ResourceTypeID;
    IF l_resource_type_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20221, 'ResourceTypeID does not exist: ' || p_ResourceTypeID);
    END IF;

    -- Validate UnitPrice
    IF p_UnitPrice IS NULL OR p_UnitPrice <= 0 THEN
        RAISE_APPLICATION_ERROR(-20222, 'UnitPrice must be a positive number.');
    END IF;

    -- Insert into PRICINGDETAIL
    INSERT INTO PRICINGDETAIL (PLANID, RESOURCETYPEID, UNITPRICE)
    VALUES (p_PlanID, p_ResourceTypeID, p_UnitPrice);

    DBMS_OUTPUT.PUT_LINE('Pricing detail inserted: PlanID=' || p_PlanID || ', ResourceTypeID=' || p_ResourceTypeID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_PricingDetail(
    p_DetailID IN NUMBER,
    p_PlanID IN NUMBER DEFAULT NULL,
    p_ResourceTypeID IN NUMBER DEFAULT NULL,
    p_UnitPrice IN FLOAT DEFAULT NULL
) AS
    l_detail_exists NUMBER;
    l_plan_exists NUMBER;
    l_resource_type_exists NUMBER;
BEGIN
    -- Validate DetailID existence
    SELECT COUNT(*) INTO l_detail_exists FROM PRICINGDETAIL WHERE DETAILID = p_DetailID;
    IF l_detail_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20223, 'DetailID does not exist: ' || p_DetailID);
    END IF;

    -- Validate PlanID existence if provided
    IF p_PlanID IS NOT NULL THEN
        SELECT COUNT(*) INTO l_plan_exists FROM PRICINGPLAN WHERE PLANID = p_PlanID;
        IF l_plan_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20224, 'PlanID does not exist: ' || p_PlanID);
        END IF;
    END IF;

    -- Validate ResourceTypeID existence if provided
    IF p_ResourceTypeID IS NOT NULL THEN
        SELECT COUNT(*) INTO l_resource_type_exists FROM RESOURCETYPE WHERE RESOURCETYPEID = p_ResourceTypeID;
        IF l_resource_type_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20225, 'ResourceTypeID does not exist: ' || p_ResourceTypeID);
        END IF;
    END IF;

    -- Validate UnitPrice if provided
    IF p_UnitPrice IS NOT NULL AND p_UnitPrice <= 0 THEN
        RAISE_APPLICATION_ERROR(-20226, 'UnitPrice must be a positive number.');
    END IF;

    -- Update PRICINGDETAIL
    UPDATE PRICINGDETAIL
    SET PLANID = NVL(p_PlanID, PLANID),
        RESOURCETYPEID = NVL(p_ResourceTypeID, RESOURCETYPEID),
        UNITPRICE = NVL(p_UnitPrice, UNITPRICE)
    WHERE DETAILID = p_DetailID;

    DBMS_OUTPUT.PUT_LINE('Pricing detail updated: DetailID=' || p_DetailID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Delete_PricingDetail(
    p_DetailID IN NUMBER
) AS
    l_detail_exists NUMBER;
BEGIN
    -- Validate DetailID existence
    SELECT COUNT(*) INTO l_detail_exists FROM PRICINGDETAIL WHERE DETAILID = p_DetailID;
    IF l_detail_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20227, 'DetailID does not exist: ' || p_DetailID);
    END IF;

    -- Delete from PRICINGDETAIL
    DELETE FROM PRICINGDETAIL WHERE DETAILID = p_DetailID;

    DBMS_OUTPUT.PUT_LINE('Pricing detail deleted: DetailID=' || p_DetailID);
    COMMIT;
END;
/

------------------- RESOURCETYPE Table Procedures ----------------------------

CREATE OR REPLACE PROCEDURE Insert_ResourceType(
    p_TypeName IN VARCHAR2,
    p_Description IN VARCHAR2,
    p_EligibleForPromotion IN VARCHAR2
) AS
BEGIN
    -- Validate EligibleForPromotion value
    IF p_EligibleForPromotion NOT IN ('Yes', 'No') THEN
        RAISE_APPLICATION_ERROR(-20070, 'EligibleForPromotion must be Yes or No.');
    END IF;

    -- Insert ResourceType
    INSERT INTO RESOURCETYPE (TYPENAME, DESCRIPTION, ELIGIBLEFORPROMOTION)
    VALUES (p_TypeName, p_Description, p_EligibleForPromotion);
    DBMS_OUTPUT.PUT_LINE('ResourceType inserted: ' || p_TypeName);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_ResourceType(
    p_ResourceTypeID IN NUMBER,
    p_TypeName IN VARCHAR2,
    p_Description IN VARCHAR2,
    p_EligibleForPromotion IN VARCHAR2
) AS
    l_resource_exists NUMBER;
BEGIN
    -- Validate ResourceTypeID existence
    SELECT COUNT(*) INTO l_resource_exists FROM RESOURCETYPE WHERE RESOURCETYPEID = p_ResourceTypeID;
    IF l_resource_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20073, 'ResourceTypeID does not exist.');
    END IF;

    -- Update ResourceType details
    UPDATE RESOURCETYPE
    SET TYPENAME = p_TypeName,
        DESCRIPTION = p_Description,
        ELIGIBLEFORPROMOTION = p_EligibleForPromotion
    WHERE RESOURCETYPEID = p_ResourceTypeID;

    DBMS_OUTPUT.PUT_LINE('ResourceType updated: ID=' || p_ResourceTypeID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Delete_ResourceType(
    p_ResourceTypeID IN NUMBER
) AS
    l_resource_exists NUMBER;
BEGIN
    -- Validate ResourceTypeID existence
    SELECT COUNT(*) INTO l_resource_exists FROM RESOURCETYPE WHERE RESOURCETYPEID = p_ResourceTypeID;
    IF l_resource_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20075, 'ResourceTypeID does not exist.');
    END IF;

    -- Delete ResourceType
    DELETE FROM RESOURCETYPE WHERE RESOURCETYPEID = p_ResourceTypeID;
    DBMS_OUTPUT.PUT_LINE('ResourceType deleted: ID=' || p_ResourceTypeID);
    COMMIT;
END;
/

---------------------- RESOURCETABLE Table Procedures -------------------------

CREATE OR REPLACE PROCEDURE Insert_Resource(
    p_ResourceTypeID IN NUMBER,
    p_Capacity IN NUMBER,
    p_Status IN VARCHAR2,
    p_QuantityOnHand IN NUMBER,
    p_ThresholdValue IN NUMBER,
    p_Zone IN VARCHAR2
) AS
    l_resource_type_exists NUMBER;
BEGIN
    -- Validate ResourceTypeID existence
    SELECT COUNT(*) INTO l_resource_type_exists FROM RESOURCETYPE WHERE RESOURCETYPEID = p_ResourceTypeID;
    IF l_resource_type_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20076, 'ResourceTypeID does not exist: ' || p_ResourceTypeID);
    END IF;

    -- Validate Status is not NULL
    IF p_Status IS NULL THEN
        RAISE_APPLICATION_ERROR(-20077, 'Resource Status cannot be NULL.');
    END IF;

    -- Insert into ResourceTable
    INSERT INTO RESOURCETABLE (RESOURCETYPEID, CAPACITY, STATUS, QUANTITYONHAND, THRESHOLDVALUE, ZONE)
    VALUES (p_ResourceTypeID, p_Capacity, p_Status, p_QuantityOnHand, p_ThresholdValue, p_Zone);

    DBMS_OUTPUT.PUT_LINE('Resource inserted: TypeID=' || p_ResourceTypeID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_Resource(
    p_ResourceID IN NUMBER,
    p_ResourceTypeID IN NUMBER,
    p_Capacity IN NUMBER,
    p_Status IN VARCHAR2,
    p_QuantityOnHand IN NUMBER,
    p_ThresholdValue IN NUMBER,
    p_Zone IN VARCHAR2
) AS
    l_resource_exists NUMBER;
    l_resource_type_exists NUMBER;
BEGIN
    -- Validate ResourceID is not NULL
    IF p_ResourceID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20080, 'ResourceID cannot be NULL.');
    END IF;

    -- Validate ResourceID existence
    SELECT COUNT(*) INTO l_resource_exists FROM RESOURCETABLE WHERE RESOURCEID = p_ResourceID;
    IF l_resource_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20081, 'ResourceID does not exist: ' || p_ResourceID);
    END IF;

    -- Validate ResourceTypeID existence
    SELECT COUNT(*) INTO l_resource_type_exists FROM RESOURCETYPE WHERE RESOURCETYPEID = p_ResourceTypeID;
    IF l_resource_type_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20082, 'ResourceTypeID does not exist: ' || p_ResourceTypeID);
    END IF;

    -- Perform Update
    UPDATE RESOURCETABLE
    SET RESOURCETYPEID = p_ResourceTypeID, 
        CAPACITY = p_Capacity, 
        STATUS = p_Status, 
        QUANTITYONHAND = p_QuantityOnHand, 
        THRESHOLDVALUE = p_ThresholdValue, 
        ZONE = p_Zone
    WHERE RESOURCEID = p_ResourceID;

    DBMS_OUTPUT.PUT_LINE('Resource updated: ID=' || p_ResourceID);
    COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE Delete_Resource(
    p_ResourceID IN NUMBER
) AS
    l_resource_exists NUMBER;
BEGIN
    -- Validate ResourceID is not NULL
    IF p_ResourceID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20090, 'ResourceID cannot be NULL.');
    END IF;

    -- Validate ResourceID existence
    SELECT COUNT(*) INTO l_resource_exists FROM RESOURCETABLE WHERE RESOURCEID = p_ResourceID;
    IF l_resource_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20091, 'ResourceID does not exist: ' || p_ResourceID);
    END IF;

    -- Perform Delete
    DELETE FROM RESOURCETABLE WHERE RESOURCEID = p_ResourceID;
    DBMS_OUTPUT.PUT_LINE('Resource deleted: ID=' || p_ResourceID);
    COMMIT;
END;
/


---------- RESOURCEALLOCATION -----------
CREATE OR REPLACE PROCEDURE Insert_ResourceAllocation(
    p_ClientID IN NUMBER,
    p_ResourceID IN NUMBER,
    p_RequestDate IN DATE DEFAULT SYSDATE,
    p_AllocationDate IN DATE DEFAULT NULL,
    p_ExpirationDate IN DATE DEFAULT NULL,
    p_Status IN VARCHAR2 DEFAULT 'Pending'
) AS
    l_client_exists NUMBER;
    l_resource_exists NUMBER;
BEGIN
    -- Validate CLIENTID existence
    SELECT COUNT(*) INTO l_client_exists FROM CLIENT WHERE CLIENTID = p_ClientID;
    IF l_client_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20110, 'ClientID does not exist: ' || p_ClientID);
    END IF;

    -- Validate RESOURCEID existence
    SELECT COUNT(*) INTO l_resource_exists FROM RESOURCETABLE WHERE RESOURCEID = p_ResourceID;
    IF l_resource_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20111, 'ResourceID does not exist: ' || p_ResourceID);
    END IF;

    -- Insert data into RESOURCEALLOCATION table
    INSERT INTO RESOURCEALLOCATION (
        CLIENTID, RESOURCEID, REQUESTDATE, ALLOCATIONDATE, EXPIRATIONDATE, STATUS
    ) VALUES (
        p_ClientID, p_ResourceID, p_RequestDate, p_AllocationDate, p_ExpirationDate, p_Status
    );

    DBMS_OUTPUT.PUT_LINE('Resource allocation inserted: ClientID=' || p_ClientID || ', ResourceID=' || p_ResourceID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_ResourceAllocation(
    p_AllocationID IN NUMBER,
    p_ClientID IN NUMBER DEFAULT NULL,
    p_ResourceID IN NUMBER DEFAULT NULL,
    p_RequestDate IN DATE DEFAULT NULL,
    p_AllocationDate IN DATE DEFAULT NULL,
    p_ExpirationDate IN DATE DEFAULT NULL,
    p_Status IN VARCHAR2 DEFAULT NULL
) AS
    l_allocation_exists NUMBER;
BEGIN
    -- Validate AllocationID existence
    SELECT COUNT(*) INTO l_allocation_exists FROM RESOURCEALLOCATION WHERE ALLOCATIONID = p_AllocationID;
    IF l_allocation_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20112, 'AllocationID does not exist: ' || p_AllocationID);
    END IF;

    -- Update RESOURCEALLOCATION table
    UPDATE RESOURCEALLOCATION
    SET CLIENTID = NVL(p_ClientID, CLIENTID),
        RESOURCEID = NVL(p_ResourceID, RESOURCEID),
        REQUESTDATE = NVL(p_RequestDate, REQUESTDATE),
        ALLOCATIONDATE = NVL(p_AllocationDate, ALLOCATIONDATE),
        EXPIRATIONDATE = NVL(p_ExpirationDate, EXPIRATIONDATE),
        STATUS = NVL(p_Status, STATUS)
    WHERE ALLOCATIONID = p_AllocationID;

    DBMS_OUTPUT.PUT_LINE('Resource allocation updated: AllocationID=' || p_AllocationID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Delete_ResourceAllocation(
    p_AllocationID IN NUMBER
) AS
    l_allocation_exists NUMBER;
BEGIN
    -- Validate AllocationID existence
    SELECT COUNT(*) INTO l_allocation_exists FROM RESOURCEALLOCATION WHERE ALLOCATIONID = p_AllocationID;
    IF l_allocation_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20113, 'AllocationID does not exist: ' || p_AllocationID);
    END IF;

    -- Delete from RESOURCEALLOCATION table
    DELETE FROM RESOURCEALLOCATION WHERE ALLOCATIONID = p_AllocationID;

    DBMS_OUTPUT.PUT_LINE('Resource allocation deleted: AllocationID=' || p_AllocationID);
    COMMIT;
END;
/


-- Process_Expired_Allocations

CREATE OR REPLACE PROCEDURE Process_Expired_Allocations AS
BEGIN
    -- Update status to 'Expired' for allocations past their expiration date
    UPDATE RESOURCEALLOCATION
    SET STATUS = 'Expired'
    WHERE EXPIRATIONDATE < SYSDATE AND STATUS IN ('Approved', 'Pending');

    DBMS_OUTPUT.PUT_LINE('Expired allocations processed successfully.');
    COMMIT;
END;
/


------------------------ BILL Table Procedures ---------------------------------

CREATE OR REPLACE PROCEDURE Insert_Bill(
    p_BillPeriodStart IN DATE,
    p_BillPeriodEnd IN DATE,
    p_TotalAmount IN FLOAT,
    p_Status IN VARCHAR2
) AS
BEGIN
    -- Validate NULL inputs
    IF p_BillPeriodStart IS NULL THEN
        RAISE_APPLICATION_ERROR(-20060, 'Bill start date cannot be NULL.');
    END IF;

    IF p_TotalAmount IS NULL THEN
        RAISE_APPLICATION_ERROR(-20061, 'Total amount cannot be NULL.');
    END IF;
    
    INSERT INTO BILL (BILLPERIODSTART, BILLPERIODEND, TOTALAMOUNT, STATUS)
    VALUES (p_BillPeriodStart, p_BillPeriodEnd, p_TotalAmount, p_Status);
    DBMS_OUTPUT.PUT_LINE('Bill inserted for period: ' || p_BillPeriodStart || ' to ' || p_BillPeriodEnd);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_Bill(
    p_BillID IN NUMBER,
    p_BillPeriodStart IN DATE,
    p_BillPeriodEnd IN DATE,
    p_TotalAmount IN FLOAT,
    p_Status IN VARCHAR2
) AS
BEGIN
    
    UPDATE BILL
    SET BILLPERIODSTART = p_BillPeriodStart, BILLPERIODEND = p_BillPeriodEnd,
        TOTALAMOUNT = p_TotalAmount, STATUS = p_Status
    WHERE BILLID = p_BillID;

    DBMS_OUTPUT.PUT_LINE('Bill updated: ID=' || p_BillID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Delete_Bill(
    p_BillID IN NUMBER
) AS
BEGIN
    DELETE FROM BILL WHERE BILLID = p_BillID;
    DBMS_OUTPUT.PUT_LINE('Bill deleted: ID=' || p_BillID);
    COMMIT;
END;
/

-------------------------- USAGELOG Table Procedures ----------------------------

CREATE OR REPLACE PROCEDURE Insert_UsageLog(
    p_AllocationID IN NUMBER,
    p_StartTime IN TIMESTAMP,
    p_EndTime IN TIMESTAMP,
    p_UsageAmount IN FLOAT,
    p_BillID IN NUMBER,
    p_TotalCost IN FLOAT
) AS
BEGIN
    INSERT INTO USAGELOG (ALLOCATIONID, STARTTIME, ENDTIME, USAGEAMOUNT, BILLID, TOTALCOST)
    VALUES (p_AllocationID, p_StartTime, p_EndTime, p_UsageAmount, p_BillID, p_TotalCost);

    DBMS_OUTPUT.PUT_LINE('Usage log inserted: AllocationID=' || p_AllocationID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Update_UsageLog(
    p_LogID IN NUMBER,
    p_AllocationID IN NUMBER,
    p_StartTime IN TIMESTAMP,
    p_EndTime IN TIMESTAMP,
    p_UsageAmount IN FLOAT,
    p_BillID IN NUMBER,
    p_TotalCost IN FLOAT
) AS
BEGIN
    UPDATE USAGELOG
    SET ALLOCATIONID = p_AllocationID, STARTTIME = p_StartTime, ENDTIME = p_EndTime,
        USAGEAMOUNT = p_UsageAmount, BILLID = p_BillID, TOTALCOST = p_TotalCost
    WHERE LOGID = p_LogID;

    DBMS_OUTPUT.PUT_LINE('Usage log updated: ID=' || p_LogID);
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE Delete_UsageLog(
    p_LogID IN NUMBER
) AS
BEGIN
    DELETE FROM USAGELOG WHERE LOGID = p_LogID;
    DBMS_OUTPUT.PUT_LINE('Usage log deleted: ID=' || p_LogID);
    COMMIT;
END;
/

------------------ PROCESS_PENDING_REQUESTS ---------------

CREATE OR REPLACE PROCEDURE Process_Pending_Requests AS
    CURSOR pending_requests_cur IS
        SELECT 
            ra.ALLOCATIONID, 
            ra.RESOURCEID, 
            rt.QUANTITYONHAND, 
            rt.THRESHOLDVALUE
        FROM 
            RESOURCEALLOCATION ra
        JOIN 
            RESOURCETABLE rt ON ra.RESOURCEID = rt.RESOURCEID
        WHERE 
            ra.STATUS = 'Pending';

    l_quantity_on_hand NUMBER;
    l_threshold_value NUMBER;
BEGIN
    -- Loop through all pending requests
    FOR pending_request IN pending_requests_cur LOOP
        -- Fetch current quantity and threshold value for the resource
        l_quantity_on_hand := pending_request.QUANTITYONHAND;
        l_threshold_value := pending_request.THRESHOLDVALUE;

        IF l_quantity_on_hand > 0 THEN
            -- If resources are available, approve the request
            UPDATE RESOURCEALLOCATION
            SET STATUS = 'Approved',
                ALLOCATIONDATE = SYSDATE,
                EXPIRATIONDATE = SYSDATE + INTERVAL '30' DAY
            WHERE ALLOCATIONID = pending_request.ALLOCATIONID;

            -- Decrease the quantity on hand
            UPDATE RESOURCETABLE
            SET QUANTITYONHAND = QUANTITYONHAND - 1
            WHERE RESOURCEID = pending_request.RESOURCEID;

            DBMS_OUTPUT.PUT_LINE('Allocation ID ' || pending_request.ALLOCATIONID || ' approved.');
        ELSE
            -- If resources are unavailable, reject the request
            UPDATE RESOURCEALLOCATION
            SET STATUS = 'Rejected'
            WHERE ALLOCATIONID = pending_request.ALLOCATIONID;

            DBMS_OUTPUT.PUT_LINE('Allocation ID ' || pending_request.ALLOCATIONID || ' rejected due to insufficient resources.');
        END IF;
    END LOOP;

    -- Commit the changes
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Processing of pending requests completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error processing pending requests: ' || SQLERRM);
END;
/




