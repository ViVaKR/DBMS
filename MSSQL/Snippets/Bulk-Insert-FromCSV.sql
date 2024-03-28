USE PlayGround
GO

SELECT
    *
FROM
    Employees

--* BULK INSERT *--

--? Refs : `https://blog.sqlauthority.com/2023/08/07/sql-server-troubleshooting-common-csv-import-issues/`

-- CREATE TABLE Emps (
--     ID INT,
--     Name VARCHAR(50),
--     Age INT,
--     Email VARCHAR(100)
-- );

BULK INSERT Emps
FROM 'F:\1_GitProjects\DBMS\MSSQL\Snippets\sample_data.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0D0A' -- for CR+LF, '0x0D' for CR, '0x0A' for LF
);
GO

SELECT
    *
FROM
    Emps

