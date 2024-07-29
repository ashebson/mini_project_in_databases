# מיני פרוייקט בבסיסי נתונים
**אריה שבסון 210033585 , ארז פולק 322768995**

מטרת הפרוייקט היא ליצג בסיס נתונים של מחלקת חשבונות של אוניברסיטה כלשהי. לצורך כך יש צורך בכמה טבלאות, על מנת לייצג את ההעברות הכספיות והחובות בין האוניברסיטה למרצים ולסטודנטים.
הפרוייקט מכיל 7 טבלאות.

# טבלאות

## טבלת אדם (PERSON)

טבלה זו מייצגת באופן מופשט אדם בעיני מחלקת החשבונות. בהמשך ניצור טבלאות המייצגות סוגי אנשים ספציפיים אשר ירשו מהטבלה הזו.


| Column        | Type    | Description              |
| ------------- | ------- | ------------------------ |
| person_id 🔑  | int     | מזהה חח״ע של אדם         |
| first_name    | varchar | השם הפרטי של האדם        |
| last_name     | varchar | שם המשפחה של האדם        |
| date_of_birth | date    | תאריך הלידה של האדם      |
| bank_account  | varchar | מספר חשבון הבנק של האדם  |
| national_id   | string  | מספר תעודת הזהות של האדם |

```sql
CREATE TABLE PERSON (
    person_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    bank_account VARCHAR(20),
    national_id VARCHAR(20)
);
```

## טבלת העברות בנקאיות (BANK_TRANSFER)

טבלה זו מייצגת העברה בנקאיות בין אדם לאוניברסיטה (או ההפך). העברה זו יכולה לייצג תשלום על קורס מסוים (או מספר קורסים), תשלום שכר למרצים, מענק לסטודנטים או כל העברה בנקאית שהיא.

| Column         | Type    | Description                                                                                              |
| -------------- | ------- | -------------------------------------------------------------------------------------------------------- |
| transfer_id 🔑 | int     | מזהה חח״ע של העברה                                                                                       |
| person_id 👽   | int     | מזהה של האדם איתו מבוצעת ההעברה                                                                          |
| amount         | float   | כמות הכסף בהעברה                                                                                         |
| transfer_date  | date    | תאריך ההעברה                                                                                             |
| description    | varchar | תיעור ההעברה (לדוגמא: עבור קורס מיני פרוייקט בבסיסי נתונים)                                              |
| incoming       | boolean | ערך בוליאני המייצג אם ההעברה היא **ל**אוניברסיטה (אם הערך הוא `False` משמע שההעברה היא **מ**האוניברסיטה) |

```sql
CREATE TABLE BANK_TRANSFER (
    transfer_id INT PRIMARY KEY,
    person_id INT,
    amount DECIMAL(10, 2),
    transfer_date DATE,
    description VARCHAR(255),
    outgoing BOOLEAN,
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);
```

## טבלת מרצה (PROFESSOR)

טבלה זו מייצגת מרצה באוניברסיטה. מרצה הוא אדם אשר מלמד קורסים ושייך למחלקה מסוימת.

| Column         | Type    | Description                   |
| -------------- | ------- | ----------------------------- |
| person_id 🔑👽 | int     | מזהה חח״ע של המרצה (מזהה אדם) |
| hire_date      | date    | התאריך שבו הועסק המרצה        |
| department     | varchar | המחלקה בה מלמד המרצה          |

```sql
CREATE TABLE PROFESSOR (
	person_id INT PRIMARY KEY,
	hire_date DATE,
	department VARCHAR(30),
	FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);
```

## טבלת סטודנט (STUDENT)

טבלה זו מייצגת סטודנט באוניברסיטה. סטודנט הוא אדם אשר לומד תואר מסוים ונרשם לקורסים בתואר הנבחר.

| Column         | Type    | Description                          |
| -------------- | ------- | ------------------------------------ |
| person_id 🔑👽 | int     | מזהה חח״ע של הסטודנט (מזהה אדם)      |
| signup_date    | date    | התאריך שבו התחיל הסטודנט את הלימודים |
| major          | varchar | התואר אותו לומד הסטודנט              |
```sql
CREATE TABLE STUDENT (
	person_id INT PRIMARY KEY,
	enrollment_date DATE,
	major VARCHAR(30),
	FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);
```
## טבלת קורס (COURSE)

