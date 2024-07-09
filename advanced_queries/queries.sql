-- gives the 10 courses with the biggest pay rate from students:
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

-- The professors with the biggest salaries:
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

--the balance of all the students
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



-- the teachers older than 30 in the  year 2018
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

-- Delete transfers older than 5 years ago
DELETE FROM 
    BANK_TRANSFER
WHERE 
    transfer_date <= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);


-- delete courses no budy study or teach 
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



-- set the major Information Technology to Data Science
UPDATE 
    STUDENT
SET 
    major = 'Data Science'
WHERE 
    major = 'Information Technology';