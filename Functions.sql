--- FUNCTIONS ----


---- Compute_Total_Resource_Allocation --------
CREATE OR REPLACE FUNCTION Compute_Total_Resource_Allocation(p_ClientID IN NUMBER) RETURN NUMBER IS
    v_TotalAllocations NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_TotalAllocations
    FROM RESOURCEALLOCATION
    WHERE CLIENTID = p_ClientID;

    RETURN NVL(v_TotalAllocations, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Return 0 if no allocations are found
END;
/


------- Calculate_Usage_Summary ----------
CREATE OR REPLACE FUNCTION Calculate_Usage_Summary(p_ClientID IN NUMBER) RETURN FLOAT IS
    v_TotalUsage FLOAT;
BEGIN
    SELECT SUM(USAGEAMOUNT)
    INTO v_TotalUsage
    FROM USAGELOG UL
    JOIN RESOURCEALLOCATION RA ON UL.ALLOCATIONID = RA.ALLOCATIONID
    WHERE RA.CLIENTID = p_ClientID;

    RETURN NVL(v_TotalUsage, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Return 0 if no usage is found
END;
/


------ Get_Available_Resources ----------
CREATE OR REPLACE FUNCTION Get_Available_Resources(p_ResourceTypeID IN NUMBER) RETURN NUMBER IS
    v_AvailableCount NUMBER;
BEGIN
    SELECT SUM(QUANTITYONHAND)
    INTO v_AvailableCount
    FROM RESOURCETABLE
    WHERE RESOURCETYPEID = p_ResourceTypeID;

    RETURN NVL(v_AvailableCount, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Return 0 if no resources are available
END;
/


---------- Validate_Client_Email --------------
CREATE OR REPLACE FUNCTION Validate_Client_Email(p_Email IN VARCHAR2) RETURN VARCHAR2 IS
    v_ClientExists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_ClientExists
    FROM CLIENT
    WHERE EMAIL = p_Email;

    IF v_ClientExists > 0 THEN
        RETURN 'Email exists.';
    ELSE
        RETURN 'Email does not exist.';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error validating email.';
END;
/

CREATE OR REPLACE FUNCTION Calculate_Allocation_Expiration_Date(p_AllocationDate IN DATE) RETURN DATE IS
    v_ExpirationDate DATE;
BEGIN
    -- Assuming a default expiration period of 30 days
    v_ExpirationDate := p_AllocationDate + INTERVAL '30' DAY;
    RETURN v_ExpirationDate;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL; -- Return NULL in case of an error
END;
/


---------- Fetch_Pricing_Details_By_Plan ---------------
CREATE OR REPLACE FUNCTION Fetch_Pricing_Details_By_Plan(p_PlanID IN NUMBER) RETURN VARCHAR2 IS
    v_PlanDetails VARCHAR2(4000);
BEGIN
    SELECT 'Plan: ' || PLANNAME || ', Description: ' || DESCRIPTION
    INTO v_PlanDetails
    FROM PRICINGPLAN
    WHERE PLANID = p_PlanID;

    RETURN v_PlanDetails;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Pricing plan not found.';
END;
/


