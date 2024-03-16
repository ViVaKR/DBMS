--! 데이터베이스 및 로그인, 사용자 생성 !--

USE master;
go

IF NOT EXISTS (SELECT name
FROM sys.databases
WHERE name = N'W3Writer')
CREATE DATABASE [W3Writer];
go

IF SERVERPROPERTY('ProductVersion') > '12'
    ALTER DATABASE [W3Writer] SET QUERY_STORE=ON;
go

--* Set Collate Korea_Wansung_CI_AS
ALTER DATABASE [W3Writer]
    COLLATE Korean_Wansung_CI_AS
go

--? Check, master
use master;
go

--*  기본언어 한글로 변경
USE W3Writer;
go

EXEC sp_configure 'default language', 29 ;
go

RECONFIGURE ;
go

--* 마무리 작업, 전체복구 모델로 변경
USE master;
go

ALTER DATABASE [W3Writer] SET RECOVERY FULL
go

ALTER DATABASE [W3Writer] SET  MULTI_USER
go

-- Login & User ---------------

USE [master]
go

CREATE LOGIN [W3Writer]
	WITH PASSWORD=N'B9037!m8947#',
	DEFAULT_DATABASE=[W3Writer],
	DEFAULT_LANGUAGE=[한국어],
	CHECK_EXPIRATION=OFF,
	CHECK_POLICY=OFF
go

USE [W3Writer]
go

CREATE USER [W3Writer] FOR LOGIN [W3Writer]
go

ALTER USER [W3Writer] WITH DEFAULT_SCHEMA=[dbo]
go

ALTER ROLE [db_owner] ADD MEMBER [W3Writer]
go

-- Begin Try
-- 	Begin Tran CreateDb
-- Commit Tran CreateDb
-- End Try
-- Begin Catch
-- Rollback Tran CreateDb
-- select
-- 	ERROR_NUMBER() as 오류번호,
-- 	ERROR_STATE() as 오류상태,
-- 	ERROR_SEVERITY() as 심각도,
-- 	ERROR_LINE() as 오류라인,
-- 	ERROR_MESSAGE() as 오류내용
-- End Catch
