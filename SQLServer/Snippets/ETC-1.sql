sp_who 'active'
--kill 12 -- spid
GO

DBCC checkident('국가코드')

-- 로그인 계정보기
select name from master.dbo.syslogins
go

-- 서버정보 확인
SELECT  
SERVERPROPERTY('ProductVersion ') AS ProductVersion,  
SERVERPROPERTY('ProductLevel') AS ProductLevel,  
SERVERPROPERTY('ResourceVersion') AS ResourceVersion,  
SERVERPROPERTY('ResourceLastUpdateDateTime') AS ResourceLastUpdateDateTime,  
SERVERPROPERTY('Collation') AS Collation;
go

sp_helpserver
GO

-- 환경정보 확인하기
select * from sys.configurations
go

select @@servername as 'Server Name'

select @@version

select @@IDENTITY

select HOST_NAME() -- return nvarchar(128)

Select SERVERPROPERTY('MachineName') as 'MachineName'

select @@DBTS

-- 전체 테이블 수
SELECT Count(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

use master
GO
SELECT SERVERPROPERTY('collation')

select databasepropertyex('master','collation')

use Hyundai
go
select db_name()
go

sp_helpserver
go

select * from sys.databases;
go

use Hyundai
go
SELECT name as 데이터베이스명, physical_name AS 파일위치
FROM sys.master_files



-- ## DDL (Data Definition Language, 데이터 정의 언어) ## --
--> 데이터베이스 구조를 생성, 수정 및 삭제 등의 스키마 작업언어, 
--> CREATE : table, index, function, views, store procedure, triggers
--> DROP, ALTER, TRUNCATE, COMMENT, RENAME

-- ## TCL ## --
--> COMMIT : 
--> ROLLBACK
--> SAVEPOINT
--> SET TRANSACTION

SELECT CONVERT(varchar(30), GETDATE(), 9)
SELECT CONVERT(varchar(30), GETDATE(), 2)
SELECT CONVERT(varchar(30), GETDATE(), 102)
GO

-- 최대값 가져오기
select IDENT_CURRENT('국가코드')

EXEC sp_help 국가코드
