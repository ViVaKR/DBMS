
use [Movies]
go

alter database [Movies]
set recovery simple
go

dbcc shrinkfile(N'Movies_log', 10)
go

alter database [Movies]
set recovery full;
go

-- End Line --










