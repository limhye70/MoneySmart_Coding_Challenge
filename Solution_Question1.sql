/*
Note:
- Version: MySQL 5.7
- Data download link: https://s3-ap-southeast-1.amazonaws.com/ms-data-coding-challenge/SamplePageviews.csv
- Data/table creation and data import source: https://github.com/limhye70/MoneySmart_Coding_Challenge/blob/limhye70-patch-1/0_Create_Schema_Tables.sql

Question1: 
Write an SQL statement to find the total number of user sessions each page has each day.
(A user session is defined as continuous activity on a site where each activity is within 10 mins of each other.)
*/

/* Return the answer of the question */
SELECT 
	Page_ID,
    Visit_Date,
	count(ID) AS Total_User_Sessions -- count the number of the rows of ID by Page_ID and Visit_Date 
FROM `moneysmart`.`samplepageviews` -- `database`.`tablename`
GROUP BY Page_ID, Visit_Date 
ORDER BY Page_ID        