טבלה זו מייצגת קורס באוניברסיטה. לכל קורס יש סטודנטים אשר לומדים אותו ולפחות מרצה אחד שמלמד אותו

| Column        | Type    | Description                                        |
| ------------- | ------- | -------------------------------------------------- |
| course_id 🔑  | int     | מזהה חח״ע של הקורס                                 |
| course_name   | varchar | השם של הקורס הנלמד                                 |
| course_cost   | float   | המחיר אותו משלם סטודנט הלומד את הקורס              |
| professor_pay | int     | המחיר אותו משלמת האוניברסיטה למרצה המעביר את הקורס |

```sql
CREATE TABLE COURSE (
	course_id INT PRIMARY KEY,
	course_name VARCHAR(100),
	course_cost DECIMAL(10, 2),
	professor_pay DECIMAL(10, 2)
);
```

## טבלת קורס-מרצה (PROFESSOR_COURSE)

טבלה זו מייצגת את הקשר בין מרצה לקורס אותו הוא מלמד

| Column            | Type | Description                                          |
| ----------------- | ---- | ---------------------------------------------------- |
| professor_id 🔑👽 | int  | מזהה חח״ע של המרצה המעביר את הקורס (מזהה אדם)        |
| course_id 🔑👽    | int  | מזהה חח״ע של הקורס                                   |
| weekly_hours      | int  | כמות השעות השבועיות אותם מלמד המרצה את הקורס המצויין |

```sql
CREATE TABLE PROFESSOR_COURSE (
    professor_id INT,
    course_id INT,
    weekly_hours INT,
    FOREIGN KEY (professor_id) REFERENCES PROFESSOR(person_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    PRIMARY KEY (professor_id, course_id)
);
```

## טבלת קורס-סטודנט (STUDENT_COURSE)

טבלה זו מייצגת את הקשר בין סטודנט לקורס אותו הוא לומד

| Column          | Type | Description                                    |
| --------------- | ---- | ---------------------------------------------- |
| student_id 🔑👽 | int  | מזהה חח״ע של הסטודנט הלומד את הקורס (מזהה אדם) |
| course_id 🔑👽  | int  | מזהה חח״ע של הקורס                             |
| signup_date     | date | התאריך בו נרשם הסטודנט לקורס                   |

```sql
CREATE TABLE STUDENT_COURSE (
	student_id INT,
	course_id INT,
	signup_date DATE,
	FOREIGN KEY (student_id) REFERENCES STUDENT(person_id),
	FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
	PRIMARY KEY (student_id, course_id)
);
```

# שאילתות

שאילתה המחזירה את 10 הקורסים, כך שסכום כל הכסף ששולם עבורם (עד כה) הוא הגבוהה ביותר

```sql
select course_name, sum_balance 
from COURSE natural join 
    (
        select course_id, sum(balance) as sum_balance 
        from STUDENT_COURSE natural join 
        (
            select person_id as student_id, pays.pay - debts.debt as balance from 
                (select person_id , sum(amount) as pay 
                from BANK_TRANSFER where outgoing = 0 
                group by person_id) as pays 
            natural join 
                (select person_id, sum(amount) as debt 
                from BANK_TRANSFER where outgoing = 1 
                group by person_id) as debts
        ) as person_balances 
        group by course_id 
        order by sum(balance) desc 
        limit 10
    ) as course_balances;
```

שאילתה המחזירה את 10 המרצים עם המשכורות הגבוהות ביותר

```sql
SELECT 
    p.person_id,
    p.first_name,
    p.last_name,
    SUM(c.professor_pay) AS total_salary
FROM 
    PROFESSOR pr
JOIN 
    PROFESSOR_COURSE pc ON pr.person_id = pc.professor_id
JOIN 
    COURSE c ON pc.course_id = c.course_id
JOIN 
    PERSON p ON pr.person_id = p.person_id
GROUP BY 
    p.person_id, p.first_name, p.last_name
ORDER BY 
    total_salary DESC
LIMIT 10;
```

שאילתה המחזירה את כמות הכסף שחייב כל סטודנט למכון

