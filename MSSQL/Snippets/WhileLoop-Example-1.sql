--* While Loop
--! Declare Table Example
USE PlayGround
GO

declare @TestTable Table (ColA INT, ColB CHAR(3));
DECLARE @MyCounter INT
SET @MyCounter = 0;

WHILE (@MyCounter < 26)
BEGIN
    INSERT INTO @TestTable VALUES (@MyCounter, CHAR(@MyCounter + ASCII('a')));
    SET @MyCounter = @MyCounter + 1;
END

SELECT
    ColA, ColB
FROM
    @TestTable
