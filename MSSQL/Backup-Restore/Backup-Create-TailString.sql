
--* Backup File Name Tail Part By GETDATE()
DECLARE @datetime DATETIME
SET @datetime = GETDATE()

DECLARE @Tail NVARCHAR(MAX)
SET @Tail = CONCAT
(
    YEAR(@datetime),
    MONTH(@datetime),
    DAY(@datetime), 
    DATEPART(HOUR, @datetime), 
    DATEPART(MINUTE, @datetime),
    DATEPART(SECOND, @datetime)
)

SELECT @Tail
