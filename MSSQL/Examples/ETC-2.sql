-- To allow advanced options to be changed.  
EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;  
GO  

execute sp_configure 'Ad Hoc Distributed Queries', 1;
Reconfigure;
go

SELECT * 
FROM OPENDATASOURCE('SQLNCLI', 
		'Data Source=auto-eng.iptime.org,59273;Initial Catalog=Hyundai;User ID=Hyundai;Password=B9037!m8947#;').[Hyunadi].dbo.��ü����
GO  

SELECT *
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=127.0.0.1,59273;Initial Catalog=Demo;User ID=sa;Password=B9037!m8947#'
        ).[Demo].dbo.Person
GO



-- To enable the feature.  
EXECUTE sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO

--	directory: ����� ���ν����� ȣ���� �� �����ϴ� ���͸��Դϴ�. ���� ��� 'D:���'�Դϴ�.
--	depth: ���� �� ���ν����� ǥ�� �ϴ� ���� ���� ���� ���� �˷��ݴϴ�. �⺻��0�� ��� ���� ������ ǥ�õ˴ϴ�.
--	file: �� �����Ӹ� �ƴ϶� ���ϵ� ǥ�õ˴ϴ�. 0�� �⺻������ ������ ǥ�õ��� �ʽ��ϴ�.
master.sys.xp_dirtree 'D:\Temp', 0, 1

exec master..xp_cmdshell 'nslookup auto-eng.iptime.org'
-- Select * From users Where id ='id'; drop table users-- and pwd = 'password'

exec sp_configure
-- 
select * from sys.master_files
Where name like '%TB-Table%'
