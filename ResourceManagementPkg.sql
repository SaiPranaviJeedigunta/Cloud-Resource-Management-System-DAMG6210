
--------------------------- Resource Management Package -------------------------

CREATE OR REPLACE PACKAGE Resource_Management_Pkg AS
    -- Resource Type Procedures
    PROCEDURE Insert_ResourceType(p_TypeName IN VARCHAR2, p_Description IN VARCHAR2, p_EligibleForPromotion IN VARCHAR2);
    PROCEDURE Update_ResourceType(p_ResourceTypeID IN NUMBER, p_TypeName IN VARCHAR2, p_Description IN VARCHAR2, p_EligibleForPromotion IN VARCHAR2);
    PROCEDURE Delete_ResourceType(p_ResourceTypeID IN NUMBER);

    -- Resource Procedures
    PROCEDURE Insert_Resource(
        p_ResourceTypeID IN NUMBER, p_Capacity IN NUMBER, p_Status IN VARCHAR2,
        p_QuantityOnHand IN NUMBER, p_ThresholdValue IN NUMBER, p_Zone IN VARCHAR2
    );
    PROCEDURE Update_Resource(
        p_ResourceID IN NUMBER, p_ResourceTypeID IN NUMBER, p_Capacity IN NUMBER,
        p_Status IN VARCHAR2, p_QuantityOnHand IN NUMBER, p_ThresholdValue IN NUMBER, p_Zone IN VARCHAR2
    );
    PROCEDURE Delete_Resource(p_ResourceID IN NUMBER);

    -- Resource Allocation Procedures
    PROCEDURE Insert_ResourceAllocation(
        p_ClientID IN NUMBER,
        p_ResourceID IN NUMBER,
        p_RequestDate IN DATE DEFAULT SYSDATE,
        p_AllocationDate IN DATE DEFAULT NULL,
        p_ExpirationDate IN DATE DEFAULT NULL,
        p_Status IN VARCHAR2 DEFAULT 'Pending'
    );

    PROCEDURE Update_ResourceAllocation(
        p_AllocationID IN NUMBER,
        p_ClientID IN NUMBER DEFAULT NULL,
        p_ResourceID IN NUMBER DEFAULT NULL,
        p_RequestDate IN DATE DEFAULT NULL,
        p_AllocationDate IN DATE DEFAULT NULL,
        p_ExpirationDate IN DATE DEFAULT NULL,
        p_Status IN VARCHAR2 DEFAULT NULL
    );
    
    PROCEDURE Delete_ResourceAllocation(
        p_AllocationID IN NUMBER
    );
        
    PROCEDURE Process_Pending_Requests;
    
    PROCEDURE Process_Expired_Allocations;

    
    -- Pricing Plan Procedures
    PROCEDURE Insert_PricingPlan(p_PlanName IN VARCHAR2, p_Description IN VARCHAR2,p_PlanID IN NUMBER);
    PROCEDURE Update_PricingPlan(p_PlanID IN NUMBER, p_PlanName IN VARCHAR2, p_Description IN VARCHAR2);
    PROCEDURE Delete_PricingPlan(p_PlanID IN NUMBER);

    -- Pricing Detail Procedures
    PROCEDURE Insert_PricingDetail(p_PlanID IN NUMBER, p_ResourceTypeID IN NUMBER, p_UnitPrice IN FLOAT);
    PROCEDURE Update_PricingDetail(
        p_DetailID IN NUMBER, p_PlanID IN NUMBER DEFAULT NULL, 
        p_ResourceTypeID IN NUMBER DEFAULT NULL, p_UnitPrice IN FLOAT DEFAULT NULL
    );
    PROCEDURE Delete_PricingDetail(p_DetailID IN NUMBER);
    
END Resource_Management_Pkg;
/

CREATE OR REPLACE PACKAGE BODY Resource_Management_Pkg AS
    -- Implementations for all declared procedures
   ------------------- RESOURCETYPE Table Procedures ----------------------------

