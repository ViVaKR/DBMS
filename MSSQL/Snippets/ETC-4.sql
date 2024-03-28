
--* 활성 데이터베이스 확인
select db_name()
go

--* 테이블 목록 (활성 데이터베이스)
 select * from information_schema.tables where table_schema='dbo'
 go

--* 데이터베이스 목록
select name from sys.databases
go

sp_databases
go

--* 서버이름 및 정보 가져오기
SELECT @@SERVERNAME
go

sp_helpserver
go

--* Collation Info (문자셋과 데이터 정렬 정보)
-- 한글 설정 e.g. `Korean_Wansung_CI_AS`
SELECT SERVERPROPERTY('COLLATION')
GO

--* Edition Info
SELECT SERVERPROPERTY('EDITION')
GO

SELECT SERVERPROPERTY('IsIntegratedSecurityOnly')
GO

--* SQLCMD 열간격 조정하기
-- (1) >`sqlcmd -S my_server`
-- (2) > :setvar SQLCMDMAXVARTYPEWIDTH 20
-- (3) > go
-- (1) > :setvar SQLCMDMAXFIXEDTYPEWIDTH 20
-- (2) > GO

--* All Databases
select * from sys.databases;
go

--* All Views
select * from sys.all_views;
go


--* 서버간 통신 기본 설정
EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

--* 외부 서버로 부터 테이블 복사하기
SELECT *
INTO TestTb
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=서버;Initial Catalog=데이터베이스;User ID=아이디;Password=비밀번호'
        ).[데이터베이스명].dbo.테이블

--* 테스트
EXEC sp_addlinkedserver [database.windows.net];
GO
USE tempdb;
GO
CREATE SYNONYM MyInvoice FOR 
    [database.windows.net].basecampdev.dbo.invoice;
GO

--* Backup
BACKUP LOG HyundaiDb TO DISK = N'D:\Backup\<데이터베이스명>.TRN'
BACKUP DATABASE HyundaiDb TO DISK = 'D:\Backup\<데이터베이스명>.bak'
GO

--* 외부 데이터베이스에서 데이터 삽입
SET IDENTITY_INSERT 데이터베이스명.테이블명 ON 
    insert into 데이터베이스명.dbo.테이블명 
    select * from 외부데이터베이스명.dbo.테이블명
SET IDENTITY_INSERT [데이터베이스명].dbo.테이블명 OFF

GO

--* 테이블 언어셋 확인
SELECT COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = '해당 테이블명'


--* 데이터베이스와 테이블의 Character Set, 언어확인
select @@Language

--* 데이터베이스 캐릭터 셋 확인
select collation_name from sys.databases

--* 데이터베이스 `Korea_Wansung_CI_AI` 변경
ALTER DATABASE 데이터베이스명
COLLATE Korean_Wansung_CI_AI
GO

--* 컬럼 Korean_Wansung_CI_AI 변경
Alter Table 테이블명
Alter Column 컴럼명 nvarchar(50) COllate Korean_Wansung_CI_AI
GO

--? (약어)
--! CI : 대소문자 구분 안함, CS: 구분함
--! AI : 악센트 구분 안함, AS : 구분함


--? Korean_Wansung_CI_AS

-- End Line --
