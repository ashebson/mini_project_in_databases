/*markdown
mysql ExternalDatabase < backup3.sql
*/

use HogwartzAccounting;

/*markdown
# Joint Tables
*/

CREATE TABLE PERSON (
    person_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    bank_account VARCHAR(20),
    national_id VARCHAR(20)
);

CREATE TABLE STUDENT (
    person_id INT PRIMARY KEY,
    enrollment_date DATE,
    major VARCHAR(30),
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);

/*markdown
# Joint Table Modifications
*/

ALTER TABLE PERSON ADD PhoneNumber VARCHAR(20);

ALTER TABLE STUDENT ADD RoomID INT;

/*markdown
# Our Tables
*/

CREATE TABLE PROFESSOR (
    person_id INT PRIMARY KEY,
    hire_date DATE,
    department VARCHAR(30),
    FOREIGN KEY (person_id) REFERENCES PERSON(person_id)
);

CREATE TABLE COURSE (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_cost DECIMAL(10, 2),
    professor_pay DECIMAL(10, 2)
);

CREATE TABLE PROFESSOR_COURSE (
    professor_id INT,
    course_id INT,
    weekly_hours INT,
    FOREIGN KEY (professor_id) REFERENCES PROFESSOR(person_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    PRIMARY KEY (professor_id, course_id)
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

/*markdown
# Their Tables
*/

CREATE TABLE Building
(
  BuildingID INT NOT NULL,
  PRIMARY KEY (BuildingID)
);

CREATE TABLE Worker
(
  HireDate DATE NOT NULL,
  ID INT NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Person(person_id)
);

CREATE TABLE Room
(
  RoomID INT NOT NULL,
  MaxCapacity INT NOT NULL,
  BuildingID INT NOT NULL,
  PRIMARY KEY (RoomID, BuildingID),
  FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

CREATE TABLE Manager
(
  Department VARCHAR(50) NOT NULL,
  ID INT NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Worker(ID)
);

CREATE TABLE Cleaner
(
  Shift VARCHAR(20) NOT NULL,
  ID INT NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Worker(ID)
);

CREATE TABLE WorksIn
(
  ID INT NOT NULL,
  BuildingID INT NOT NULL,
  PRIMARY KEY (ID, BuildingID),
  FOREIGN KEY (ID) REFERENCES Worker(ID),
  FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

/*markdown
# Their Table Modifications
*/

ALTER TABLE Worker RENAME TO MaintenanceWorker;