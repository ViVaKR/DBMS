/* 해당 계정만 데이터베이스 보기 */
use master
go

create database [데이터베이스_이름]
go

create login [로그인_이름]
	with password=N'비밀번호',
	default_Database=[데이터베이스_이름],
	check_expiration=off,
	check_policy=off
go

use master
go

deny view any database to [로그인_이름]
go

USE [데이터베이스_이름] -- 해당 데이터베이스
GO

EXEC dbo.sp_changedbowner @loginame = N'로그인_이름', @map = false
go

-- End Line --