```sql
SELECT 
    s.person_id,
    p.first_name,
    p.last_name,
    IFNULL(SUM(bt.amount), 0) AS total_incoming_transfers,
    IFNULL(SUM(c.course_cost), 0) AS total_course_cost,
    IFNULL(SUM(bt.amount), 0) - IFNULL(SUM(c.course_cost), 0) AS net_amount
FROM 
    STUDENT s
JOIN 
    PERSON p ON s.person_id = p.person_id
LEFT JOIN 
    STUDENT_COURSE sc ON s.person_id = sc.student_id
LEFT JOIN 
    COURSE c ON sc.course_id = c.course_id
LEFT JOIN 
    BANK_TRANSFER bt ON s.person_id = bt.person_id AND bt.outgoing = FALSE
GROUP BY 
    s.person_id, p.first_name, p.last_name
ORDER BY 
    net_amount DESC;
```

שאילתה המחזירה את המרצים בני השלושים אשר הועסקו בשנת 2018

```sql
SELECT 
    bt.transfer_id,
    p.person_id,
    p.first_name,
    p.last_name,
    bt.amount,
    bt.transfer_date,
    bt.description,
    bt.outgoing
FROM 
    BANK_TRANSFER bt
JOIN 
    PERSON p ON bt.person_id = p.person_id
JOIN 
    PROFESSOR pr ON p.person_id = pr.person_id
WHERE 
    DATEDIFF(CURRENT_DATE, p.date_of_birth) / 365.25 > 30
    AND bt.transfer_date BETWEEN '2018-01-01' AND '2019-12-31';
```

שאילתה המוחקת העברות שבוצעו לפני יותר מ5 שנים

```sql
DELETE FROM 
    BANK_TRANSFER
WHERE 
    transfer_date <= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
```

שאילתה המוחקת קורסים שלא נלמדים או מלומדים ע״י אף אחד

```sql
DELETE FROM 
    COURSE
WHERE 
    course_id NOT IN (
        SELECT DISTINCT course_id
        FROM STUDENT_COURSE
        
        UNION
        
        SELECT DISTINCT course_id
        FROM PROFESSOR_COURSE
    );
```

שאילתה המשנה את סכום כל ההעברות שבוצעו לסטודנטים

```sql
-- cut by half all the outgoing transfares to students
UPDATE 
    BANK_TRANSFER
SET 
    amount = amount / 2
WHERE 
    outgoing = TRUE
    AND person_id IN (
        SELECT 
            person_id
        FROM 
            STUDENT
    );
```

שאילתה המשנה את השם של חוג לשם חדש

```sql
UPDATE 
    STUDENT
SET 
    major = 'Data Science'
WHERE 
    major = 'Information Technology';
```

שאילתה המחזירה את החוב של סטודנט מסוים לאוניברסיטה

```sql
SELECT
(
    -- amount owed by student
    SELECT SUM(COURSE_COST) FROM COURSE WHERE COURSE_ID IN (
        SELECT COURSE_ID FROM STUDENT_COURSE WHERE STUDENT_ID = {studentid}
    )
)
- 
(
    -- amount payed by student to university
    SELECT SUM(AMOUNT) FROM BANK_TRANSFER WHERE PERSON_ID = {studentid} AND OUTGOING = 0
)
+ 
(
    -- amount payed by university to student
    SELECT SUM(AMOUNT) FROM BANK_TRANSFER WHERE PERSON_ID = {studentid} AND OUTGOING = 1
) AS STUDENT_DEBT
```

שאילתה המחזירה את החוב של האוניברסיטה למרצה מסוים

```sql
SELECT
prof.PERSON_ID as pid,
(
    -- amount owed by university
    SELECT SUM(crs.PROFESSOR_PAY * prof_crs.WEEKLY_HOURS) 
    FROM COURSE crs 
    JOIN PROFESSOR_COURSE prof_crs 
    ON crs.course_id = prof_crs.course_id
    WHERE prof_crs.PROFESSOR_ID = pid
)
- 
(
    -- amount payed by university to professor
    SELECT SUM(AMOUNT) FROM BANK_TRANSFER WHERE PERSON_ID = pid AND OUTGOING = 1
)
+ 
(
    -- amount payed by professor to university
    SELECT SUM(AMOUNT) FROM BANK_TRANSFER WHERE PERSON_ID = pid AND OUTGOING = 0
) AS PROFESSOR_CREDIT
FROM PERSON per 
JOIN PROFESSOR prof 
ON per.person_id = prof.person_id 
WHERE CONCAT(per.first_name, ' ', per.last_name) = {professor_name}
```

