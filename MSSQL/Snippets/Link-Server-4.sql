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
	@datasrc='domain.com',
	@catalog='DbName'
go
exec sp_addlinkedsrvlogin
	@rmtsrvname='������',
	@useself='false',
	@rmtuser='Id',
	@rmtpassword=N'��й�ȣ'
go


SELECT * FROM master.dbo.sysservers WHERE srvname = '������'
SELECT * FROM master.sys.linked_logins WHERE remote_name = '�����ͺ��̽���'

select * from ������.�����ͺ��̽���.dbo.�����Լ�

create table ������.�����ͺ��̽���.dbo.Test (
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

insert into AUTO.DMS.dbo.Exam (Fname) select Fname from Exam

go
-- ����
exec sp_droplinkedsrvlogin @rmtsrvname= 'Docker',@locallogin = NULL
exec sp_dropserver @server='Docker'

exec sp_testlinkedserver @servername=AUTO
