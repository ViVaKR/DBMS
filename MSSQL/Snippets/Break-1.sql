--* BREAK *--

DECLARE @count INT = 0

WHILE (@count <= 26)
BEGIN
    INSERT INTO @TestTable VALUES (@count, CHAR(@count + ASCII('a')))
    SET @count = @count + 1
    
END
