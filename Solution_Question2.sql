/*
Note:
- Version: MySQL 5.7
- Data download link: https://s3-ap-southeast-1.amazonaws.com/ms-data-coding-challenge/SampleOrders.csv.csv
- Data/table creation and data import source: https://github.com/limhye70/MoneySmart_Coding_Challenge/blob/limhye70-patch-1/0_Create_Schema_Tables.sql

Question2: 
Write an SQL statement to find out which items are the most frequently being purchased together by
the same user. (could be in different Order)
*/

/* Return the answer of the question */
SELECT 
    Product_A,
    Product_B,
    COUNT(CustomerID) AS Unique_User_Count -- count the number of row of customerID by Product_A & Product_B
FROM (
	/*a table with the combination of cross sell and corresponding customerID*/
	SELECT
	    DISTINCT 
	    t1.CustomerID,
	    t1.ProductID AS Product_A,
	    t2.ProductID AS Product_B
	FROM `moneysmart`.`sampleorders` AS t1
	    INNER JOIN `moneysmart`.`sampleorders` AS t2 ON t1.CustomerID = t2.CustomerID 
	/*include unique combinations only*/
        WHERE t1.ProductID <> t2.ProductID -- include rows only when Product_A <> Product_B
	    and t1.ProductID < t2.ProductID -- prevent from double counting. for example, include (A,B) but exclude (B,A).
    ) a
GROUP by product_A,Product_B
ORDER by Unique_User_Count DESC; -- show data from the combinations of the top cross sell products
