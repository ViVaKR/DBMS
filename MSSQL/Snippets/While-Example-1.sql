--* While Loop
--! Declare Table Example
USE PlayGround
GO

declare @TestTable Table (ColA INT, ColB CHAR(3));
DECLARE @MyCounter INT
SET @MyCounter = 0;

WHILE (@MyCounter < 26)
BEGIN
    INSERT INTO @TestTable VALUES (@MyCounter, CHAR(@MyCounter + ASCII('a')));

    SET @MyCounter = @MyCounter + 1;

END

SELECT
    ColA, ColB
FROM
    @TestTable


--* Create PlayGround Database
USE master
GO

IF NOT EXISTS  
(
    SELECT
        name
    FROM
        sys.databases
    WHERE
        name = N'PlayGround'
    
)
CREATE DATABASE [PlayGround]
GO

IF SERVERPROPERTY('ProductVersion') > '12'
ALTER DATABASE [PlayGround] SET QUERY_STORE = ON
GO

ALTER DATABASE [PlayGround]
    COLLATE Korean_Wansung_CI_AS
GO

USE [PlayGround]
GO

EXEC sp_configure 'default language', 29 ;
GO
RECONFIGURE ;
GO

USE master
GO
ALTER DATABASE [PlayGround] SET RECOVERY FULL 
GO

ALTER DATABASE [PlayGround] SET  MULTI_USER 
GO

--*


