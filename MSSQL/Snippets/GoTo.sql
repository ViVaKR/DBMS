--* GOTO *--

DECLARE @TestTable TABLE (Id INT, Character CHAR(1))
DECLARE @count INT = 0

WHILE (@count <= 26)
BEGIN
    IF @count  = 13
        GOTO TheEnd;
    
    INSERT INTO @TestTable VALUES (@count, CHAR(@count + ASCII('a')))
    SET @count = @count + 1
    
END;

TheEnd:
    SELECT
        *
    FROM
        @TestTable
    GO
    PRINT 'Game Over'
GO
