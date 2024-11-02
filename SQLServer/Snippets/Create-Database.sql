--! 데이터베이스 생성 !--
USE master
GO

IF NOT EXISTS 
(
    SELECT name FROM sys.databases WHERE name = N'데이터베이스명'
)

CREATE DATABASE [KimBumJun];
GO

IF SERVERPROPERTY('ProductVersion') > '12'
    ALTER DATABASE [KimBumJun] SET QUERY_STORE=ON;
GO

--* Set Collate Korea_Wansung_CI_AS
ALTER DATABASE [KimBumJun]
    COLLATE Korean_Wansung_CI_AS
GO

--? Check, master
use master;
go

Select name, collation_name
From sys.databases
Where name = N'KimBumJun'
go

--*  기본언어 한글로 변경
USE [KimBumJun]
GO
EXEC sp_configure 'default language', 29 ;
GO
RECONFIGURE ;
GO

--USE AdventureWorks2022;
--GO
--EXEC sp_configure 'default language', 2 ;
--GO
--RECONFIGURE ;
--GO

-- after login user, get default language
SELECT
    type_desc,
    default_database_name,
    default_language_name
FROM master.sys.server_principals
WHERE name = 'KimBumJun';


--* 마무리 작업, 전체복구 모델로 변경
USE master;
GO

ALTER DATABASE [KimBumJun] SET RECOVERY FULL
GO

ALTER DATABASE [KimBumJun] SET  MULTI_USER
GO

-- End Line --
