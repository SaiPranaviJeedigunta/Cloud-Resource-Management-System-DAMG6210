CREATE OR REPLACE TRIGGER Resource_Allocation_Trigger
BEFORE INSERT ON RESOURCEALLOCATION
FOR EACH ROW
DECLARE
    current_quantity NUMBER;
    threshold_value NUMBER;
BEGIN
    -- Get the current quantity and threshold value of the allocated resource
    SELECT QUANTITYONHAND, THRESHOLDVALUE
    INTO current_quantity, threshold_value
    FROM RESOURCETABLE
    WHERE RESOURCEID = :NEW.RESOURCEID;

    -- Check if quantity is below or equal to zero
    IF current_quantity <= 0 THEN
        -- Set the allocation status to 'Pending'
        :NEW.STATUS := 'Pending';

        -- Log an error message for no available resources
        DBMS_OUTPUT.PUT_LINE('No resources available. Allocation status set to Pending.');

    -- Check if quantity is below threshold
    ELSIF current_quantity < threshold_value THEN
        -- Set the allocation status to 'Approved'
        :NEW.STATUS := 'Approved';

        -- Decrement the quantity on hand for approved allocation
        UPDATE RESOURCETABLE
        SET QUANTITYONHAND = QUANTITYONHAND - 1
        WHERE RESOURCEID = :NEW.RESOURCEID;

        -- Log a warning about low stock
        DBMS_OUTPUT.PUT_LINE('Warning: Quantity on hand is below the threshold value.');

    ELSE
        -- Set the allocation status to 'Approved' for sufficient stock
        :NEW.STATUS := 'Approved';

        -- Decrement the quantity on hand for approved allocation
        UPDATE RESOURCETABLE
        SET QUANTITYONHAND = QUANTITYONHAND - 1
        WHERE RESOURCEID = :NEW.RESOURCEID;
    END IF;
END;
/


---- Trigger for Auto-Updating Total Cost in BILL Table
CREATE OR REPLACE TRIGGER Update_Bill_TotalCost
FOR INSERT OR UPDATE OR DELETE ON USAGELOG
COMPOUND TRIGGER

    -- Declare variables to store the affected BILLID
    TYPE BillID_Table IS TABLE OF NUMBER;
    affected_bills BillID_Table := BillID_Table();

    BEFORE EACH ROW IS
    BEGIN
        -- Collect affected BILLID
        IF :NEW.BILLID IS NOT NULL THEN
            affected_bills.EXTEND;
            affected_bills(affected_bills.LAST) := :NEW.BILLID;
        END IF;
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        -- Update the total cost for each affected BILLID
        FOR i IN 1 .. affected_bills.COUNT LOOP
            UPDATE BILL
            SET TOTALAMOUNT = (
                SELECT NVL(SUM(TOTALCOST), 0)
                FROM USAGELOG
                WHERE BILLID = affected_bills(i)
            )
            WHERE BILLID = affected_bills(i);

            DBMS_OUTPUT.PUT_LINE('Total cost updated for Bill ID: ' || affected_bills(i));
        END LOOP;
    END AFTER STATEMENT;

END Update_Bill_TotalCost;
/



------ Threshold Alert on Resource Update
CREATE OR REPLACE TRIGGER Threshold_Alert
AFTER UPDATE OF QUANTITYONHAND ON RESOURCETABLE
FOR EACH ROW
BEGIN
    IF :NEW.QUANTITYONHAND < :NEW.THRESHOLDVALUE THEN
        DBMS_OUTPUT.PUT_LINE('ALERT: Resource ID ' || :NEW.RESOURCEID || ' is below threshold!');
    END IF;
END;
/