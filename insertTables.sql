use HogwartzAccounting;

-- CSV INSERT

CREATE TEMPORARY TABLE mockpeople(
    person_id INT, 
    first_name VARCHAR(20), 
    last_name VARCHAR(20), 
    date_of_birth VARCHAR(20),
    bank_account VARCHAR(20),
    national_id VARCHAR(20)
);

LOAD DATA LOCAL INFILE 'MOCK_DATA_PEOPLE.csv' 
INTO TABLE mockpeople 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;