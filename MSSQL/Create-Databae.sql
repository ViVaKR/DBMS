Use master
Go

Create Database ShopOnline
Go

IF SERVERPROPERTY('ProductVersion') > '12'
 ALTER DATABASE ShopOnline SET QUERY_STORE=ON;
GO

-- 전체복구 모델
Alter database ShopOnline set recovery full
go

-- Korea_Wansung_CI_AS
ALTER DATABASE ShopOnline
COLLATE Korean_Wansung_CI_AS
GO

-- 기본언어 한글
USE ShopOnline
GO
EXEC sp_configure 'default language', 29 ;
GO

RECONFIGURE
GO

ALTER DATABASE ShopOnline SET  MULTI_USER 
GO