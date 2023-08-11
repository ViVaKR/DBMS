--! 데이터베이스 생성 !--
USE master
GO

IF NOT EXISTS (
 SELECT name
FROM sys.databases
WHERE name = N'데이터베이스명'
)
 CREATE DATABASE [데이터베이스명];
GO

IF SERVERPROPERTY('ProductVersion') > '12'
 ALTER DATABASE 데이터베이스명 SET QUERY_STORE=ON;
GO

--* Set Collate Korea_Wansung_CI_AS
ALTER DATABASE [데이터베이스명]
COLLATE Korean_Wansung_CI_AS
GO

--? Check
Select name, collation_name
From sys.databases
Where name = N'Hero'

--*  기본언어 한글로 변경
USE [데이터베이스명]
GO
EXEC sp_configure 'default language', 29 ;
GO
RECONFIGURE ;
GO

--* 마무리 작업, 전체복구 모델로 변경
USE master;
ALTER DATABASE [데이터베이스명] SET RECOVERY FULL 
GO

ALTER DATABASE [데이터베이스명] SET  MULTI_USER 
GO


--? (기타) If After Attach -> 기존 데이터베이스 사용자를 SQL Server 로그인에 매핑
use [데이터베이스]
go
EXEC sp_changedbowner 'sa'
--! e.g. Map Database User A To Login B 
EXEC sp_change_users_login 'Update_One', 'A', 'B'

GO
-- End Line --
