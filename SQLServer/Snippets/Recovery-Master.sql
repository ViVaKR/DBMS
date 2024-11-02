
--단일사용자모드
--(1) net stop mssqlserver
--(2) net start mssqlserver /m

--! 마스터 복원
use master
go

restore database master from masterdb
with recovery
go

use master
go
restore database master
from disk = 'C:\Temp\masterdb.bak'
with recovery
go

-- End Line --
