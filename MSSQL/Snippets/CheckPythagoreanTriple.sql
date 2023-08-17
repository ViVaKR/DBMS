--* 피타고라스 정의 확인
--? Refs : `https://blog.sqlauthority.com/2023/08/03/sql-server-stored-procedures-to-check-for-pythagorean-triples/`
USE PlayGround
GO

CREATE OR ALTER
PROC spCheckPythagoreanTriple
    (
    @a AS INT,
    @b AS INT,
    @c AS INT
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @max INT, @other1 INT, @other2 INT;
    -- Identify the maximum number and the other two
    IF @a >= @b AND @a >= @c
        SELECT @max = @a, @other1 = @b, @other2 = @c;
    ELSE IF @b >= @a AND @b >= @c
        SELECT @max = @b, @other1 = @a, @other2 = @c;
    ELSE
        SELECT @max = @c, @other1 = @a, @other2 = @b;
    -- Check if it’s a Pythagorean triple
    IF @max * @max = @other1 * @other1 + @other2 * @other2
        SELECT 1 AS isPythagorean;
    ELSE
        SELECT 0 AS isPythagorean;
END
