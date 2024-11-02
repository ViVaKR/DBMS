use master
go

EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

exec sp_addlinkedserver
	@server='서버명',
	@srvproduct='',
	@provider='SQLOLEDB',
	@datasrc='domain.com',
	@catalog='DbName'
go
exec sp_addlinkedsrvlogin
	@rmtsrvname='서버명',
	@useself='false',
	@rmtuser='Id',
	@rmtpassword=N'비밀번호'
go


SELECT * FROM master.dbo.sysservers WHERE srvname = '서버명'
SELECT * FROM master.sys.linked_logins WHERE remote_name = '데이터베이스명'

select * from 서버명.데이터베이스명.dbo.엑셀함수

create table 서버명.데이터베이스명.dbo.Test (
	Id int primary key identity,
	Fname nvarchar(20)
);

use dms
go

-- 링크서버로 테이블 푸시
INSERT INTO [server_b].[database].[schema].[table]
SELECT * FROM [database].[schema].[table]

-- 링크서버에서 로컬 서버로
SELECT * INTO [database].[schema].[table]
FROM [server_a].[database].[schema].[table]

insert into AUTO.DMS.dbo.Exam (Fname) select Fname from Exam

go
-- 삭제
exec sp_droplinkedsrvlogin @rmtsrvname= 'Docker',@locallogin = NULL
exec sp_dropserver @server='Docker'

exec sp_testlinkedserver @servername=AUTO
