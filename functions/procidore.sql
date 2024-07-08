DELIMITER //

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
END //

DELIMITER ;

CALL create_birthday_transfers(100.00, 'Birthday Gift');











DELIMITER //

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
END //

DELIMITER ;


CALL calculate_and_pay_professors();



