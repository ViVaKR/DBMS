--* Continue *--

DECLARE @TestTable TABLE (Id INT, Character CHAR(1))
DECLARE @cnt INT = 0

WHILE (@cnt < 26)
BEGIN
    IF @cnt % 2 = 0 --Mod 
    BEGIN
        SET @cnt = @cnt + 1
        CONTINUE
    END
    
    INSERT INTO @TestTable VALUES (@cnt, CHAR(@cnt + ASCII('a')))
    SET @cnt = @cnt + 1
    
END

SELECT
    *
FROM
    @TestTable
