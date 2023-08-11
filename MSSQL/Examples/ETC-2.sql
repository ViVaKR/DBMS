-- To allow advanced options to be changed.  
EXECUTE sp_configure 'show advanced options', 1;
RECONFIGURE;  
GO  

execute sp_configure 'Ad Hoc Distributed Queries', 1;
Reconfigure;
go

SELECT * 
FROM OPENDATASOURCE('SQLNCLI', 
		'Data Source=서버주소;Initial Catalog=데이터베이스;User ID=아이디;Password=비밀번호;').[Hyunadi].dbo.테이블명
GO  

SELECT *
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=서버주소;Initial Catalog=데이터베이스;User ID=아이디;Password=비밀번호'
        ).[Demo].dbo.테이블명
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

exec master..xp_cmdshell 'nslookup 도메인'

exec sp_configure
-- 
select * from sys.master_files
Where name like '%TB-Table%'
