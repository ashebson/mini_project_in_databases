/*markdown
# Define Functions
*/

DROP FUNCTION IF EXISTS calculate_stddev_person_transfers;

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

DROP PROCEDURE IF EXISTS calculate_and_pay_professors;

CREATE PROCEDURE calculate_and_pay_professors()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE professor_id INT;
    DECLARE course_id INT;
    DECLARE weekly_hours INT;
    DECLARE professor_pay DECIMAL(10, 2);
    DECLARE total_pay DECIMAL(10, 2);
    DECLARE paid_amount DECIMAL(10, 2);
    DECLARE balance DECIMAL(10, 2);
    -- Declare a cursor to select all professors
    DECLARE professor_cursor CURSOR FOR
    SELECT p.person_id, pc.course_id, pc.weekly_hours, c.professor_pay
    FROM PROFESSOR p
    JOIN PROFESSOR_COURSE pc ON p.person_id = pc.professor_id
    JOIN COURSE c ON pc.course_id = c.course_id;
    -- Declare a NOT FOUND handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    -- Open the cursor
    OPEN professor_cursor;
    -- Loop through all professors
    read_loop: LOOP
        FETCH professor_cursor INTO professor_id, course_id, weekly_hours, professor_pay;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- Calculate total pay based on weekly hours
        SET total_pay = weekly_hours * professor_pay;
        -- Calculate paid amount for the professor
        SELECT COALESCE(SUM(amount), 0)
        INTO paid_amount
        FROM BANK_TRANSFER
        WHERE person_id = professor_id;
        -- Calculate balance
        SET balance = total_pay - paid_amount;
        -- Pay the professor if balance is greater than zero
        IF balance > 0 THEN
            INSERT INTO BANK_TRANSFER (person_id, amount, transfer_date, description, outgoing)
            VALUES (professor_id, balance, CURDATE(), 'Payment for teaching course', 1);
        END IF;
    END LOOP;
    -- Close the cursor
    CLOSE professor_cursor;
END

/*markdown
# Run Queries
*/

SELECT PERSON_ID, calculate_stddev_person_transfers(PERSON_ID) FROM PERSON

CALL calculate_and_pay_professors();

SELECT PERSON_ID, calculate_stddev_person_transfers(PERSON_ID) FROM PERSON