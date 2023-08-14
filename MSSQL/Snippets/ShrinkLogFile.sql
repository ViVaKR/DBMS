
use ViVa
go

alter database ViVa
set recovery simple
go

dbcc shrinkfile(N'Hyundai_log', 10)
go

alter database [ViVa]
set recovery full;
go

-- End Line --










