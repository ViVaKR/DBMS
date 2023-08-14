--* While Loop

/* 
    WHILE condition
    BEGIN
        { statements }
    END;

 */

--! Declare Table Example
USE PlayGround
GO

declare @TestTable Table (ColA INT,
    ColB CHAR(3));
DECLARE @MyCounter INT
SET @MyCounter = 0;

WHILE (@MyCounter < 26)
BEGIN
    INSERT INTO @TestTable
    VALUES
        (@MyCounter, CHAR(@MyCounter + ASCII('a')));
    SET @MyCounter = @MyCounter + 1;
END

SELECT
    ColA, ColB
FROM
    @TestTable

--*

DECLARE @site_value INT
SET @site_value = 0

WHILE (@site_value <= 10)
BEGIN
    SELECT 'Inside While Loop'
    SET @site_value = @site_value + 1;
END

SELECT 'Done WHILE LOOP'
GO

--* 

USE [PlayGround]
GO

DECLARE @id INT
DECLARE @fullname NVARCHAR(MAX)

DECLARE cs CURSOR FOR
SELECT Id, FullName FROM Demo

OPEN cs
FETCH NEXT FROM cs into @id, @fullname

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @id
    PRINT @fullname
    FETCH NEXT FROM cs into @id, @fullname
END

CLOSE cs
DEALLOCATE cs

--*
