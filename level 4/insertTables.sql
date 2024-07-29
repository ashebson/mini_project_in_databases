use HogwartzAccounting;

INSERT INTO BUILDING
SELECT BuildingID FROM ExternalDatabase.building;

INSERT INTO ROOM
SELECT RoomID, MaxCapacity, BuildingID FROM ExternalDatabase.room;

DELETE FROM PROFESSOR WHERE PERSON_ID IN (SELECT ID FROM ExternalDatabase.worker);

DELETE FROM STUDENT WHERE PERSON_ID IN (SELECT ID FROM ExternalDatabase.worker);

INSERT INTO MAINTENANCE_WORKER
SELECT HireDate, ID FROM ExternalDatabase.worker WHERE ID IN (SELECT PERSON_ID FROM PERSON);

INSERT INTO CLEANER
SELECT Shift, ID FROM ExternalDatabase.cleaner WHERE ID IN (SELECT ID FROM MAINTENANCE_WORKER);

INSERT INTO WORKS_IN
SELECT ID, BuildingID FROM ExternalDatabase.worksin WHERE ID IN (SELECT ID FROM MAINTENANCE_WORKER);

INSERT INTO MANAGER (Devision, ID)
SELECT Department, ID FROM ExternalDatabase.manager WHERE ID IN (SELECT ID FROM MAINTENANCE_WORKER);

UPDATE PERSON p1
JOIN ExternalDatabase.person p2 ON p1.person_id = p2.id
SET p1.PhoneNumber = p2.PhoneNumber;

UPDATE STUDENT s1
JOIN ExternalDatabase.student s2 ON s1.person_id = s2.id
SET s1.BuildingID = s2.BuildingID, s1.RoomID = s2.RoomID;