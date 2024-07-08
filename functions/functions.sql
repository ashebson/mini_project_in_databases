/*markdown
# MySQL Functions
*/

DROP FUNCTION IF EXISTS get_transfer_stddev;
CREATE FUNCTION get_transfer_stddev(pid INT) 
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE mean_amount FLOAT;
    DECLARE variance FLOAT;
    DECLARE stddev_amount FLOAT;
    DECLARE n INT;

    -- Calculate mean amount
    SELECT AVG(amount) INTO mean_amount
    FROM BANK_TRANSFER
    WHERE person_id = pid;

    -- Calculate number of transfers
    SELECT COUNT(*) INTO n
    FROM BANK_TRANSFER
    WHERE person_id = pid;

    -- If there are no transfers, return NULL
    IF n = 0 THEN
        RETURN NULL;
    END IF;

    -- Calculate variance
    SELECT SUM(POW(amount - mean_amount, 2)) / n INTO variance
    FROM BANK_TRANSFER
    WHERE person_id = pid;

    -- Calculate standard deviation
    SET stddev_amount = SQRT(variance);

    RETURN stddev_amount;
END

SELECT PERSON_ID, get_transfer_stddev(PERSON_ID) FROM PERSON