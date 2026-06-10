SELECT * FROM [OnlineRetail 2]

-- Data Type

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OnlineRetail 2';


-- Total Number of Columns


SELECT COUNT(*) AS TotalColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OnlineRetail 2';


--  Total Number of Rows

SELECT COUNT(*) AS TotalRows
FROM [OnlineRetail 2];



-- Possible Unique Identifier

SELECT COUNT(*) AS TotalRows
FROM [OnlineRetail 2];

SELECT COUNT(DISTINCT InvoiceNo) AS UniqueInvoices
FROM [OnlineRetail 2];

SELECT COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM [OnlineRetail 2];

SELECT COUNT(DISTINCT StockCode) AS UniqueProducts
FROM [OnlineRetail 2];



-- Finding and filtering Missing Values

SELECT
    SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceNo,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Missing_Description,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Missing_UnitPrice,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM [OnlineRetail 2];

     
     
     ----  Description Missing Values



SELECT *
FROM [OnlineRetail 2]
WHERE Description IS NULL;


DELETE
FROM [OnlineRetail 2]
WHERE Description IS NULL;



         -- CustomerID Cleaning


ALTER TABLE [OnlineRetail 2]
ADD CustomerID_Clean NVARCHAR(50);


UPDATE [OnlineRetail 2]
SET CustomerID_Clean =
    CASE
        WHEN CustomerID IS NULL THEN 'Not Provided'
        ELSE CAST(CustomerID AS NVARCHAR(50))
    END;

     ALTER TABLE [OnlineRetail 2]
DROP COLUMN CustomerID;


  ---- Blank Spaces


SELECT
    SUM(CASE WHEN Description = '' THEN 1 ELSE 0 END) AS Blank_Description,
    SUM(CASE WHEN Country = '' THEN 1 ELSE 0 END) AS Blank_Country,
    SUM(CASE WHEN InvoiceNo = '' THEN 1 ELSE 0 END) AS Blank_InvoiceNo
FROM [OnlineRetail 2];


--- Duplicate

WITH DuplicateRows AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY
                   InvoiceNo,
                   StockCode,
                   Description,
                   Quantity,
                   InvoiceDate,
                   UnitPrice,
                   CustomerID,
                   Country
               ORDER BY InvoiceNo
           ) AS RowNum
    FROM [OnlineRetail 2]
)
SELECT COUNT(*) AS DuplicateRows
FROM DuplicateRows
WHERE RowNum > 1;



WITH DuplicateRows AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY
                   InvoiceNo,
                   StockCode,
                   Description,
                   Quantity,
                   InvoiceDate,
                   UnitPrice,
                   CustomerID,
                   Country
               ORDER BY InvoiceNo
           ) AS RowNum
    FROM [OnlineRetail 2]
)
DELETE
FROM DuplicateRows
WHERE RowNum > 1;


      -- Cleaning Date 

ALTER TABLE [OnlineRetail 2]
ADD Invoice_Date DATE;

UPDATE [OnlineRetail 2]
SET Invoice_Date =
    TRY_CONVERT(DATETIME, InvoiceDate, 103);

    ALTER TABLE [OnlineRetail 2]
DROP COLUMN InvoiceDate;


    --- Cleaning Time


    ALTER TABLE [OnlineRetail 2]
ADD Invoice_Time TIME;


UPDATE [OnlineRetail 2]
SET Invoice_Time =
    CAST(Invoice_Time AS TIME(0));


  SELECT TOP 10
    InvoiceDate,
    TRY_CONVERT(DATETIME, InvoiceDate) AS ConvertedDate
FROM [OnlineRetail 2];

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'OnlineRetail 2'
AND COLUMN_NAME = 'Invoice_Time';


UPDATE [OnlineRetail 2]
SET Invoice_Time =
    CONVERT(TIME(0),
            TRY_CONVERT(DATETIME, InvoiceDate));


ALTER TABLE [OnlineRetail 2]
ALTER COLUMN Invoice_Time TIME(0);


           -- Standardazation


    UPDATE [OnlineRetail 2]
