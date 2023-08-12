
USE [master]
GO

CREATE LOGIN [로그인명] 
	WITH PASSWORD=N'비밀번호', 
	DEFAULT_DATABASE=[기본데이터베이스명], 
	DEFAULT_LANGUAGE=[Korean], 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF
GO

USE [데이터베이스명]
GO
CREATE USER [사용자명] FOR LOGIN [로그인명]
GO

ALTER USER [사용자명] WITH DEFAULT_SCHEMA=[dbo]
GO

ALTER ROLE [db_owner] ADD MEMBER [사용자명]
GO

-- End Line --
