use master;
go

IF  EXISTS (SELECT name
FROM sys.databases
WHERE name = N'ApiTextOrKr')
alter database [ApiTextOrKr] set single_user with rollback immediate;
DROP DATABASE [ApiTextOrKr]
GO

drop login ApiTextOrKr;
go

sp_who2 'active'
kill 60
