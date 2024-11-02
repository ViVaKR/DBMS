use master
go

select * from sys.master_files where name like '%Movie%'

DECLARE @Path NVARCHAR(max)
set @Path = N'<Path>\Movie_full.bak'
restore filelistonly from disk = @Path

set @Path = N'<Path>\Movie_full.bak'
restore database Movies
from disk = @Path
with recovery,
move 'Movie' to '<Drive:>\DataBase\Data\Movies_Primary.mdf',
move 'Movie_log' to '<Drive:>\DataBase\Data\Movies_Primary.ldf',
replace
go
