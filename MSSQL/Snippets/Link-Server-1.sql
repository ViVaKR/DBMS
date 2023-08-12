sp_configure 'show advanced options', 1;  
RECONFIGURE;
GO 
sp_configure 'Ad Hoc Distributed Queries', 1;  
RECONFIGURE;  
GO  
  
SELECT *
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=외부서버소스;Initial Catalog=데이터베이스;User ID=아이디;Password=비밀번호'
        ).[데이터베이스].dbo.테이블