PROCEDURE Insert_ResourceType(
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

PROCEDURE Update_ResourceType(
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


PROCEDURE Delete_ResourceType(
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


---------------------- RESOURCETABLE Table Procedures -------------------------

PROCEDURE Insert_Resource(
    p_ResourceTypeID IN NUMBER,
    p_Capacity IN NUMBER,
    p_Status IN VARCHAR2,
    p_QuantityOnHand IN NUMBER,
    p_ThresholdValue IN NUMBER,
    p_Zone IN VARCHAR2
) AS
    l_resource_type_exists NUMBER;
    v_AvailableResources NUMBER;
BEGIN

     -- Get the number of available resources for the specified type
    v_AvailableResources := Get_Available_Resources(p_ResourceTypeID);

    DBMS_OUTPUT.PUT_LINE('Available resources for ResourceTypeID ' || p_ResourceTypeID || ': ' || v_AvailableResources);
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
    
    -- Get the number of available resources for the specified type

    COMMIT;
END;


PROCEDURE Update_Resource(
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



PROCEDURE Delete_Resource(
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



---------- RESOURCEALLOCATION -----------
PROCEDURE Insert_ResourceAllocation(
    p_ClientID IN NUMBER,
    p_ResourceID IN NUMBER,
    p_RequestDate IN DATE DEFAULT SYSDATE,
    p_AllocationDate IN DATE DEFAULT NULL,
    p_ExpirationDate IN DATE DEFAULT NULL,
    p_Status IN VARCHAR2 DEFAULT 'Pending'
) AS
    l_client_exists NUMBER;
    l_resource_exists NUMBER;
    v_TotalAllocations NUMBER;
BEGIN
    
     -- Compute total allocations for the client
    v_TotalAllocations := Compute_Total_Resource_Allocation(p_ClientID);

    DBMS_OUTPUT.PUT_LINE('Total resources allocated for ClientID ' || p_ClientID || ': ' || v_TotalAllocations);
    
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


PROCEDURE Update_ResourceAllocation(
    p_AllocationID IN NUMBER,
    p_ClientID IN NUMBER DEFAULT NULL,
    p_ResourceID IN NUMBER DEFAULT NULL,
    p_RequestDate IN DATE DEFAULT NULL,
    p_AllocationDate IN DATE DEFAULT NULL,
    p_ExpirationDate IN DATE DEFAULT NULL,
    p_Status IN VARCHAR2 DEFAULT NULL
) AS
    l_allocation_exists NUMBER;
    v_ExpirationDate DATE;
BEGIN

-- Calculate expiration date based on allocation date
    IF p_AllocationDate IS NOT NULL THEN
        v_ExpirationDate := Calculate_Allocation_Expiration_Date(p_AllocationDate);
    END IF;

    DBMS_OUTPUT.PUT_LINE('Calculated expiration date: ' || v_ExpirationDate);
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


PROCEDURE Delete_ResourceAllocation(
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

------------------- PRICINGPLAN Table Procedures ---------------------------

PROCEDURE Insert_PricingPlan(
    p_PlanName IN VARCHAR2,
    p_Description IN VARCHAR2,
    p_PlanID IN NUMBER
) AS
    v_PricingDetails VARCHAR2(4000);
BEGIN
 -- Fetch existing pricing plan details
    v_PricingDetails := Fetch_Pricing_Details_By_Plan(p_PlanID);

    DBMS_OUTPUT.PUT_LINE('Current Pricing Plan Details: ' || v_PricingDetails);
    INSERT INTO PRICINGPLAN (PLANNAME, DESCRIPTION) VALUES (p_PlanName, p_Description);
    DBMS_OUTPUT.PUT_LINE('Pricing plan inserted: ' || p_PlanName);
    COMMIT;
END;


PROCEDURE Update_PricingPlan(
    p_PlanID IN NUMBER,
    p_PlanName IN VARCHAR2,
    p_Description IN VARCHAR2
) AS
BEGIN

    
    UPDATE PRICINGPLAN SET PLANNAME = p_PlanName, DESCRIPTION = p_Description WHERE PLANID = p_PlanID;
    DBMS_OUTPUT.PUT_LINE('Pricing plan updated: ID=' || p_PlanID);
    COMMIT;
END;


PROCEDURE Delete_PricingPlan(
    p_PlanID IN NUMBER
) AS
BEGIN

    DELETE FROM PRICINGPLAN WHERE PLANID = p_PlanID;
    DBMS_OUTPUT.PUT_LINE('Pricing plan deleted: ID=' || p_PlanID);
    COMMIT;
END;


--------------- PRICING DETAIL PROCEDURE -------------------

PROCEDURE Insert_PricingDetail(
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


PROCEDURE Update_PricingDetail(
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


PROCEDURE Delete_PricingDetail(
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



-- Process_Expired_Allocations

PROCEDURE Process_Expired_Allocations AS
BEGIN
    -- Update status to 'Expired' for allocations past their expiration date
    UPDATE RESOURCEALLOCATION
    SET STATUS = 'Expired'
    WHERE EXPIRATIONDATE < SYSDATE AND STATUS IN ('Approved', 'Pending');

    DBMS_OUTPUT.PUT_LINE('Expired allocations processed successfully.');
    COMMIT;
END;
PROCEDURE Process_Pending_Requests AS
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
END Resource_Management_Pkg;
/

