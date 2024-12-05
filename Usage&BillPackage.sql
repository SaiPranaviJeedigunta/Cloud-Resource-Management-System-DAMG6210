CREATE OR REPLACE PACKAGE Usage_Billing_Pkg AS
    -- Billing Procedures
    PROCEDURE Insert_Bill(p_BillPeriodStart IN DATE, p_BillPeriodEnd IN DATE, p_TotalAmount IN FLOAT, p_Status IN VARCHAR2);
    PROCEDURE Update_Bill(p_BillID IN NUMBER, p_BillPeriodStart IN DATE, p_BillPeriodEnd IN DATE, p_TotalAmount IN FLOAT, p_Status IN VARCHAR2);
    PROCEDURE Delete_Bill(p_BillID IN NUMBER);

    -- Usage Log Procedures
    PROCEDURE Insert_UsageLog(
        p_AllocationID IN NUMBER, p_StartTime IN TIMESTAMP, p_EndTime IN TIMESTAMP,
        p_UsageAmount IN FLOAT, p_BillID IN NUMBER, p_TotalCost IN FLOAT
    );
    PROCEDURE Update_UsageLog(
        p_LogID IN NUMBER, p_AllocationID IN NUMBER, p_StartTime IN TIMESTAMP,
        p_EndTime IN TIMESTAMP, p_UsageAmount IN FLOAT, p_BillID IN NUMBER, p_TotalCost IN FLOAT
    );
    PROCEDURE Delete_UsageLog(p_LogID IN NUMBER);
END Usage_Billing_Pkg;
/

CREATE OR REPLACE PACKAGE BODY Usage_Billing_Pkg AS
    -- Implementations for all declared procedures
    ------------------------ BILL Table Procedures ---------------------------------

PROCEDURE Insert_Bill(
    p_BillPeriodStart IN DATE,
    p_BillPeriodEnd IN DATE,
    p_TotalAmount IN FLOAT,
    p_Status IN VARCHAR2
) AS
    v_TotalUsage FLOAT;
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
    
    -- Calculate total usage for the bill period
    v_TotalUsage := Calculate_Usage_Summary(101); -- Replace with relevant ClientID

    DBMS_OUTPUT.PUT_LINE('Total usage for ClientID 101: ' || v_TotalUsage);
    
    COMMIT;
END;


PROCEDURE Update_Bill(
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


PROCEDURE Delete_Bill(
    p_BillID IN NUMBER
) AS
BEGIN
    DELETE FROM BILL WHERE BILLID = p_BillID;
    DBMS_OUTPUT.PUT_LINE('Bill deleted: ID=' || p_BillID);
    COMMIT;
END;


-------------------------- USAGELOG Table Procedures ----------------------------

PROCEDURE Insert_UsageLog(
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


PROCEDURE Update_UsageLog(
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


PROCEDURE Delete_UsageLog(
    p_LogID IN NUMBER
) AS
BEGIN
    DELETE FROM USAGELOG WHERE LOGID = p_LogID;
    DBMS_OUTPUT.PUT_LINE('Usage log deleted: ID=' || p_LogID);
    COMMIT;
END;

END Usage_Billing_Pkg;
/