SET Country = UPPER(Country);


 UPDATE [OnlineRetail 2]
SET Description = UPPER(Description);



 UPDATE [OnlineRetail 2]
SET Description = UPPER(Description);



        --- Data validation

SELECT COUNT(*) AS NegativeQuantities
FROM [OnlineRetail 2]
WHERE Quantity < 0;


SELECT COUNT(*) AS NegativePrices
FROM [OnlineRetail 2]
WHERE UnitPrice < 0;

SELECT COUNT(*) AS ZeroPrices
FROM [OnlineRetail 2]
WHERE UnitPrice = 0;


SELECT COUNT(*) AS CancelledInvoices
FROM [OnlineRetail 2]
WHERE InvoiceNo LIKE 'C%';



SELECT
    MIN(Quantity) AS MinQuantity,
    MAX(Quantity) AS MaxQuantity,
    AVG(Quantity) AS AvgQuantity
FROM [OnlineRetail 2];


SELECT
    MIN(UnitPrice) AS MinPrice,
    MAX(UnitPrice) AS MaxPrice,
    AVG(UnitPrice) AS AvgPrice
FROM [OnlineRetail 2];


SELECT DISTINCT Country
FROM [OnlineRetail 2]
ORDER BY Country;



SELECT  *
FROM [OnlineRetail 2]
WHERE Quantity < 0;


  SELECT 
    COUNT(*) AS NullDates
FROM [OnlineRetail 2]
WHERE Invoice_Date IS NULL;


SELECT COUNT(*) AS NullDates
FROM [OnlineRetail 2]
WHERE Invoice_Date IS NULL;


SELECT COUNT(*) AS NullTimes
FROM [OnlineRetail 2]
WHERE Invoice_Time IS NULL;


SELECT COUNT(*) AS ZeroPrices
FROM [OnlineRetail 2]
WHERE UnitPrice = 0;


----- Inconsistency

--- invoice 

SELECT *
FROM [OnlineRetail 2]
WHERE InvoiceNo <> LTRIM(RTRIM(InvoiceNo));


---StockCode


SELECT *
FROM [OnlineRetail 2]
WHERE StockCode <> LTRIM(RTRIM(StockCode));


---Description


SELECT *
FROM [OnlineRetail 2]
WHERE Description <> LTRIM(RTRIM(Description));


--CustomerID_Clean


SELECT *
FROM [OnlineRetail 2]
WHERE CustomerID_Clean <> LTRIM(RTRIM(CustomerID_Clean));


--Country


SELECT *
FROM [OnlineRetail 2]
WHERE Country <> LTRIM(RTRIM(Country));


   SELECT DISTINCT Country
FROM [OnlineRetail 2]
ORDER BY Country;

SELECT DISTINCT Country
FROM [OnlineRetail 2]
WHERE Country <> LTRIM(RTRIM(Country));

UPDATE [OnlineRetail 2]
SET Country = REPLACE(Country,'  ',' ')
WHERE Country LIKE '%  %';


     
    --UnitPrice

SELECT COUNT(*) AS NegativePrices
FROM [OnlineRetail 2]
WHERE UnitPrice < 0;

SELECT *
FROM [OnlineRetail 2]
WHERE UnitPrice < 0;

     
     
     ---Cancelled Orders

SELECT COUNT(*) AS CancelledInvoices
FROM [OnlineRetail 2]
WHERE InvoiceNo LIKE 'C%';



----Data Quality Checks 

SELECT *
FROM [OnlineRetail 2]
WHERE Invoice_Date IS NULL;

SELECT *
FROM [OnlineRetail 2]
WHERE Invoice_Time IS NULL;

SELECT COUNT(*) AS BlankDescriptions
FROM [OnlineRetail 2]
WHERE Description IS NULL
   OR LTRIM(RTRIM(Description)) = '';


   SELECT COUNT(*) AS BlankCountries
FROM [OnlineRetail 2]
WHERE Country IS NULL
   OR LTRIM(RTRIM(Country)) = '';







