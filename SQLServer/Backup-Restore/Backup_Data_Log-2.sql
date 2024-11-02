use Movies
go

DECLARE @Path NVARCHAR(max)
set @Path = N'<Drive Letter>:\Backup\DB\<File Name>.bak'

backup database movies
to DISK = @path
WITH format,
medianame = 'MoviesBackups',
NAME = 'Full Backup of Movies'
GO

select * from sys.backup_devices
-- Backup Log
use Movies
go
DECLARE @Path NVARCHAR(max)
set @Path = N'<Drive Letter>:\Backup\DB\<Log File Name>.bak'

BACKUP LOG Movies
to DISK = @Path
with init,
NAME = 'MoviesBackupLog'
go
