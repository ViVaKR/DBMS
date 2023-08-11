-- 복구모델 바꾸기
Alter Database ddubug
set recovery full

use ddubug
go
select databasepropertyex('ddubug', 'recovery')

-- 임시백업장치
backup database ddubug
to disk = 'e:\backup\backup\ddubug.bak'

GO
-- 영구백업장치 만들기
sp_adddumpdevice 'disk', 'ddubug_device.bak', 'e:\backup\backup\ddubug_device.bak'

-- 영구 백업 장치를 이용한 백업하기
backup database ddubug
to ddubug_device
with init,  -- 백업장치 초기화, OverWrite Backup File
recovery,   -- 추가 복원 없이 복원, 트랜잭션 로그 백업이 없을 때
norecovery	-- 복원한 후 적용할 트랜잭션 로그 백업이 있을때
	
-- [차등백업]
-- 차등 백업 장치 추가
GO

-- OR 
sp_addumpdevice 'disk', 'ddubug_device2', 'd:\backup\backup\ddubug_device2.bak'
GO

-- 차등 백업
backup database [ddubug] 
to ddubug_backup2
with differential
GO

-- 전체 + 차등 복원
use master
go
restore database ddubug
from ddubug_device
with norecovery
go

restore database ddubug
from ddubug_device2
with recovery
