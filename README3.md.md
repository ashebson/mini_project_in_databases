
פונקציה שמחשב את ממוצע ההעברות לבן אדם. 

```sql 

DROP FUNCTION IF EXISTS calculate_mean_transfer;

CREATE FUNCTION calculate_mean_transfer(person_id_param INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total_amount FLOAT;
    DECLARE total_transfers INT;
    DECLARE mean_amount FLOAT;
    
    -- Calculate total amount and number of transfers
    SELECT SUM(amount), COUNT(*)
    INTO total_amount, total_transfers
    FROM BANK_TRANSFER
    WHERE person_id = person_id_param;
    
    -- Calculate mean amount
    IF total_transfers > 0 THEN
        SET mean_amount = total_amount / total_transfers;
    ELSE
        SET mean_amount = NULL; -- Handle case where no transfers exist
    END IF;
    
    RETURN mean_amount;
END
```