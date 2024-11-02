set ansi_nulls on
set quoted_identifier on

-- 가상으로 에러 생성 후 진행 중단하기
raiserror('Oh no a fatal error', 20, -1) with log
go

-- 프로세스 Kill
sp_who 'active'
Kill 12 -- SPID
go

-- Identity 초기화
dbcc checkident(N'테이블', reseed, 0)
go
-- 로그인 계정보기
select name from master.dbo.syslogins
go
-- 서버 정보확인하기
SELECT  
SERVERPROPERTY('ProductVersion ') AS ProductVersion,  
SERVERPROPERTY('ProductLevel') AS ProductLevel,  
SERVERPROPERTY('ResourceVersion') AS ResourceVersion,  
SERVERPROPERTY('ResourceLastUpdateDateTime') AS ResourceLastUpdateDateTime,  
SERVERPROPERTY('Collation') AS Collation;
go

-- 약식 서버정보
sp_helpserver
go

-- 환경정보 확인하기
select * from sys.configurations
go

-- 실수값 찾기
SELECT  *
FROM [테이블]
WHERE   
	CASE WHEN IsNumeric(컬럼) = 1 
	THEN 
	CASE WHEN CAST(컬럼 AS FLOAT) <> CAST(CAST(컬럼 AS FLOAT) AS INT) 
	THEN 1 END 
	ELSE 1 END = 1

-- 전체 테이블 수
SELECT Count(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- 테이블 검색
SELECT * 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' and  TABLE_NAME = '임시'

-- 테이블 확인 후 삭제
DROP TABLE IF EXISTS [TOY].[BRANDS]
GO

-- 명령어 도움말
use master
exec sp_helptext xp_cmdshell

-- Parameters of sp_executesql
Exec sp_executesql
N'Select FilmName, FilmReleaseDate, FilmRunTimeMinutes From tblFilm
Where FilmRunTimeMinutes > @Length
And FilmReleaseDate > @StartDate'
,N'@Length int, @StartDate Datetime'
,@Length = 180
,@StartDate = '2000-01-01'

-- 트랜젝션 카운트 : @@Trancount

-- 기본언어 및 정렬 확인하기
use master
go

SELECT * FROM master.dbo.syslanguages
set LANGUAGE korean
GO

SELECT SERVERPROPERTY('collation')
select databasepropertyex('master','collation')

-- 데이터 정렬 수정
USE 데이터베이스 ;
GO
EXEC sp_configure 'default language', 29 ;
GO
RECONFIGURE ;
GO

-- 로그파일 정보
DBCC loginfo
GO
-- 파일정보
exec sp_helpfile
go
-- 데이터베이스 정보
exec sp_helpdb

-- 테이블 컬럼 언어 및 정렬 등 설정확인
SELECT COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '테이블명'

use [D:\DESKTOP\DB\MyDb.MDF]
go

-- 활성 데이터베이서
select db_name()
go

-- 데이터베이스 목록
select name from sys.databases
go

sp_databases
go
--
use DMS
go

-- 서버이름 및 정보 가져오기
SELECT @@SERVERNAME
go

sp_helpserver
go

-- 테이블 목록
 select * from information_schema.tables where table_schema='dbo'
 go

 --
SELECT SERVERPROPERTY('COLLATION')
GO

SELECT SERVERPROPERTY('EDITION')
GO

SELECT SERVERPROPERTY('IsIntegratedSecurityOnly')
GO

-- Batches, Scripts, Go, and Statements
-- Go is special command that is a "batch terminator"
-- A "batch" is a set of SQL commands that get sent to SQL Server in one network packet

select * from sys.databases;
go
select * from sys.all_views;
go


-- 다른 서버로 복사 하기 위한 설정
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

-- 외부 서버로 부터 테이블 복사하기
USE [databaseName]
go
SELECT *
INTO TestTb
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=127.0.0.1;Initial Catalog=MyDb;User ID=MyDb;Password=비밀번호'
        ).[MyDb].dbo.데이터
-- (작동견본) : 원격서버로 부터 테이블 복사하기
use TutorialDB
go
SELECT top 10 * into Test
FROM OPENDATASOURCE('MSOLEDBSQL','Server=127.0.0.1;Database=데이터베이스;User ID=아이디;Password=비밀번호;').Auto.dbo.테이블
--
-- 확인하기
EXEC sp_addlinkedserver [database.windows.net];
GO
USE tempdb;
GO
CREATE SYNONYM MyInvoice FOR 
    [database.windows.net].basecampdev.dbo.invoice;
GO

-- Backup
BACKUP LOG MyDb TO DISK = N'D:\Backup\MyDb.TRN'
BACKUP DATABASE MyDb TO DISK = 'D:\Backup\MyDb.bak'
GO

-- 외부 데이터베이스에서 데이터 삽입
SET IDENTITY_INSERT [MyDb].dbo.EFAppointments ON 
    insert into [MyDb].dbo.EFAppointments select * from [테이블].dbo.EFAppointments
SET IDENTITY_INSERT [MyDb].dbo.EFAppointments OFF

-- 언어셋 확인
SELECT COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '테이블'

-- 데이터베이스와 테이블의 Character Set, 언어확인
select @@Language

-- 데이터베이스 캐릭터 셋 확인
select collation_name from sys.databases

-- 데이터베이스 Korea_Wansung_CI_AS 변경
ALTER DATABASE 데이터베이스명
COLLATE Korean_Wansung_CI_AS
GO

-- 컬럼 Korean_Wansung_CI_AS 변경
Alter Table 테이블명
Alter Column 컴럼명 nvarchar(50) COllate Korean_Wansung_CI_AS
GO

-- (약어)
-- CI : 대소문자 구분 안함, CS: 구분함
-- AI : 악센트 구분 안함, AS : 구분함

--Korean_Wansung_CI_AS

-- 데이터정렬 명 확인하기
select name, collation_name
from sys.databases
where name = N'Works'

-- 데이터베이스 파일정보
SELECT name as 데이터베이스명, physical_name AS 파일위치
FROM sys.master_files
