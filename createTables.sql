CREATE DATABASE HogwartzAccounting;
use HogwartzAccounting;

CREATE TABLE PERSON (
    person_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    bank_account VARCHAR(20),
    national_id VARCHAR(20)
);

CREATE TABLE COURSE (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_cost DECIMAL(10, 2),
    professor_pay DECIMAL(10, 2)
);

CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    person_id INT,
    student_number VARCHAR(20),
    enrollment_date DATE,
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);

CREATE TABLE PROFESSOR (
    professor_id INT PRIMARY KEY,
    person_id INT,
    employee_number VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(10, 2),
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);

CREATE TABLE STUDENT_COURSE (
    student_course_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    signup_date DATE,
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

CREATE TABLE BANK_TRANSFER (
    transfer_id INT PRIMARY KEY,
    bank_account VARCHAR(20),
    amount DECIMAL(10, 2),
    transfer_date DATE,
    description VARCHAR(255),
    is_from_university BOOLEAN
);

CREATE TABLE PROFESSOR_COURSE (
    professor_course_id INT PRIMARY KEY,
    professor_id INT,
    course_id INT,
    weekly_hours INT,
    FOREIGN KEY (professor_id) REFERENCES PROFESSOR(professor_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);
