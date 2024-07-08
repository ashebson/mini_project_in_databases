/*markdown
# MySQL Functions
*/

/*markdown
## Define Functions
*/

DROP FUNCTION IF EXISTS calculate_mean_transfer;

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

DROP PROCEDURE IF EXISTS create_birthday_transfers

CREATE PROCEDURE create_birthday_transfers(
    IN transfer_amount DECIMAL(10, 2),
    IN transfer_description VARCHAR(255)
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE person_id INT;

    -- Declare a cursor to select people with birthdays today
    DECLARE birthday_cursor CURSOR FOR
    SELECT person_id
    FROM PERSON
    WHERE DATE_FORMAT(date_of_birth, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d');
    -- Declare a NOT FOUND handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    -- Open the cursor
    OPEN birthday_cursor;
    -- Loop through all the people with birthdays today
    read_loop: LOOP
        FETCH birthday_cursor INTO person_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
            -- Insert the bank transfer for each person
        INSERT INTO BANK_TRANSFER (person_id, amount, transfer_date, description, outgoing)
        VALUES (person_id, transfer_amount, CURDATE(), transfer_description, 1);
    END LOOP;
        -- Close the cursor
    CLOSE birthday_cursor;
END

/*markdown
# Run Query
*/

SELECT PERSON_ID, calculate_mean_transfer(PERSON_ID) FROM PERSON

CALL create_birthday_transfers(100.00, 'Birthday Gift');

SELECT PERSON_ID, calculate_mean_transfer(PERSON_ID) FROM PERSON