--* Join *--

-- (1) INNER JOIN (단순 조인)
-- (2) LEFT OUTER JOIN (LEFT JOIN)
-- (3) RIGHT OUTER JOIN (RIGHT JOIN)
-- (4) FULL OUTER JOIN (FULL JOIN)


USE PlayGround
GO

IF OBJECT_ID(N'Supplier', 'U') IS NULL
BEGIN
    create table Supplier
    (
        Id INT PRIMARY KEY IDENTITY(10000,1),
        FullName NVARCHAR(50) NOT NULL
    );
END
ELSE
BEGIN
        PRINT '== 이미 있는 테이블입니다. =='
END
GO


INSERT INTO Supplier
VALUES
        ('Google')
        -- ('Microsoft'),
        -- ('Oracle'),
        -- ('IBM'),
        -- ('NVida'),
        -- ('HP')
GO  

USE PlayGround
GO

IF OBJECT_ID(N'OrderDate', 'U') IS NULL
BEGIN
    create table OrderDate
    (
        Id INT PRIMARY KEY IDENTITY(500125,1),
        SupplierId INT NOT NULL,
        OrDate DATETIME2

    );
END
ELSE
BEGIN
        PRINT '== 이미 있는 테이블입니다. =='
END
GO

INSERT INTO OrderDate
VALUES
        (10000, '2003-05-12'),
        (10001, '2003-05-13'),
        (10004, '2003-05-14')
GO

--* INNER JOIN
SELECT
    sp.Id, sp.FullName, od.OrDate
FROM
    Supplier sp
INNER JOIN OrderDate od
ON sp.Id = od.SupplierId

--* LEFT JOIN
SELECT
    sp.Id, sp.FullName, od.OrDate
FROM
    Supplier sp
LEFT JOIN OrderDate od
ON sp.Id = od.SupplierId

--* RIGHT JOIN
SELECT
    od.Id,
    od.OrDate,
    sp.FullName
FROM
    Supplier sp
RIGHT JOIN OrderDate od
ON sp.Id = od.SupplierId
GO

--* FULL JOIN
SELECT
    sp.Id,
    sp.FullName,
    od.OrDate
FROM
    Supplier sp
FULL JOIN OrderDate od
ON sp.Id = od.SupplierId
