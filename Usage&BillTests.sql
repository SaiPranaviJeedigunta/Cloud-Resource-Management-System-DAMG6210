-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;
CONNECT user_b/password_b;
BEGIN
    DBMS_OUTPUT.PUT_LINE('===== Testing Usage Billing Package =====');
 
    -- =======================
    -- BILL Table Tests
    -- =======================
    DBMS_OUTPUT.PUT_LINE('--- Testing BILL Procedures ---');
 
    -- Test Insert_Bill
    BEGIN
        Usage_Billing_Pkg.Insert_Bill(SYSDATE - 30, SYSDATE, 1000.50, 'Unpaid');
        DBMS_OUTPUT.PUT_LINE('Inserted Bill for the period from SYSDATE-30 to SYSDATE');
        DBMS_OUTPUT.PUT_LINE('--- Verifying BILL Table After Insert ---');
        FOR rec IN (SELECT * FROM BILL) LOOP
            DBMS_OUTPUT.PUT_LINE('BILLID: ' || rec.BILLID || ', PERIOD: ' || rec.BILLPERIODSTART || ' to ' || rec.BILLPERIODEND || ', AMOUNT: ' || rec.TOTALAMOUNT || ', STATUS: ' || rec.STATUS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_Bill Error: ' || SQLERRM);
    END;
 
    -- Test Update_Bill
    BEGIN
        Usage_Billing_Pkg.Update_Bill(1, SYSDATE - 60, SYSDATE - 30, 1200.75, 'Paid');
        DBMS_OUTPUT.PUT_LINE('Updated BillID 1 to Closed with updated total amount');
        DBMS_OUTPUT.PUT_LINE('--- Verifying BILL Table After Update ---');
        FOR rec IN (SELECT * FROM BILL) LOOP
            DBMS_OUTPUT.PUT_LINE('BILLID: ' || rec.BILLID || ', PERIOD: ' || rec.BILLPERIODSTART || ' to ' || rec.BILLPERIODEND || ', AMOUNT: ' || rec.TOTALAMOUNT || ', STATUS: ' || rec.STATUS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Update_Bill Error: ' || SQLERRM);
    END;
 
    -- Test Delete_Bill
    BEGIN
        Usage_Billing_Pkg.Delete_Bill(1);
        DBMS_OUTPUT.PUT_LINE('Deleted BillID 1');
        DBMS_OUTPUT.PUT_LINE('--- Verifying BILL Table After Delete ---');
        FOR rec IN (SELECT * FROM BILL) LOOP
            DBMS_OUTPUT.PUT_LINE('BILLID: ' || rec.BILLID || ', PERIOD: ' || rec.BILLPERIODSTART || ' to ' || rec.BILLPERIODEND || ', AMOUNT: ' || rec.TOTALAMOUNT || ', STATUS: ' || rec.STATUS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Delete_Bill Error: ' || SQLERRM);
    END;
 
    -- =======================
    -- USAGELOG Table Tests
    -- =======================
    DBMS_OUTPUT.PUT_LINE('--- Testing USAGELOG Procedures ---');
 
    -- Test Insert_UsageLog
    BEGIN
        Usage_Billing_Pkg.Insert_UsageLog(1, SYSTIMESTAMP - INTERVAL '2' HOUR, SYSTIMESTAMP, 2.5, 2, 500.25);
        DBMS_OUTPUT.PUT_LINE('Inserted UsageLog for AllocationID 1');
        DBMS_OUTPUT.PUT_LINE('--- Verifying USAGELOG Table After Insert ---');
        FOR rec IN (SELECT * FROM USAGELOG) LOOP
            DBMS_OUTPUT.PUT_LINE('LOGID: ' || rec.LOGID || ', ALLOCATIONID: ' || rec.ALLOCATIONID || ', USAGEAMOUNT: ' || rec.USAGEAMOUNT || ', TOTALCOST: ' || rec.TOTALCOST);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_UsageLog Error: ' || SQLERRM);
    END;
 
    -- Test Update_UsageLog
    BEGIN
        Usage_Billing_Pkg.Update_UsageLog(4, 1, SYSTIMESTAMP - INTERVAL '4' HOUR, SYSTIMESTAMP - INTERVAL '2' HOUR, 4.0, 2, 800.50);
        DBMS_OUTPUT.PUT_LINE('Updated UsageLogID 1 with new UsageAmount and TotalCost');
        DBMS_OUTPUT.PUT_LINE('--- Verifying USAGELOG Table After Update ---');
        FOR rec IN (SELECT * FROM USAGELOG) LOOP
            DBMS_OUTPUT.PUT_LINE('LOGID: ' || rec.LOGID || ', ALLOCATIONID: ' || rec.ALLOCATIONID || ', USAGEAMOUNT: ' || rec.USAGEAMOUNT || ', TOTALCOST: ' || rec.TOTALCOST);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Update_UsageLog Error: ' || SQLERRM);
    END;
 
    -- Test Delete_UsageLog
    BEGIN
        Usage_Billing_Pkg.Delete_UsageLog(11);
        DBMS_OUTPUT.PUT_LINE('Deleted UsageLogID 1');
        DBMS_OUTPUT.PUT_LINE('--- Verifying USAGELOG Table After Delete ---');
        FOR rec IN (SELECT * FROM USAGELOG) LOOP
            DBMS_OUTPUT.PUT_LINE('LOGID: ' || rec.LOGID || ', ALLOCATIONID: ' || rec.ALLOCATIONID || ', USAGEAMOUNT: ' || rec.USAGEAMOUNT || ', TOTALCOST: ' || rec.TOTALCOST);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Delete_UsageLog Error: ' || SQLERRM);
    END;
 
    DBMS_OUTPUT.PUT_LINE('===== Testing Completed =====');
END;
/