-- Clear existing data to avoid duplication
DELETE FROM USAGELOG;
COMMIT;
DELETE FROM BILL;
COMMIT;
DELETE FROM RESOURCEALLOCATION;
COMMIT;
DELETE FROM RESOURCETABLE;
COMMIT;
DELETE FROM PRICINGDETAIL;
COMMIT;
DELETE FROM PRICINGPLAN;
COMMIT;
DELETE FROM RESOURCETYPE;
COMMIT;
DELETE FROM CLIENT;
COMMIT;
DELETE FROM USERTABLE;
COMMIT;
DELETE FROM STATE_REGION_MAPPING;
COMMIT;
DELETE FROM REGION;
COMMIT;
DELETE FROM ROLE;
COMMIT;
 
-- Insert data into ROLE table
INSERT INTO ROLE (ROLENAME, PERMISSIONS) VALUES ('Admin', 'ALL');
INSERT INTO ROLE (ROLENAME, PERMISSIONS) VALUES ('Client', 'VIEW_OWN_DATA');
INSERT INTO ROLE (ROLENAME, PERMISSIONS) VALUES ('Resource Manager', 'MANAGE_RESOURCES');
INSERT INTO ROLE (ROLENAME, PERMISSIONS) VALUES ('Regional Manager', 'VIEW_REGION_DATA');
-- Insert data into USERTABLE
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('crms_admin', 'CrmsAdmin#123', 1);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('resource_manager', 'ResourceManager123#', 2);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('regional_manager', 'RegionManager123#', 3);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('Client1', 'ClientUser123#', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('jsmith2', 'ClientPass#234', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('ajohnson3', 'ClientPass#345', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('bbrown4', 'ClientPass#456', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('cdavis5', 'ClientPass#567', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('dwilson6', 'ClientPass#678', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('etaylor7', 'ClientPass#789', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('fanderson8', 'ClientPass#890', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ( 'gthomas9', 'ClientPass#901', 4);
INSERT INTO USERTABLE (USERNAME, PASSWORD, ROLEID) VALUES ('hmartinez10', 'ClientPass#012', 4);
 
 
-- Insert data into REGION table
INSERT INTO REGION (REGION_NAME) VALUES ('West');
INSERT INTO REGION (REGION_NAME) VALUES ('South');
INSERT INTO REGION (REGION_NAME) VALUES ('Midwest');
INSERT INTO REGION (REGION_NAME) VALUES ('Northeast');
 
-- Insert data into STATE_REGION_MAPPING table
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('CA', 1); -- West
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('AZ', 1); -- West
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('TX', 2); -- South
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('FL', 2); -- South
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('GA', 2); -- South
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('NC', 2); -- South
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('IL', 3); -- Midwest
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('OH', 3); -- Midwest
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('NY', 4); -- Northeast
INSERT INTO STATE_REGION_MAPPING (STATE_CODE, REGION_ID) VALUES ('PA', 4); -- Northeast
 
-- Insert data into CLIENT table
INSERT INTO CLIENT (FIRSTNAME, LASTNAME, EMAIL, PHONENUMBER, COMPANYNAME, STREET, STATE, CITY, ZIPCODE, USERID) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', 'Doe Corp', '123 Main St', 'CA', 'Los Angeles', '90001', 4),
('Jane', 'Smith', 'jane.smith@example.com', '2345678901', 'Smith LLC', '456 Elm St', 'TX', 'Houston', '77001', 5),
('Alice', 'Johnson', 'alice.johnson@example.com', '3456789012', 'Johnson Inc', '789 Oak St', 'NY', 'New York', '10001', 6),
('Bob', 'Brown', 'bob.brown@example.com', '4567890123', 'Brown LLC', '101 Pine St', 'FL', 'Miami', '33101', 7),
('Charlie', 'Davis', 'charlie.davis@example.com', '5678901234', 'Davis Corp', '202 Maple St', 'IL', 'Chicago', '60601', 8),
('Diana', 'Wilson', 'diana.wilson@example.com', '6789012345', 'Wilson LLC', '303 Cedar St', 'GA', 'Atlanta', '30301', 9),
('Eve', 'Taylor', 'eve.taylor@example.com', '7890123456', 'Taylor Inc', '404 Birch St', 'NC', 'Charlotte', '28201', 10),
('Frank', 'Anderson', 'frank.anderson@example.com', '8901234567', 'Anderson LLC', '505 Walnut St', 'AZ', 'Phoenix', '85001', 11),
('Grace', 'Thomas', 'grace.thomas@example.com', '9012345678', 'Thomas Corp', '606 Cherry St', 'PA', 'Philadelphia', '19101', 12),
('Henry', 'Martinez', 'henry.martinez@example.com', '0123456789', 'Martinez Inc', '707 Poplar St', 'OH', 'Columbus', '43201', 13);
 
-- Insert data into PRICINGPLAN table
INSERT INTO PRICINGPLAN (PLANNAME, DESCRIPTION) VALUES
('Standard', 'Standard pricing plan'),
('Premium', 'Premium pricing plan'),
('Basic', 'Basic pricing plan'),
('Enterprise', 'Enterprise pricing plan'),
('Economy', 'Economy pricing plan'),
('Deluxe', 'Deluxe pricing plan'),
('Unlimited', 'Unlimited usage plan'),
('Starter', 'Starter pricing plan'),
('Professional', 'Professional pricing plan'),
('Custom', 'Custom pricing plan');
 
-- Insert data into RESOURCETYPE table
INSERT INTO RESOURCETYPE (TYPENAME, DESCRIPTION, ELIGIBLEFORPROMOTION) VALUES
('Compute', 'Compute resources', 'Yes'),
('Storage', 'Storage resources', 'Yes'),
('Network', 'Networking resources', 'No'),
('Database', 'Database resources', 'Yes'),
('AI/ML', 'AI/ML resources', 'Yes'),
('Analytics', 'Analytics resources', 'No'),
('IoT', 'IoT devices and services', 'Yes'),
('Security', 'Security resources', 'No'),
('Backup', 'Backup resources', 'Yes'),
('DevOps', 'DevOps resources', 'No');
 
-- Insert data into PRICINGDETAIL table
INSERT INTO PRICINGDETAIL (PLANID, RESOURCETYPEID, UNITPRICE) VALUES
(1, 1, 0.10),
(2, 2, 0.20),
(3, 3, 0.15),
(4, 4, 0.30),
(5, 5, 0.50),
(6, 6, 0.25),
(7, 7, 0.40),
(8, 8, 0.35),
(9, 9, 0.45),
(10, 10, 0.55);
 
-- Insert data into RESOURCETABLE
INSERT INTO RESOURCETABLE (RESOURCETYPEID, CAPACITY, STATUS, QUANTITYONHAND, THRESHOLDVALUE, ZONE) VALUES
(1, 100, 'Available', 80, 20, 'Zone A'),
(2, 200, 'In Use', 150, 50, 'Zone B'),
(3, 300, 'Maintenance', 250, 75, 'Zone C'),
(4, 400, 'Available', 350, 100, 'Zone D'),
(5, 500, 'Unavailable', 450, 120, 'Zone E'),
(6, 600, 'Available', 500, 150, 'Zone F'),
(7, 700, 'In Use', 650, 200, 'Zone G'),
(8, 800, 'Maintenance', 700, 225, 'Zone H'),
(9, 900, 'Available', 750, 250, 'Zone I'),
(10, 1000, 'Unavailable', 800, 275, 'Zone J');
 
-- Insert data into RESOURCEALLOCATION table
INSERT INTO RESOURCEALLOCATION (CLIENTID, RESOURCEID, REQUESTDATE, ALLOCATIONDATE, EXPIRATIONDATE, STATUS) VALUES
(1, 1, SYSDATE - 10, SYSDATE - 9, SYSDATE - 1, 'Expired'),
(2, 2, SYSDATE - 8, SYSDATE - 7, SYSDATE + 10, 'Approved'),
(3, 3, SYSDATE - 6, SYSDATE - 5, SYSDATE + 15, 'Approved'),
(4, 4, SYSDATE - 4, SYSDATE - 3, SYSDATE + 20, 'Approved'),
(5, 5, SYSDATE - 2, SYSDATE - 1, SYSDATE + 25, 'Approved'),
(6, 6, SYSDATE - 12, SYSDATE - 10, SYSDATE - 2, 'Expired'),
(7, 7, SYSDATE - 9, SYSDATE - 8, SYSDATE + 5, 'Pending'),
(8, 8, SYSDATE - 15, SYSDATE - 12, SYSDATE + 8, 'Rejected'),
(9, 9, SYSDATE - 5, SYSDATE - 4, SYSDATE + 12, 'Approved'),
(10, 10, SYSDATE - 3, SYSDATE - 2, SYSDATE + 14, 'Approved');
 
-- Insert data into BILL table
INSERT INTO BILL (BILLPERIODSTART, BILLPERIODEND, TOTALAMOUNT, STATUS) VALUES
(SYSDATE - 30, SYSDATE - 1, 100.50, 'Paid'),
(SYSDATE - 60, SYSDATE - 30, 200.75, 'Unpaid'),
(SYSDATE - 90, SYSDATE - 60, 150.25, 'Pending'),
(SYSDATE - 120, SYSDATE - 90, 180.00, 'Paid'),
(SYSDATE - 150, SYSDATE - 120, 220.40, 'Unpaid'),
(SYSDATE - 180, SYSDATE - 150, 175.60, 'Pending'),
(SYSDATE - 210, SYSDATE - 180, 125.50, 'Paid'),
(SYSDATE - 240, SYSDATE - 210, 300.75, 'Unpaid'),
(SYSDATE - 270, SYSDATE - 240, 275.90, 'Pending'),
(SYSDATE - 300, SYSDATE - 270, 350.30, 'Paid');
 
-- Insert data into USAGELOG table
INSERT INTO USAGELOG (ALLOCATIONID, STARTTIME, ENDTIME, USAGEAMOUNT, BILLID, TOTALCOST) VALUES
(1, SYSDATE - 1, SYSDATE, 10, 1, 1.00),
(2, SYSDATE - 2, SYSDATE - 1, 15, 2, 3.00),
(3, SYSDATE - 3, SYSDATE - 2, 20, 3, 4.50),
(4, SYSDATE - 4, SYSDATE - 3, 25, 4, 5.00),
(5, SYSDATE - 5, SYSDATE - 4, 30, 5, 6.00),
(6, SYSDATE - 6, SYSDATE - 5, 35, 6, 7.50),
(7, SYSDATE - 7, SYSDATE - 6, 40, 7, 8.50),
(8, SYSDATE - 8, SYSDATE - 7, 45, 8, 9.00),
(9, SYSDATE - 9, SYSDATE - 8, 50, 9, 10.50),
(10, SYSDATE - 10, SYSDATE - 9, 55, 10, 11.00);
 
 
COMMIT;