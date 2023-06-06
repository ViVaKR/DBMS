USE [master]
GO

CREATE LOGIN [Member] 
	WITH PASSWORD=N'B9037!m8947#', 
	DEFAULT_DATABASE=[Member], 
	DEFAULT_LANGUAGE=[Korean], 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF
GO

USE [Member]
GO
CREATE USER [Member] FOR LOGIN [Member]
GO

ALTER USER [Member] WITH DEFAULT_SCHEMA=[dbo]
GO

ALTER ROLE [db_owner] ADD MEMBER [Member]
GO