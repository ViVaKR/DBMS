--! 데이터베이스 및 로그인, 사용자 생성 !--

use master;
go

if not exists (select name
from sys.databases
where name = N'Utility')
create database [Utility];
go

if SERVERPROPERTY('ProductVersion') > '12'
    alter database [Utility] set QUERY_STORE=on;
go

--* Set Collate Korea_Wansung_CI_AS
alter database [Utility]
    collate Korean_Wansung_CI_AS
go

--? Check, master
use master;
go

--*  기본언어 한글로 변경
use Utility;
go

exec sp_configure 'default language', 29 ;
go

reconfigure ;
go

--* 마무리 작업, 전체복구 모델로 변경
use master;
go

alter database [Utility] set RECOVERY full
go

alter database [Utility] set  MULTI_USER
go

-- Login & User ---------------

use [master]
go

create login [Utility]
	with PASSWORD=N'password!',
	DEFAULT_DATABASE=[Utility],
	DEFAULT_LANGUAGE=[한국어],
	CHECK_EXPIRATION=off,
	CHECK_POLICY=off
go

use [Utility]
go

create user [Utility] for LOGIN [Utility]
go

alter user [Utility] with DEFAULT_SCHEMA=[dbo]
go

alter role [db_owner] add MEMBER [Utility]
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
