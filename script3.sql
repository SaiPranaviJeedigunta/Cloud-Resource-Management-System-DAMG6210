-- Drop the jdoe1 if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP USER jdoe1 CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/

-- Create jdoe1 with a compliant password
CREATE USER jdoe1 IDENTIFIED BY "ClientUser123#";

-- Grant essential privileges directly
GRANT CREATE SESSION TO jdoe1;

-- Grant access to specific tables for managing their own records
GRANT INSERT, UPDATE, DELETE ON CLIENT TO jdoe1;
GRANT INSERT, UPDATE, DELETE ON RESOURCEALLOCATION TO jdoe1;
GRANT SELECT ON PRICINGPLAN TO jdoe1;
GRANT SELECT ON PRICINGDETAIL TO jdoe1;
GRANT SELECT ON RESOURCETYPE TO jdoe1;
GRANT SELECT ON RESOURCETABLE TO jdoe1;
GRANT SELECT ON RESOURCEALLOCATION TO jdoe1;
GRANT SELECT ON CLIENT TO jdoe1;
GRANT SELECT ON USAGELOG TO jdoe1;
GRANT SELECT ON BILL TO jdoe1;


-- Drop the resource_manager if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP USER resource_manager CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/

-- Create resource_manager with a compliant password
CREATE USER resource_manager IDENTIFIED BY "ResourceManager123#";

-- Grant essential privileges directly
GRANT CREATE SESSION TO resource_manager;

-- Grant CRUD access on resource-related tables
GRANT INSERT, UPDATE, DELETE ON RESOURCETABLE TO resource_manager;
GRANT INSERT, UPDATE, DELETE ON RESOURCETYPE TO resource_manager;
GRANT INSERT, UPDATE, DELETE ON PRICINGDETAIL TO resource_manager;
GRANT SELECT ON RESOURCETABLE TO resource_manager;
GRANT SELECT ON RESOURCETYPE TO resource_manager;
GRANT SELECT ON PRICINGDETAIL TO resource_manager;


-- Drop the regional_manager if it exists
BEGIN
    EXECUTE IMMEDIATE 'DROP USER regional_manager CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -1918 THEN
            RAISE;
        END IF;
END;
/

-- Create regional_manager with a compliant password
CREATE USER regional_manager IDENTIFIED BY "RegionManager123#";

-- Grant essential privileges directly
GRANT CREATE SESSION TO regional_manager;

-- Grant CRUD access for region-specific data
GRANT INSERT ON CLIENT TO regional_manager;
GRANT INSERT ON RESOURCEALLOCATION TO regional_manager;
GRANT UPDATE ON CLIENT TO regional_manager;
GRANT UPDATE ON RESOURCEALLOCATION TO regional_manager;
GRANT DELETE ON CLIENT TO regional_manager;
GRANT DELETE ON RESOURCEALLOCATION TO regional_manager;

-- Grant select access for tables within their region
GRANT SELECT ON PRICINGPLAN TO regional_manager;
GRANT SELECT ON PRICINGDETAIL TO regional_manager;
GRANT SELECT ON RESOURCETYPE TO regional_manager;
GRANT SELECT ON RESOURCETABLE TO regional_manager;
GRANT SELECT ON RESOURCEALLOCATION TO regional_manager;
GRANT SELECT ON CLIENT TO regional_manager;
GRANT SELECT ON USAGELOG TO regional_manager;
GRANT SELECT ON BILL TO regional_manager;
