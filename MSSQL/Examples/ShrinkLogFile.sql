
use [데이터베이스명]
go

alter database Hyundai
set recovery simple
go

dbcc shrinkfile([데이터베이스_log], 10)
go

alter database [데이터베이스명]
set recovery full;
go

-- End Line --
