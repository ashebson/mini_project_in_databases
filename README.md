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

