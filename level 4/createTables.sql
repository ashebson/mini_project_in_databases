/*markdown
# Load ExternalDatabase
*/

/*markdown
```bash
mysql ExternalDatabase < backup3.sql
```
*/

use HogwartzAccounting;

/*markdown
# Their Tables
*/

CREATE TABLE BUILDING
(
  BuildingID INT NOT NULL,
  PRIMARY KEY (BuildingID)
);

CREATE TABLE WORKER
(
  HireDate DATE NOT NULL,
  ID INT NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Person(person_id)
);

CREATE TABLE ROOM
(
  RoomID INT NOT NULL,
  MaxCapacity INT NOT NULL,
  BuildingID INT NOT NULL,
  PRIMARY KEY (RoomID, BuildingID),
  FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

CREATE TABLE MANAGER
(
  Department VARCHAR(50) NOT NULL,
  ID INT NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Worker(ID)
);

CREATE TABLE CLEANER
(
  Shift VARCHAR(20) NOT NULL,
  ID INT NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (ID) REFERENCES Worker(ID)
);

CREATE TABLE WORKS_IN
(
  ID INT NOT NULL,
  BuildingID INT NOT NULL,
  PRIMARY KEY (ID, BuildingID),
  FOREIGN KEY (ID) REFERENCES Worker(ID),
  FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

/*markdown
# Joint Table Modifications
*/

ALTER TABLE PERSON ADD PhoneNumber VARCHAR(20);

ALTER TABLE STUDENT ADD RoomID INT REFERENCES ROOM(RoomID);

ALTER TABLE STUDENT ADD BuildingID INT REFERENCES BUILDING(BuildingID);

/*markdown
# Their Table Modifications
*/

ALTER TABLE WORKER RENAME TO MAINTENANCE_WORKER;