-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

CONNECT user_b/password_b;
BEGIN
    DBMS_OUTPUT.PUT_LINE('===== Testing Resource Management Package =====');
 
    -- =======================
    -- RESOURCETYPE Table Procedure Tests
    -- =======================
    DBMS_OUTPUT.PUT_LINE('--- Testing RESOURCETYPE Procedures ---');
    BEGIN
        Resource_Management_Pkg.Insert_ResourceType('Storage', 'Cloud storage', 'Yes'); -- Valid
        DBMS_OUTPUT.PUT_LINE('Inserted ResourceType: Storage');
        FOR rec IN (SELECT * FROM RESOURCETYPE) LOOP
            DBMS_OUTPUT.PUT_LINE('RESOURCETYPEID: ' || rec.RESOURCETYPEID || ', TYPENAME: ' || rec.TYPENAME || ', DESC: ' || rec.DESCRIPTION || ', ELIGIBLE: ' || rec.ELIGIBLEFORPROMOTION);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_ResourceType Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Insert_ResourceType(NULL, 'Null Type', 'Yes'); -- Null TypeName
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_ResourceType with NULL TypeName Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Insert_ResourceType('Compute', 'Invalid Promotion', 'Invalid'); -- Invalid Promotion Value
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_ResourceType with Invalid Promotion Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Update_ResourceType(1, 'Updated Storage', 'Updated Description', 'No'); -- Valid
        DBMS_OUTPUT.PUT_LINE('Updated ResourceTypeID 1 to Updated Storage');
        FOR rec IN (SELECT * FROM RESOURCETYPE) LOOP
            DBMS_OUTPUT.PUT_LINE('RESOURCETYPEID: ' || rec.RESOURCETYPEID || ', TYPENAME: ' || rec.TYPENAME || ', ELIGIBLE: ' || rec.ELIGIBLEFORPROMOTION);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Update_ResourceType Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Delete_ResourceType(1); -- Valid
        DBMS_OUTPUT.PUT_LINE('Deleted ResourceTypeID 1');
        FOR rec IN (SELECT * FROM RESOURCETYPE) LOOP
            DBMS_OUTPUT.PUT_LINE('RESOURCETYPEID: ' || rec.RESOURCETYPEID || ', TYPENAME: ' || rec.TYPENAME || ', ELIGIBLE: ' || rec.ELIGIBLEFORPROMOTION);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Delete_ResourceType Error: ' || SQLERRM);
    END;
 
    -- =======================
    -- RESOURCETABLE Procedure Tests
    -- =======================
    DBMS_OUTPUT.PUT_LINE('--- Testing RESOURCETABLE Procedures ---');
    BEGIN
        Resource_Management_Pkg.Insert_Resource(2, 100, 'Available', 50, 10, 'Zone A'); -- Valid
        DBMS_OUTPUT.PUT_LINE('Inserted Resource for ResourceTypeID 1');
        FOR rec IN (SELECT * FROM RESOURCETABLE) LOOP
            DBMS_OUTPUT.PUT_LINE('RESOURCEID: ' || rec.RESOURCEID || ', STATUS: ' || rec.STATUS || ', ZONE: ' || rec.ZONE);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_Resource Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Update_Resource(2, 1, 300, 'In Use', 40, 5, 'Zone B'); -- Valid
        DBMS_OUTPUT.PUT_LINE('Updated ResourceID 1');
        FOR rec IN (SELECT * FROM RESOURCETABLE) LOOP
            DBMS_OUTPUT.PUT_LINE('RESOURCEID: ' || rec.RESOURCEID || ', STATUS: ' || rec.STATUS || ', ZONE: ' || rec.ZONE);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Update_Resource Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Delete_Resource(2); -- Valid
        DBMS_OUTPUT.PUT_LINE('Deleted ResourceID 1');
        FOR rec IN (SELECT * FROM RESOURCETABLE) LOOP
            DBMS_OUTPUT.PUT_LINE('RESOURCEID: ' || rec.RESOURCEID || ', STATUS: ' || rec.STATUS || ', ZONE: ' || rec.ZONE);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Delete_Resource Error: ' || SQLERRM);
    END;
 
    -- =======================
    -- RESOURCEALLOCATION Table Tests
    -- =======================
    DBMS_OUTPUT.PUT_LINE('--- Testing RESOURCEALLOCATION Procedures ---');
    BEGIN
        Resource_Management_Pkg.Insert_ResourceAllocation(
            p_ClientID => 8,
            p_ResourceID => 8,
            p_Status => 'Pending',
            p_AllocationDate => SYSDATE,
            p_ExpirationDate => SYSDATE + 30
        ); -- Valid
        DBMS_OUTPUT.PUT_LINE('Inserted Resource Allocation for ClientID 2 and ResourceID 1');
        -- Display table contents
        FOR rec IN (SELECT * FROM RESOURCEALLOCATION) LOOP
            DBMS_OUTPUT.PUT_LINE('ALLOCATIONID: ' || rec.ALLOCATIONID || ', CLIENTID: ' || rec.CLIENTID || 
                                 ', RESOURCEID: ' || rec.RESOURCEID || ', STATUS: ' || rec.STATUS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_ResourceAllocation Error: ' || SQLERRM);
    END;
    BEGIN
        Resource_Management_Pkg.Update_ResourceAllocation(
            p_AllocationID => 8,
            p_ClientID => 8,
            p_ResourceID => 8,
            p_Status => 'Approved',
            p_AllocationDate => SYSDATE,
            p_ExpirationDate => SYSDATE + 60
        ); -- Valid
        DBMS_OUTPUT.PUT_LINE('Updated AllocationID 1 to Approved');
        FOR rec IN (SELECT * FROM RESOURCEALLOCATION) LOOP
            DBMS_OUTPUT.PUT_LINE('ALLOCATIONID: ' || rec.ALLOCATIONID || ', STATUS: ' || rec.STATUS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Update_ResourceAllocation Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Delete_ResourceAllocation(p_AllocationID => 8); -- Valid
        DBMS_OUTPUT.PUT_LINE('Deleted AllocationID 1');
        FOR rec IN (SELECT * FROM RESOURCEALLOCATION) LOOP
            DBMS_OUTPUT.PUT_LINE('ALLOCATIONID: ' || rec.ALLOCATIONID || ', STATUS: ' || rec.STATUS);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Delete_ResourceAllocation Error: ' || SQLERRM);
    END;
 
    -- =======================
    -- PRICINGPLAN Table Procedure Tests
    -- =======================
    DBMS_OUTPUT.PUT_LINE('--- Testing PRICINGPLAN Procedures ---');
    BEGIN
        Resource_Management_Pkg.Insert_PricingPlan('Pro Plan', 'Professional Plan', 1); -- Valid
        DBMS_OUTPUT.PUT_LINE('Inserted PricingPlan: Pro Plan');
        FOR rec IN (SELECT * FROM PRICINGPLAN) LOOP
            DBMS_OUTPUT.PUT_LINE('PLANID: ' || rec.PLANID || ', PLANNAME: ' || rec.PLANNAME);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Insert_PricingPlan Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Update_PricingPlan(1, 'Pro Plan Updated', 'Updated Professional Plan'); -- Valid
        DBMS_OUTPUT.PUT_LINE('Updated PlanID 1');
        FOR rec IN (SELECT * FROM PRICINGPLAN) LOOP
            DBMS_OUTPUT.PUT_LINE('PLANID: ' || rec.PLANID || ', PLANNAME: ' || rec.PLANNAME);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Update_PricingPlan Error: ' || SQLERRM);
    END;
 
    BEGIN
        Resource_Management_Pkg.Delete_PricingPlan(1); -- Valid
        DBMS_OUTPUT.PUT_LINE('Deleted PlanID 1');
        FOR rec IN (SELECT * FROM PRICINGPLAN) LOOP
            DBMS_OUTPUT.PUT_LINE('PLANID: ' || rec.PLANID || ', PLANNAME: ' || rec.PLANNAME);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Delete_PricingPlan Error: ' || SQLERRM);
    END;
 
    DBMS_OUTPUT.PUT_LINE('===== Testing Completed =====');
END;
/
