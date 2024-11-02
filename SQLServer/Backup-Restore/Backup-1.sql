use Movies
go
DECLARE @Path NVARCHAR(max)
set @Path = N'D:\Backup\DB\movies_backup.bak'

backup database movies
to DISK = @path
WITH init,
NAME = 'Movies Backup',
DESCRIPTION = 'This is an example backup for Movies'
GO
