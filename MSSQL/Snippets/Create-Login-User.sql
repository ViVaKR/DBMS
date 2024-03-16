
USE [master]
GO
exec sys.sp_helplanguage

CREATE LOGIN [KimBumJun]
	WITH PASSWORD=N'비밀!번호',
	DEFAULT_DATABASE=[KimBumJun],
	DEFAULT_LANGUAGE=[Korean],
	CHECK_EXPIRATION=OFF,
	CHECK_POLICY=OFF
GO

USE [KimBumJun]
GO

CREATE USER [KimBumJun] FOR LOGIN [KimBumJun]
GO

ALTER USER [KimBumJun] WITH DEFAULT_SCHEMA=[dbo]
GO

ALTER ROLE [db_owner] ADD MEMBER [KimBumJun]
GO

-- End Line --
