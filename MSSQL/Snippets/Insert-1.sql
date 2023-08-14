
--* INSERT *--

USE PlayGround
GO

IF OBJECT_ID(N'Employees', 'U') IS NULL
BEGIN
    create table Employees
    (
        Id INT PRIMARY KEY IDENTITY(10,1),
        FullName NVARCHAR(50) NOT NULL,
        Age INT NOT NULL
    );
END
ELSE
BEGIN
        PRINT '== 이미 있는 테이블입니다. =='
END
GO

--* Employees
INSERT INTO Employees
VALUES
        ('장길산', 45),
        ('임꺽정', 29),
        ('김옥순', 38),
        ('장촌장', 59)
GO

--* Contacts
USE PlayGround
GO

IF OBJECT_ID(N'Contacts', 'U') IS NULL
BEGIN
    create table Contacts
    (
        Id INT PRIMARY KEY IDENTITY(100,1),
        FullName NVARCHAR(50) NULL,
        Age INT NULL
    );
END
ELSE
BEGIN
        PRINT '== 이미 있는 테이블입니다. =='
END
GO

--* INSERT Contacts By Select
INSERT INTO Contacts
SELECT
    FullName,
    Age
FROM
    Employees

--* INSERT Default
INSERT INTO Contacts
(FullName, Age)
DEFAULT VALUES;
