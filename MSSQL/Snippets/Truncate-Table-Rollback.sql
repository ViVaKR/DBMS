--* Truncate and Rollback *--

USE PlayGround
GO

IF OBJECT_ID(N'TestTable', 'U') IS NULL
BEGIN
    create table TestTable
    (
        Id INT PRIMARY KEY IDENTITY(1,1),
        FullName NVARCHAR(50) NOT NULL
    );
END
ELSE
BEGIN
        PRINT '== 이미 있는 테이블입니다. =='
END
GO

INSERT INTO TestTable
VALUES
        ('장길산'),
        ('임꺽정'),
        ('김옥순'),
        ('장촌장')
GO


SELECT
    *
FROM
    TestTable

--* Create Transaction
BEGIN TRAN

-- Truncate table
TRUNCATE TABLE TestTable;

-- Rollback Truncate table
ROLLBACK

SELECT
    *
FROM
    TestTable

--* End Line *--









