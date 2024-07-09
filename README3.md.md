
# תוכנית 1

תוכנית שמשמשת לביצוע העברות יום הולדת ללומדי האוניברסטיה.

## פונקציות ופרוצדורות: 

פונקציה שמחשבת את ממוצע ההעברות לבן אדם. 
הפונקציה מחשבת את ממוצע סכומי ההעברות, פונקציה זו תשמש אותנו לעשות סטטיסטיקות על ההעברת של המשתמש השמשך.

```sql 

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
```


להלן פרוצדורה של מענקי יום הולדת, הפרוצדורה מוצאת את האנשי מערכת שיש להם יום הולדת היום ומוסיפה להם העברה על סך הפרמטר הנתון.
```sql

DROP PROCEDURE IF EXISTS create_birthday_transfers

CREATE PROCEDURE create_birthday_transfers(
    IN transfer_amount DECIMAL(10, 2),
    IN transfer_description VARCHAR(255)
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE person_id_val INT;
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
        FETCH birthday_cursor INTO person_id_val;
        IF done THEN
            LEAVE read_loop;
        END IF;
            -- Insert the bank transfer for each person
        INSERT INTO BANK_TRANSFER (person_id, amount, transfer_date, description, outgoing)
        VALUES (person_id_val, transfer_amount, CURDATE(), transfer_description, 1);
    END LOOP;
        -- Close the cursor
    CLOSE birthday_cursor;
END

```

## תוכנית ראשית לשימוש בפונקציה ובפרוצדורה:


חישוב ממוצע ההעברת של האנשים שיש להם יום הולדת היום. 
ביצוע העברות היום הולדת על סך 100 שח 
ולאחר מכן צפיה בשינוי שקרה לממוצע ההעברות של האנשים.

```sql

SELECT PERSON_ID, calculate_mean_transfer(PERSON_ID) FROM PERSON
WHERE DATE_FORMAT(date_of_birth, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d');

CALL create_birthday_transfers(100.00, 'Birthday Gift');

SELECT PERSON_ID, calculate_mean_transfer(PERSON_ID) FROM PERSON
WHERE DATE_FORMAT(date_of_birth, '%m-%d') = DATE_FORMAT(CURDATE(), '%m-%d')
```

# תוכנית 2

תוכנית לתשלום משכורות של מרצים. הפונקציה בסיסית והכרחית בכל מחלקת חשבונות.

## פונקציות ופרוצדורות

פונקציה לחישוב סטיית תקן של משכורות מרצים.
המידע ישמש את ההנהלה כדי להבין איזה מרצים עובדים בצורה קבועה ומסודרת והסטיית תקן שלהם נמוכה, ואיזה מרצים עובדים בצורה פחות יציבה ויותר משתנה וסטית התקן שלהם תהיה גבוהה. 


```sql
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

```

פרוצדורה שמשלמת למרצים בהינתן שעות הלימוד שלימדו אי פעם בקורסים ובניכוי המשכורות ששולמו להם בעבר. 


```sql

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
    DECLARE recieved_amount DECIMAL(10, 2);
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
        WHERE person_id = professor_id
        AND outgoing = 1;
        
        SELECT COALESCE(SUM(amount), 0)
        INTO recieved_amount
        FROM BANK_TRANSFER
        WHERE person_id = professor_id
        AND outgoing = 0;
        
        -- Calculate balance
        SET balance = total_pay + recieved_amount - paid_amount;
        -- Pay the professor if balance is greater than zero
        IF balance > 0 THEN
            INSERT INTO BANK_TRANSFER (person_id, amount, transfer_date, description, outgoing)
            VALUES (professor_id, balance, CURDATE(), 'Payment for teaching course', 1);
        END IF;
    END LOOP;
    -- Close the cursor
    CLOSE professor_cursor;
END

```

## תוכנית ראשית
צפייה בממוצע וסטיית התקן של המרצים לפני ואחרי תשלום המשכורות:
```sql

SELECT PERSON_ID as professor, calculate_mean_transfer(PERSON_ID) as avarage, calculate_stddev_person_transfers(PERSON_ID) as deviation FROM PERSON
WHERE PERSON_ID IN (SELECT person_id FROM PROFESSOR)

CALL calculate_and_pay_professors();

SELECT PERSON_ID as professor, calculate_mean_transfer(PERSON_ID) as avarage, calculate_stddev_person_transfers(PERSON_ID) as deviation FROM PERSON
WHERE PERSON_ID IN (SELECT person_id FROM PROFESSOR)
```