--* IF Statement *--

/* 

    IF boolean_expression
    BEGIN
        { statement_block, TRUE Condition }
    END

*/

-- (1)
IF DATENAME(WEEKDAY, GETDATE()) IN (N'Saturday', N'Sunday')
    SELECT 'Weekend';

ELSE
    SELECT 'Weekday'

-- (2) BEGIN ~ END

DECLARE @value INT = 0
DECLARE @returnValue SMALLINT

IF @value = 0
BEGIN
    SELECT 'The value is zero' AS [Name]
    SET @returnValue = -1;
END

SELECT @returnValue

--

DECLARE @site_value INT = 76;
IF @site_value < 25
    SELECT 'vivabm.com'
ELSE
BEGIN
    IF @site_value < 50
        SELECT 'kimbumjun.co.kr'
    ELSE
        SELECT 'kimbumjun.com'
END
