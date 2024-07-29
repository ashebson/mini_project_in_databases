use HogwartzAccounting;

INSERT INTO BUILDING
SELECT BuildingID FROM ExternalDatabase.BUILDING;

INSERT INTO ROOM
SELECT RoomID, MaxCapacity, BuildingID FROM ExternalDatabase.ROOM;