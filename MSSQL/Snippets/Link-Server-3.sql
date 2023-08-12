EXEC sp_dropserver 'Docker', 'droplogins';
GO

EXEC sp_addlinkedserver 
    @server=N'Docker', 
    @srvproduct=N'', 
    --@provider=N'SQLNCLI', 
	@provider=N'MSOLEDBSQL', 
    @datasrc=N'<....>'
	-- @catalog=N'Demo';

EXEC sp_addlinkedserver @server=N'<....>', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'<...>', @catalog=N'<...>';
GO

EXEC sp_addlinkedsrvlogin @rmtsrvname=N'Docker', @useself=N'FALSE', @locallogin=NULL, @rmtuser=N'<...>', @rmtpassword=N'<...>';
GO

SELECT [Id]
      ,[Fname]
      ,[Age]
  FROM [Docker].[Demo].[dbo].[Test]
GO

exec sp_testlinkedserver @servername=Docker

use TutorialDB
go

SELECT  Top 10 * into Test2
FROM OPENDATASOURCE('MSOLEDBSQL','Server=<...>;Database=<...>;User ID=<...>;Password=<비밀번호>;').서버.dbo.테이블
-- (작업확인)
Update OPENDATASOURCE('MSOLEDBSQL','Server=<...>;Database=<>>>>;User ID=<...>;Password=<비밀번호>;').서버.dbo.테이블 set 수량 = 3 where 번호 = 'TD20110103210433'

select * from Test
