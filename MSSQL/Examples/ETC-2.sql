-- To allow advanced options to be changed.  
EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;  
GO  

execute sp_configure 'Ad Hoc Distributed Queries', 1;
Reconfigure;
go

SELECT * 
FROM OPENDATASOURCE('SQLNCLI', 
		'Data Source=auto-eng.iptime.org,59273;Initial Catalog=Hyundai;User ID=Hyundai;Password=B9037!m8947#;').[Hyunadi].dbo.업체정보
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

--	directory: 저장된 프로시저를 호출할 때 전달하는 디렉터리입니다. 예를 들어 'D:백업'입니다.
--	depth: 저장 된 프로시저에 표시 하는 하위 폴더 수준 수를 알려줍니다. 기본값0은 모든 하위 폴더가 표시됩니다.
--	file: 각 폴더뿐만 아니라 파일도 표시됩니다. 0의 기본값에는 파일이 표시되지 않습니다.
master.sys.xp_dirtree 'D:\Temp', 0, 1

exec master..xp_cmdshell 'nslookup auto-eng.iptime.org'
-- Select * From users Where id ='id'; drop table users-- and pwd = 'password'

exec sp_configure
-- 
select * from sys.master_files
Where name like '%TB-Table%'