שאילתה המחזירה קורסים שמלומדים ע"י מרצים המבוגרים מגיל נתון.

```sql
SELECT
    c.course_name,
    CONCAT(per.first_name, ' ', per.last_name) AS professor_name,
    per.date_of_birth
FROM
    COURSE c
JOIN
    PROFESSOR_COURSE pc ON c.course_id = pc.course_id
JOIN
    PROFESSOR p ON pc.professor_id = p.person_id
JOIN
    PERSON per ON p.person_id = per.person_id
WHERE
    per.date_of_birth < "{old_cutoff}";
```

שאילתה המחזירה את הרווחיות של קורס נתון (מבחינת הכנסה)

```sql
SELECT
    c.course_name,
    c.course_cost * COUNT(sc.student_id) AS total_course_revenue
FROM
    COURSE c
JOIN
    STUDENT_COURSE sc ON c.course_id = sc.course_id
WHERE
    c.course_name = '{course_name}'
GROUP BY
    c.course_name, c.course_cost;
```



# תוכנית 1

תוכנית שמשמשת לביצוע העברות יום הולדת ללומדי האוניברסטיה.

## פונקציות ופרוצדורות: 

פונקציה שמחשבת את ממוצע ההעברות לבן אדם. 
הפונקציה מחשבת את ממוצע סכומי ההעברות, פונקציה זו תשמש אותנו לעשות סטטיסטיקות על ההעברת של המשתמש בהמשך.

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



# מיזוג טבלאות

## אבחון הפרויקט השני

קיבלנו את הפרוייקט של קבוצה 2, הפרוייקט עוסק במעונות האוניברסיטה.
לפרוייקט היה עיצוב שונה שדרש חשיבה והתאמות לפרויקט שלנו עליהם נפרט בהמשך.
### עיצוב
סירטוט הERD של הפרוייקט נראה כך:
![](level%204/dorms_ERD.png)
ניתן להבחין ב8 טבלאות:
 - ביניין : מיוצג ע"י מספר סידורי 
 - חדר: מיוצגים ע"י מספר סידורי של הבניין ומספר בתוך הבניין.
 - אדם: מיוצג ע"י ID, פלאפון, שם, גיל
	 - עובד: תאריך העסקה
		 - מנהל: תחום האחריות שהוא מנהל.
		 - מנקה: משמרת.
	 - סטודנט: תואר שעושה ותאריך הרשמה ללימודים.
 - קישור בין עובד לבניין שהוא עובד בו, קשר רבים לרבים.

### טבלאות
תרשים בDSD נראה כך: 
![](level%204/dorms_DSD.png)
אלו התכונות של האישויות והטבלאות:
## מיזוג טבלאות חופפות - החלטות.
עיקר האתגר היה לנהל את השילוב של הנתונים בטבלאות החופפות. אדם וסטודנט.
לשם כך קיבלנו כמה החלטות לגבי עיצוב הפרויקט המשותף:
 - החלטנו לקחת את שמו של כל אדם ממסד הנתונים שלנו. 
 - את הנתון של גיל החלטנו להסיר בשל היכולת לחשב אותו לפי תאריך הלידה וצורך בחישוב מחדש כל פעם של הגיל.
 - את הנתון של מספר טלפון לאדם לקחנו ממסד הנתונים השני.
 - הוספנו לסטודנט את שתי עמודות המפתח של טבלת החדר (מספר סידורי ובניין) מבסיס הנתונים השני.
 - הוחלט שסוג האדם (סטודנט, מרצה, מנהל, מנקה) יקבע לפי השיטה הבאה: 
	 - אדם המוגדר בבסיס הנתונים השני כמנהל או מנקה - יוגדר כך גם בבסיס הנתונים הממוזג.
	 - לשם כך נמחק אותו אדם אם הוא כבר מופיע כאדם מסוג מסוים בבסיס הנתונים שלנו.
 - הוחלט לשנות את הDepartment של manager ב Devision בכדי להבדיל בין זה לבין Department של מרצה.
## תוצר סופי
### עיצוב
![](level%204/integration_erd.png)

ניתן לראות שיש שלושה סוגי אנשים בפרויקט החדש. 
### טבלאות
![](level%204/integration_dsd.png)