use master
go

EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

exec sp_addlinkedserver
	@server='������',
	@srvproduct='',
	@provider='SQLOLEDB',
	@datasrc='Database Source',
	@catalog='DMS'
go
exec sp_addlinkedsrvlogin
	@rmtsrvname='������',
	@useself='false',
	@rmtuser='�����',
	@rmtpassword=N'��й�ȣ'
go


SELECT * FROM master.dbo.sysservers WHERE srvname = '������'
SELECT * FROM master.sys.linked_logins WHERE remote_name = 'Dms'

select * from AUTO.DMS.dbo.���̺��

create table AUTO.DMS.dbo.Test (
	Id int primary key identity,
	Fname nvarchar(20)
);

use dms
go

-- ��ũ������ ���̺� Ǫ��
INSERT INTO [server_b].[database].[schema].[table]
SELECT * FROM [database].[schema].[table]

-- ��ũ�������� ���� ������
SELECT * INTO [database].[schema].[table]
FROM [server_a].[database].[schema].[table]

--Declare @sql nvarchar(max)
--set @sql = 'select * into AUTO.DMS.dbo.Test2 from Exam'
--exec sp_executesql @sql

insert into AUTO.DMS.dbo.Exam (Fname) select Fname from Exam

-- insert into linkdb.db11000.u111000.income_board select * from amendb.[dbo].income_board
--"Provider=SQLOLEDB;Data Source=auto-eng.iptime.org,59273;Initial Catalog=DMS;User ID=DmsLogin;Password=B9037!m8947#"

go
-- ����
exec sp_droplinkedsrvlogin @rmtsrvname= 'Docker',@locallogin = NULL
exec sp_dropserver @server='Docker'

exec sp_testlinkedserver @servername=������

-- End Line --
