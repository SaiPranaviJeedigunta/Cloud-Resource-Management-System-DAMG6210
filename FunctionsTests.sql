----- functions test ---------
 
 
------  Compute_Total_Resource_Allocation
 
SET SERVEROUTPUT ON;
 
DECLARE
    v_TotalAllocations NUMBER;
BEGIN
    -- Test Case 1: Valid ClientID with allocations
    v_TotalAllocations := Compute_Total_Resource_Allocation(1);
    DBMS_OUTPUT.PUT_LINE('Total Allocations for ClientID 1: ' || v_TotalAllocations);
 
    -- Test Case 2: Valid ClientID with no allocations
    v_TotalAllocations := Compute_Total_Resource_Allocation(999);
    DBMS_OUTPUT.PUT_LINE('Total Allocations for ClientID 999 (No Allocations): ' || v_TotalAllocations);
 
    -- Test Case 3: Null ClientID
    v_TotalAllocations := Compute_Total_Resource_Allocation(NULL);
    DBMS_OUTPUT.PUT_LINE('Total Allocations for NULL ClientID: ' || v_TotalAllocations);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error testing Compute_Total_Resource_Allocation: ' || SQLERRM);
END;
/
 
 
------- Calculate_Usage_Summary
SET SERVEROUTPUT ON;
 
DECLARE
    v_TotalUsage FLOAT;
BEGIN
    -- Test Case 1: Valid ClientID with usage data
    v_TotalUsage := Calculate_Usage_Summary(1);
    DBMS_OUTPUT.PUT_LINE('Total Usage Summary for ClientID 1: ' || v_TotalUsage);
 
    -- Test Case 2: Valid ClientID with no usage data
    v_TotalUsage := Calculate_Usage_Summary(999);
    DBMS_OUTPUT.PUT_LINE('Total Usage Summary for ClientID 999 (No Usage): ' || v_TotalUsage);
 
    -- Test Case 3: Null ClientID
    v_TotalUsage := Calculate_Usage_Summary(NULL);
    DBMS_OUTPUT.PUT_LINE('Total Usage Summary for NULL ClientID: ' || v_TotalUsage);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error testing Calculate_Usage_Summary: ' || SQLERRM);
END;
/
 
 
---------- Get_Available_Resources
 
SET SERVEROUTPUT ON;
 
DECLARE
    v_AvailableCount NUMBER;
BEGIN
    -- Test Case 1: Valid ResourceTypeID with resources
    v_AvailableCount := Get_Available_Resources(1);
    DBMS_OUTPUT.PUT_LINE('Available Resources for ResourceTypeID 1: ' || v_AvailableCount);
 
    -- Test Case 2: Valid ResourceTypeID with no resources
    v_AvailableCount := Get_Available_Resources(999);
    DBMS_OUTPUT.PUT_LINE('Available Resources for ResourceTypeID 999 (No Resources): ' || v_AvailableCount);
 
    -- Test Case 3: Null ResourceTypeID
    v_AvailableCount := Get_Available_Resources(NULL);
    DBMS_OUTPUT.PUT_LINE('Available Resources for NULL ResourceTypeID: ' || v_AvailableCount);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error testing Get_Available_Resources: ' || SQLERRM);
END;
/
 
 
--------- Validate_Client_Email
SET SERVEROUTPUT ON;
 
DECLARE
    v_EmailValidation VARCHAR2(100);
BEGIN
    -- Test Case 1: Email exists
    v_EmailValidation := Validate_Client_Email('john.doe@example.com');
    DBMS_OUTPUT.PUT_LINE('Validation for john.doe@example.com: ' || v_EmailValidation);
 
    -- Test Case 2: Email does not exist
    v_EmailValidation := Validate_Client_Email('nonexistent@example.com');
    DBMS_OUTPUT.PUT_LINE('Validation for nonexistent@example.com: ' || v_EmailValidation);
 
    -- Test Case 3: Null email
    v_EmailValidation := Validate_Client_Email(NULL);
    DBMS_OUTPUT.PUT_LINE('Validation for NULL email: ' || v_EmailValidation);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error testing Validate_Client_Email: ' || SQLERRM);
END;
/
 
------ Calculate_Allocation_Expiration_Date
 
SET SERVEROUTPUT ON;
 
DECLARE
    v_ExpirationDate DATE;
BEGIN
    -- Test Case 1: Valid allocation date
    v_ExpirationDate := Calculate_Allocation_Expiration_Date(SYSDATE);
    DBMS_OUTPUT.PUT_LINE('Expiration Date for SYSDATE: ' || TO_CHAR(v_ExpirationDate, 'DD-MON-YYYY'));
 
    -- Test Case 2: Null allocation date
    v_ExpirationDate := Calculate_Allocation_Expiration_Date(NULL);
    DBMS_OUTPUT.PUT_LINE('Expiration Date for NULL Date: ' || TO_CHAR(v_ExpirationDate, 'DD-MON-YYYY'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error testing Calculate_Allocation_Expiration_Date: ' || SQLERRM);
END;
/
 
 
-------- Fetch_Pricing_Details_By_Plan
 
SET SERVEROUTPUT ON;
 
DECLARE
    v_PlanDetails VARCHAR2(4000);
BEGIN
    -- Test Case 1: Valid PlanID
    v_PlanDetails := Fetch_Pricing_Details_By_Plan(1);
    DBMS_OUTPUT.PUT_LINE('Pricing Details for PlanID 1: ' || v_PlanDetails);
 
    -- Test Case 2: Invalid PlanID
    v_PlanDetails := Fetch_Pricing_Details_By_Plan(999);
    DBMS_OUTPUT.PUT_LINE('Pricing Details for PlanID 999: ' || v_PlanDetails);
 
    -- Test Case 3: Null PlanID
    v_PlanDetails := Fetch_Pricing_Details_By_Plan(NULL);
    DBMS_OUTPUT.PUT_LINE('Pricing Details for NULL PlanID: ' || v_PlanDetails);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error testing Fetch_Pricing_Details_By_Plan: ' || SQLERRM);
END;
/