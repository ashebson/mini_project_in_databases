/*markdown
# MySQL Functions
*/

/*markdown
## Get Person's Transfer Deviance
*/

DROP PROCEDURE IF EXISTS calculate_mean_transfer;

CREATE FUNCTION calculate_mean_transfer(person_id_param INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total_amount FLOAT;
    DECLARE total_transfers INT;
    DECLARE mean_amount FLOAT;
    
    -- Calculate total amount and number of transfers
    SELECT SUM(amount), COUNT(*)
    INTO total_amount, total_transfers
    FROM BANK_TRANSFER
    WHERE person_id = person_id_param;
    
    -- Calculate mean amount
    IF total_transfers > 0 THEN
        SET mean_amount = total_amount / total_transfers;
    ELSE
        SET mean_amount = NULL; -- Handle case where no transfers exist
    END IF;
    
    RETURN mean_amount;
END

SELECT PERSON_ID, calculate_mean_transfer(PERSON_ID) FROM PERSON

DROP PROCEDURE IF EXISTS calculate_mean_transfer;

CREATE FUNCTION calculate_stddev_person_transfers(person_id_param INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE mean_amount FLOAT;
    DECLARE sst FLOAT;
    DECLARE total_transfers INT;
    DECLARE variance FLOAT;
    DECLARE stddev FLOAT;
    
    -- Calculate mean amount using the mean function
    SET mean_amount = calculate_mean_transfer(person_id_param);
    
    -- Get the total number of transfers
    SELECT COUNT(*)
    INTO total_transfers
    FROM BANK_TRANSFER
    WHERE person_id = person_id_param;
    
    -- If no transfers, return NULL
    IF total_transfers = 0 THEN
        RETURN NULL;
    END IF;
    
    -- Calculate SST (Sum of Squared Totals) directly
    SELECT SUM(POWER(amount - mean_amount, 2))
    INTO sst
    FROM BANK_TRANSFER
    WHERE person_id = person_id_param;
    
    -- Calculate variance
    SET variance = sst / total_transfers;
    
    -- Calculate standard deviation
    SET stddev = SQRT(variance);
    
    RETURN stddev;
END

SELECT PERSON_ID, calculate_stddev_person_transfers(PERSON_ID) FROM PERSON