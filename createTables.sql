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
    person_id INT PRIMARY KEY,
    enrollment_date DATE,
    major VARCHAR(30),
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);

CREATE TABLE PROFESSOR (
    person_id INT PRIMARY KEY,
    hire_date DATE,
    department VARCHAR(30),
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);

CREATE TABLE STUDENT_COURSE (
    student_id INT,
    course_id INT,
    signup_date DATE,
    FOREIGN KEY (student_id) REFERENCES STUDENT(person_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    PRIMARY KEY (student_id, course_id)
);

CREATE TABLE BANK_TRANSFER (
    transfer_id INT PRIMARY KEY,
    person_id INT,
    amount DECIMAL(10, 2),
    transfer_date DATE,
    description VARCHAR(255),
    outgoing BOOLEAN,
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);

CREATE TABLE PROFESSOR_COURSE (
    professor_id INT,
    course_id INT,
    weekly_hours INT,
    FOREIGN KEY (professor_id) REFERENCES PROFESSOR(person_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    PRIMARY KEY (professor_id, course_id)
);
