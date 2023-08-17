USE PlayGround
GO

USE PlayGround
GO
SELECT
    name
    ,max_column_id_used
    ,type_desc
FROM
    SYS.TABLES
WHERE
    type = 'U'

SELECT
    *
FROM
    Supplier


SELECT
    STRING_AGG(FullName, ', ') as Names
FROM
    Supplier


SELECT * FROM Employees
