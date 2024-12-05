-- Enable DBMS_OUTPUT

SET SERVEROUTPUT ON;
 

BEGIN

    DBMS_OUTPUT.PUT_LINE('===== Testing Client Management Package =====');
 
    -- =======================

    -- ROLE Table Tests

    -- =======================

    DBMS_OUTPUT.PUT_LINE('--- Testing ROLE Procedures ---');

    BEGIN

        -- Valid Insert

        Client_Management_Pkg.Insert_Role('TestRole', 'ALL_PRIVILEGES');

        DBMS_OUTPUT.PUT_LINE('Inserted Role: TestRole');

        -- Duplicate RoleName

        Client_Management_Pkg.Insert_Role('TestRole', 'RESTRICTED_ACCESS');

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Insert_Role Error: ' || SQLERRM);

    END;
 
    -- Print ROLE Table

    FOR rec IN (SELECT * FROM ROLE) LOOP

        DBMS_OUTPUT.PUT_LINE('ROLEID: ' || rec.ROLEID || ', ROLENAME: ' || rec.ROLENAME || ', PERMISSIONS: ' || rec.PERMISSIONS);

    END LOOP;
 
    BEGIN

        -- Update Valid Role

        Client_Management_Pkg.Update_Role(1, 'UpdatedAdmin', 'RESTRICTED_ACCESS');

        DBMS_OUTPUT.PUT_LINE('Updated RoleID 1 to UpdatedAdmin');

        -- Invalid RoleID

        Client_Management_Pkg.Update_Role(999, 'InvalidRole', 'NO_ACCESS');

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Update_Role Error: ' || SQLERRM);

    END;
 
    -- Print ROLE Table

    FOR rec IN (SELECT * FROM ROLE) LOOP

        DBMS_OUTPUT.PUT_LINE('ROLEID: ' || rec.ROLEID || ', ROLENAME: ' || rec.ROLENAME || ', PERMISSIONS: ' || rec.PERMISSIONS);

    END LOOP;
 
    BEGIN

        -- Valid Delete

        Client_Management_Pkg.Delete_Role(1);

        DBMS_OUTPUT.PUT_LINE('Deleted RoleID 1');

        -- Non-existent RoleID

        Client_Management_Pkg.Delete_Role(999);

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Delete_Role Error: ' || SQLERRM);

    END;
 
    -- Print ROLE Table

    FOR rec IN (SELECT * FROM ROLE) LOOP

        DBMS_OUTPUT.PUT_LINE('ROLEID: ' || rec.ROLEID || ', ROLENAME: ' || rec.ROLENAME || ', PERMISSIONS: ' || rec.PERMISSIONS);

    END LOOP;
 
    -- =======================

    -- REGION Table Tests

    -- =======================

    DBMS_OUTPUT.PUT_LINE('--- Testing REGION Procedures ---');

    BEGIN

        -- Valid Insert

        Client_Management_Pkg.Insert_Region('TestRegion');

        DBMS_OUTPUT.PUT_LINE('Inserted Region: TestRegion');

        -- Duplicate RegionName

        Client_Management_Pkg.Insert_Region('TestRegion');

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Insert_Region Error: ' || SQLERRM);

    END;
 
    -- Print REGION Table

    FOR rec IN (SELECT * FROM REGION) LOOP

        DBMS_OUTPUT.PUT_LINE('REGION_ID: ' || rec.REGION_ID || ', REGION_NAME: ' || rec.REGION_NAME);

    END LOOP;
 
    BEGIN

        -- Update Valid Region

        Client_Management_Pkg.Update_Region(2, 'UpdatedRegion');

        DBMS_OUTPUT.PUT_LINE('Updated RegionID 2 to UpdatedRegion');

        -- Invalid RegionID

        Client_Management_Pkg.Update_Region(999, 'InvalidRegion');

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Update_Region Error: ' || SQLERRM);

    END;
 
    -- Print REGION Table

    FOR rec IN (SELECT * FROM REGION) LOOP

        DBMS_OUTPUT.PUT_LINE('REGION_ID: ' || rec.REGION_ID || ', REGION_NAME: ' || rec.REGION_NAME);

    END LOOP;
 
    BEGIN

        -- Valid Delete

        Client_Management_Pkg.Delete_Region(2);

        DBMS_OUTPUT.PUT_LINE('Deleted RegionID 2');

        -- Non-existent RegionID

        Client_Management_Pkg.Delete_Region(999);

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Delete_Region Error: ' || SQLERRM);

    END;
 
    -- Print REGION Table

    FOR rec IN (SELECT * FROM REGION) LOOP

        DBMS_OUTPUT.PUT_LINE('REGION_ID: ' || rec.REGION_ID || ', REGION_NAME: ' || rec.REGION_NAME);

    END LOOP;
 
    -- =======================

    -- STATE_REGION_MAPPING Table Tests

    -- =======================

    DBMS_OUTPUT.PUT_LINE('--- Testing STATE_REGION_MAPPING Procedures ---');

    BEGIN

        -- Valid Insert

        Client_Management_Pkg.Insert_State_Region('WA', 3);

        DBMS_OUTPUT.PUT_LINE('Inserted State-Region Mapping: WA -> RegionID 3');

        -- Invalid RegionID

        Client_Management_Pkg.Insert_State_Region('NY', 999);

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Insert_State_Region Error: ' || SQLERRM);

    END;
 
    -- Print STATE_REGION_MAPPING Table

    FOR rec IN (SELECT * FROM STATE_REGION_MAPPING) LOOP

        DBMS_OUTPUT.PUT_LINE('STATE_CODE: ' || rec.STATE_CODE || ', REGION_ID: ' || rec.REGION_ID);

    END LOOP;
 
    BEGIN

        -- Update Valid Mapping

        Client_Management_Pkg.Update_State_Region('WA', 4);

        DBMS_OUTPUT.PUT_LINE('Updated State-Region Mapping: WA -> RegionID 4');

        -- Non-existent StateCode

        Client_Management_Pkg.Update_State_Region('ZZ', 3);

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Update_State_Region Error: ' || SQLERRM);

    END;
 
    -- Print STATE_REGION_MAPPING Table

    FOR rec IN (SELECT * FROM STATE_REGION_MAPPING) LOOP

        DBMS_OUTPUT.PUT_LINE('STATE_CODE: ' || rec.STATE_CODE || ', REGION_ID: ' || rec.REGION_ID);

    END LOOP;
 
    BEGIN

        -- Valid Delete

        Client_Management_Pkg.Delete_State_Region('WA');

        DBMS_OUTPUT.PUT_LINE('Deleted State-Region Mapping: WA');

        -- Non-existent StateCode

        Client_Management_Pkg.Delete_State_Region('ZZ');

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Delete_State_Region Error: ' || SQLERRM);

    END;
 
    -- Print STATE_REGION_MAPPING Table

    FOR rec IN (SELECT * FROM STATE_REGION_MAPPING) LOOP

        DBMS_OUTPUT.PUT_LINE('STATE_CODE: ' || rec.STATE_CODE || ', REGION_ID: ' || rec.REGION_ID);

    END LOOP;
    
 
    -- =======================

    -- CLIENT Table Tests

    -- =======================

    DBMS_OUTPUT.PUT_LINE('--- Testing CLIENT Procedures ---');
    BEGIN

        -- Valid Insert

        Client_Management_Pkg.Insert_Client(

            'John', 'Doe', 'john.doe123@example.com', '1234567890', 'Doe Inc',

            '123 Main St', 'CA', 'Los Angeles', '90001', 2

        );

        DBMS_OUTPUT.PUT_LINE('Inserted Client: John Doe');

        -- Invalid UserID

        Client_Management_Pkg.Insert_Client(

            'Jane', 'Smith', 'jane.smith@example.com', '0987654321', 'Smith Corp',

            '456 Elm St', 'CA', 'San Francisco', '94016', 999

        );

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Insert_Client Error: ' || SQLERRM);

    END;
 
    -- Print CLIENT Table

    FOR rec IN (SELECT * FROM CLIENT) LOOP

        DBMS_OUTPUT.PUT_LINE('CLIENTID: ' || rec.CLIENTID || ', NAME: ' || rec.FIRSTNAME || ' ' || rec.LASTNAME);

    END LOOP;
 
    BEGIN

        -- Update Valid Client

        Client_Management_Pkg.Update_Client(1, 'UpdatedJohn', NULL, 'updated@example.com');

        DBMS_OUTPUT.PUT_LINE('Updated ClientID 1');

        -- Invalid ClientID

        Client_Management_Pkg.Update_Client(999, 'InvalidClient', NULL, 'invalid@example.com');

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Update_Client Error: ' || SQLERRM);

    END;
 
    -- Print CLIENT Table

    FOR rec IN (SELECT * FROM CLIENT) LOOP

        DBMS_OUTPUT.PUT_LINE('CLIENTID: ' || rec.CLIENTID || ', NAME: ' || rec.FIRSTNAME || ' ' || rec.LASTNAME);

    END LOOP;
 
    BEGIN

        -- Valid Delete

        Client_Management_Pkg.Delete_Client(1);

        DBMS_OUTPUT.PUT_LINE('Deleted ClientID 1');

        -- Non-existent ClientID

        Client_Management_Pkg.Delete_Client(999);

    EXCEPTION

        WHEN OTHERS THEN

            DBMS_OUTPUT.PUT_LINE('Delete_Client Error: ' || SQLERRM);

    END;
 
    -- Print CLIENT Table

    FOR rec IN (SELECT * FROM CLIENT) LOOP

        DBMS_OUTPUT.PUT_LINE('CLIENTID: ' || rec.CLIENTID || ', NAME: ' || rec.FIRSTNAME || ' ' || rec.LASTNAME);

    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('===== Testing Completed =====');

END;
/

 