-- 삭제할 데이터 베이스 SPID 확인 후 kill
exec sp_who2
kill 58

use master
go
drop database [DB Name]
go
-- End Line --
