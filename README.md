# מיני פרוייקט בבסיסי נתונים
**אריה שבסון 210033585 ארז פולק**

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

שאילתה המחזירה קורסים שמלומדים ע״י מרצים מבוגרים

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

שאילתה המחזירה את הקורס הכי רווחי (מבחינת הכנסה)

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