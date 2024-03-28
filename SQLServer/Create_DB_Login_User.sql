--! 데이터베이스 및 로그인, 사용자 생성 !--

use master;
go

if not exists (select name
from sys.databases
where name = N'Movies')
create database [Movies];
go

if SERVERPROPERTY('ProductVersion') > '12'
    alter database [Movies] set QUERY_STORE=on;
go

--* Set Collate Korea_Wansung_CI_AS
alter database [Movies]
    collate Korean_Wansung_CI_AS
go

--? Check, master
use master;
go

--*  기본언어 한글로 변경
use Movies;
go

exec sp_configure 'default language', 29 ;
go

reconfigure ;
go

--* 마무리 작업, 전체복구 모델로 변경
use master;
go

alter database [Movies] set RECOVERY full
go

alter database [Movies] set  MULTI_USER
go

-- Login & User ---------------

use [master]
go

create login [Movies]
	with PASSWORD=N'Kv1!En9#Og6%Ni4&Uy8*',
	DEFAULT_DATABASE=[Movies],
	DEFAULT_LANGUAGE=[한국어],
	CHECK_EXPIRATION=off,
	CHECK_POLICY=off
go

use [Movies]
go

create user [Movies] for LOGIN [Movies]
go

alter user [Movies] with DEFAULT_SCHEMA=[dbo]
go

alter role [db_owner] add MEMBER [Movies]
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
