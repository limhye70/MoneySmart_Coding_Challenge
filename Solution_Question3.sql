/*
Note:
- Version: MySQL 5.7
- Data download link: https://s3-ap-southeast-1.amazonaws.com/ms-data-coding-challenge/SampleOrders.csv.csv
- Data/table creation and data import source: https://github.com/limhye70/MoneySmart_Coding_Challenge/blob/limhye70-patch-1/0_Create_Schema_Tables.sql

Question3: 
Write an SQL statement to find out the most frequent date interval between orders from the same user.
*/

USE `moneysmart`;
DROP PROCEDURE IF EXISTS proc_order;
DELIMITER $$
CREATE PROCEDURE proc_order()
BEGIN
	/* Declare variables */
	DECLARE v_customerid VARCHAR(10); -- CustomerID from the current row
    DECLARE v_orderdate DATE; -- OrderDate from the current row
    DECLARE v_orderid VARCHAR(14); -- OrderID from the current row
    DECLARE old_customerid VARCHAR(10) DEFAULT '*'; -- customerID from the previous row
    DECLARE old_orderdate DATE DEFAULT NULL; -- OrderDate from the previous row
    DECLARE v_datediffer INT DEFAULT NULL; -- OrdrDate difference between previous and current row 
    DECLARE v_finished INT DEFAULT 0; -- to escape the roop
    
    /* Declare cursor */
	DECLARE c1 CURSOR FOR SELECT DISTINCT CustomerID, OrderID, OrderDate FROM `moneysmart`.`sampleorders` ORDER BY CustomerID, OrderDate, OrderID;
    /* Declare the following handler: When there is no more row below, assign 1 to v_finished */
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished=1;
    
    /* Create a temporary table to store the output from the loop below*/
    DROP TEMPORARY TABLE IF EXISTS `moneysmart`.`temp_output`;
		CREATE TEMPORARY TABLE `moneysmart`.`temp_output` (
			`customerid` VARCHAR(10) NOT NULL,
			`datediff` INT NULL);
    
/* Open the cursor*/
OPEN c1;
	/* Create loop */
    get_date: LOOP
    
		/* Fetch the first row */
        FETCH c1 into v_customerid, v_orderid, v_orderdate;
        
        /* Escape the loop when it is the last row */
        if v_finished=1 then
			leave get_date;
		end if;
        
        /*  Calculate the difference of OrderDate between previous and current row */
        if(v_customerid = old_customerid) THEN
			SET v_datediffer = DATEDIFF(v_orderdate,old_orderdate);
		else
			SET v_datediffer = NULL;
		END IF;
		
        /* Assign the values of the current row to the variables with the previous row */
        SET old_customerid = v_customerid;
        SET old_orderdate = v_orderdate;
		
         /* Insert value into the temporary table created above */
        INSERT INTO `moneysmart`.`temp_output`
			VALUES (v_customerid,v_datediffer);
	
     /*End loop*/
	END LOOP get_date;
    /*Close cursor*/
    CLOSE c1;
    
    /* Return the answer of the question */
	SELECT 
		concat(datediff, ' ' ,'days') AS Date_Interval_Since_Prev_Order, 
		COUNT(*) AS Order_Count
	FROM `moneysmart`.`temp_output`
	WHERE datediff IS NOT NULL
	GROUP BY datediff
	ORDER BY Order_Count DESC
	LIMIT 5 -- show top 5 of the most date intervals 
	;
    
END $$

/* Execute the procedure */ 
CALL proc_order() $$
/* Change delimiter from $$ back to ';' */
DELIMITER ;

