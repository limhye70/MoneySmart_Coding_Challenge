/* 0 Setting */
/* 0-1 Create Schema */
DROP DATABASE IF EXISTS `moneysmart`; 
CREATE SCHEMA `moneysmart`; 

/* 1 Create table and load data*/
/* 1-1 Table: samplepageviews */

/* Create a table*/
DROP TABLE IF EXISTS `moneysmart`.`samplepageviews`; 
CREATE TABLE `moneysmart`.`samplepageviews` (
  `ID` INT NOT NULL,
  `User_ID` VARCHAR(10) NULL,
  `Page_ID` VARCHAR(10) NULL,
  `Visit_Date` DATE NULL,
  `Visit_Time` TIME NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC));
  
/* Load csv data into table */
LOAD DATA 
LOCAL INFILE "C:\\Users\\pc\\Documents\\MoneySmart_Test\\SamplePageviews.csv" 
INTO TABLE `moneysmart`.`samplepageviews`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID,User_ID,Page_ID,@datevar,@timevar)
SET Visit_Date = STR_TO_DATE(@datevar,'%Y-%m-%d'),
	Visit_Time = STR_TO_DATE(@timevar, '%H:%i:%s');

/* 1-2 Table: sampleorders */
/* Create a table */
DROP TABLE IF EXISTS `moneysmart`.`sampleorders`;
CREATE TABLE `moneysmart`.`sampleorders` (
  `RowID` INT NOT NULL,
  `OrderID` VARCHAR(14) NULL,
  `OrderDate` DATE NULL,
  `CustomerID` VARCHAR(10) NULL,
  `ProductID` VARCHAR(20) NULL,
  `ProductName` VARCHAR(150) NULL,
  `Sales` DECIMAL(15,4) NULL,
  `Quantity` INT NULL,
  PRIMARY KEY (`RowID`),
  UNIQUE INDEX `RowID_UNIQUE` (`RowID` ASC));
  
/* Load csv data into the table */
LOAD DATA 
LOCAL INFILE "C:\\Users\\pc\\Documents\\MoneySmart_Test\\SampleOrders.csv" 
INTO TABLE `moneysmart`.`sampleorders`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(RowID,OrderID,@datevar,CustomerID,ProductID,ProductName,Sales,Quantity)
SET OrderDate = STR_TO_DATE(@datevar,'%d/%m/%y');