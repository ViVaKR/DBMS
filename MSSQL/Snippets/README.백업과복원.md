# MS SQL Server 백업 / 복구 시나리오  

I. 백업의 종류  

1. 전체 백업(full backup)  
: 데이터 전체를 백업한다. 또한 진행 중인 트랜잭션의 로그도 받는다.  
(로그 전체를 백업 받는 것은 아니다.)  

2. 차등 백업(differential backup)  
: 마지막 전체 백업 이후 변경된 모든 데이터 페이지를 백업한다.  
따라서 전체 백업을 받은 후 차등 백업을 두 번 받았다면 두번째 차등백업은 첫번째  
차등백업의 내용도 포함하고 있다.  
백업 시간은 오래 걸리지만 복원 속도가 빠르다는 장점이 있다.  

3. 트랜잭션 로그 백업(transaction log backup)  
: 일종의 incremental 백업으로, 로그 백업을 받으면 백업 받은 로그는 지워지므로  
동일한 내용이 다시 백업 되지 않는다. 따라서 로그 백업은 전에 받은 로그 백업  
이후의 것만 백업이 된다. 백업은 빠르지만 복원은 전체백업을 복구한 후 각각의  
로그 백업을 복구해야 하므로 시간이 오래 걸린다.  
또한 만약 중간의 로그 백업을 잃어 버리면 그 전의 로그 백업까지의 데이터만 살릴  
수 있다.  

II. 기본적인 복구 시나리오 3종

- 전체백업에서 복구  
- differential 백업에서 복구  
- transaction log 백업에서 복구  

1. 전체 백업에서 복원하기  
: 전체 백업에서 복원은 항상 마지막 전체 백업으로부터 복원을 한다.  
다음 작업은 백업을 위한 디바이스를 만들고 데이터를 변경한 후,  
전체백업을 받고 이 백업을 이용해 복원을 하는 과정이다.  

2. 백업 디바이스 만들기  
sp_addumpdevice 'disk','pubs_bak','c:\pubsbk.bak'  
(C:\에 pubsbk.bak라는 백업 디바이스를 만들고 이름을 pubs_bak라 한다.)  

3. pubs database를 변경한 후 변경을 확인한다.  
create table test1 (id int, name char(10))  
insert test1 values (1, '사용자1')  
select * from test1 (“1, 사용자1”이 나타난다.)  

3) pubs database를 백업 받는다.  
backup database pubs to pubs_bak  

4) 문제를 발생시키고 난 후(pubs를 지운 후), 기존의 백업으로부터 복원을 한다.  
use master  
drop database pubs  
go  
restore database pubs from pubs_bak  

5) 복구된 데이터를 확인한다.  
use pubs  
select * from test1  

2. Differential 백업에서 복구하기  
: differential 백업의 특징은 매번 백업을 받을 때마다 이전 전체백업 이후의 모든  
데이터를 다시 백업 받는다는 것이다. 따라서 모든 데이터가 백업을 받을 때마다  
중복되어 받으므로 백업 시간이 오래 걸린다. 하지만 복원 시에는 전체 백업과  
마지막에 받은 differential 백업만 있으면 되므로 복원속도가 상당히 빠르다.  

다음 작업은 전체 백업을 받은 후 두 번의 differential 백업을 받은 후 복원 시에는  
전체 백업과 두번째의 differential 백업을 가지고 복원하는 과정을 나타낸 것이다.  

또한 특기할 만한 사항은 데이터가 손상되어 database에 접근을 할 수 없는 경우에도  
그때까지의 로그를 받을 수 있다는 것이다.  

backup log … with no_truncate 옵션을 사용하면 된다.  

1) 백업 디바이스를 만든다.  
exec sp_addumpdevice 'disk', 'pubs_full', 'c:\pubs_full.bak'  
exec sp_addumpdevice 'disk', 'pubs_diff1', 'c:\pubs_diff1.bak'  
exec sp_addumpdevice 'disk', 'pubs_diff2', 'c:\pubs_diff2.bak'  
exec sp_addumpdevice 'disk', 'pubs_log', 'c:\pubs_log.bak'  
(전체백업용, 각각의 differential 백업용, 로그 백업용)  

2) pubs database를 완전복구 모드로 변경한다.  
alter database pubs set recovery full  
exec sp_helpdb pubs  

3) db를 변경한다.  
use pubs  
go  
create table test_diff (name char(10), score int)  
insert test_diff values('학생1', 100)  
go  
select * from test_diff (=> “학생1, 100”이 출력된다.)  

4) pubs database를 full backup한다.  
backup database pubs to pubs_full  

5) db를 변경한다.  
insert test_diff values('학생2', 900)  
select * from test_diff (=> “학생1, 100”, “학생2, 90”이 출력된다.)  

6) 첫번째 differential 백업을 한다.  
backup database pubs to pubs_diff1 with differential  

7) db를 다시 변경한다.  
insert test_diff values('학생3', 80)  
select * from test_diff  
(=> “학생1, 100”, “학생2, 90”, “학생3, 80”이 출력된다.)  

두번째 differential 백업을 받는다.  
backup database pubs to pubs_diff2 with differential  

9) db를 변경한다.  
insert test_diff values ('학생4', 60)  
select * from test_diff  
(=> “학생1, 100”, “학생2, 90”, “학생3, 80”, “학생4, 60”가 출력된다.)  

10) db에 문제를 발생시킨다.  
SQL Server 서비스를 정지한 후, pubs database의 data file(pubs.mdf)을  
지운다. 다시 SQL Server 서비스를 시작하면, pubs database가 suspect상태가  
된다.  

11) pubs database에 대한 log를 백업 받는다.  
비록 pubs database는 문제가 발생하여 접근할 수 없지만, log는 받을 수 있다.  
backup log pubs to pubs_log with no_truncate  

12) pubs database를 복원한다.  
이때 필요한 백업은 다음과 같다.  

a. 전체 백업.  
b. 두번째 differential 백업.  
c.마지막에 받은 로그 백업.  
use master  
go  
restore database pubs from pubs_full with norecovery  
restore database pubs from pubs_diff2 with norecovery  
restore log pubs from pubs_log  
(이 때 마지막 백업을 복원하는 것 외에는 반드시 with norecovery 옵션을  
붙여줘야 한다. norecovery옵션은 다음에 더 복원될 부분이 남아있다는 뜻.)  

13) select를 이용하여 데이터가 다 복구되었는지 알아본다.  
use pubs  
go  
select * from test_diff (=> differential 백업 이후에 추가된 사항에 대해서도  
완벽하게 복구되는 것을 알 수 있다.)  

3. Transactional Log 백업에서 복구하기  
: transactional log 백업은 전체 백업 후 변경된 부분을 백업을 받는다. 백업 후에는  
로그를 지워버리므로 로그백업을 받으면 이전 백업 받은 다음 부분부터 백업을  
받는다. 이 방법은 백업시간은 단축되지만 복원은 전체 백업과 모든 로그 백업이  
있어야 하므로 시간이 많이 걸린다. 또한 중간의 로그를 잃어 버리면 그 다음 로그는  
백업에 사용될 수 없다.  

이 작업에서는 전체백업을 받은 후 로그 백업을 여러 번 받고 복원 시 전체 백업과  
각각의 로그 백업을 이용하는 것을 보여준다.  

1) 백업에 사용될 디바이스를 만든다.  
(전체백업, 각각의 로그 백업을 위한 디바이스를 만든다.)  

use master  
go  
exec sp_addumpdevice 'disk', 'nwind_full', 'c:\nwindfull.bak'  
exec sp_addumpdevice 'disk', 'nwind_log1', 'c:\nwindlog1.bak'  
exec sp_addumpdevice 'disk', 'nwind_log2', 'c:\nwindlog2.bak'  
exec sp_addumpdevice 'disk', 'nwind_log', 'c:\nwindlog.bak'  

2) northwind database를 완전복구 모드로 바꾼다.  
alter database northwind set recovery full  
exec sp_helpdb northwind  

3) database에 새로운 테이블을 만들고 데이터를 입력한다.  
use northwind  
go  
create table nwind_log (id int, name char(10))  
go  
select * from nwind_log  
go  

insert nwind_log values(1, '손님1')  
select * from nwind_log  

4) 전체 백업을 받는다.  
backup database northwind to nwind_full  
go  

5) 데이터를 추가한다.  
insert nwind_log values(2, '손님2')  
select * from nwind_log  

6) 첫번째 로그 백업을 받는다.  
backup log northwind to nwind_log1  

7) 데이터를 추가한다.  
insert nwind_log values(3, '손님3')  
select * from nwind_log  

두번째 로그 백업을 받는다.  
backup log northwind to nwind_log2  

9) 데이터를 추가한다.  
insert nwind_log values (4, '손님4')  
select * from nwind_log  

10) 장애를 발생시킨다.  
(SQL Server 서비스를 멈춘 후 northwnd.mdf 파일을 삭제하고 다시 SQL Server  
서비스를 시작한다. 그러면 northwind database가 suspect 상태로 된다.)  

11) 장애가 발생한 시점까지의 로그를 백업 받는다.  
backup log northwind to nwind_log with no_truncate  

12) 복원을 하는데 이번에는 전체 백업과 모든 로그 백업이 필요하다.  
use master  
go  
restore database northwind from nwind_full with norecovery  
restore log northwind from nwind_log1 with norecovery  
restore log northwind from nwind_log2 with norecovery  
restore log northwind from nwind_log  

13) 데이터를 다시 select하여 모든 데이터가 들어있는 것을 확인한다.  
use northwind  
go  
select * from nwind_log  

III. 고급 복구 시나리오  
- 파일그룹 백업 및 복구  
- 특정 시점으로 복원하기(stopat, stopatmark등)  
- 데이터 파일로부터 복원(sp_attach_db, sp_attach_single_file_db등)  

1. 파일 그룹 백업 및 복구  
: 파일 그룹은 대용량 DB를 유지관리하기 쉽게 하기 위해 생겨난 개념으로 데이터를  
각각 다른 하드에 분산 저장하며 백업과 복원을 각 파일 그룹별로 할 수 있어 전체  
데이터베이스를 백업할 때에 비해 월등한 속도향상과 편의성을 제공한다.  

이 작업에서는 파일 그룹을 생성한 후 각 파일 그룹별로 백업을 받고 그 중 하나의  
데이터 파일이 손상되었을 때 복원하는 방법을 알아 본다.  

1) 파일 그룹 생성.  
CREATE DATABASE fileG ON (NAME = fileG, FILENAME = 'c:\data\fileG.mdf'  
, SIZE = 10),  
FILEGROUP fileG2 (NAME = fileG2, FILENAME = 'd:\data\fileG2.ndf'  
, SIZE = 10),  
FILEGROUP fileG3 (NAME = fileG3, FILENAME = 'e:\data\fileG3.ndf'  
, SIZE = 10)  
LOG ON (NAME = 'fileGLog', FILENAME = 'f:\data\fileG.ldf', SIZE = 5MB)  
GO  

: fileG database의 data부분을 C:, D:, E:에 나누어서 생성을 하였고,  
로그도 F: 드라이브에 별도로 생성을 하였음.  

2) 데이터를 추가한다.  
use fileG  

create table a(id int)  
create table b(id int)on fileG2  
create table c(id int)on fileG3  
EXEC sp_helpdb fileG  

3) 전체 백업을 받는다.  
backup database fileG to disk='c:\full.bak'  

4) primary file Group에 데이터를 집어 넣는다.  
insert a values(1)  

5) primary file Group만 백업을 받는다.  
backup database fileG filegroup='primary'  
to disk='c:\file1.bak'  

6) 데이터를 fileG2와 fileG3에도 넣는다.  
insert b values(1)  
insert c values(1)  

7) fileG에 대해 로그 백업을 받는다.  
backup log fileG to disk='c:\log1.bak'  

두번째 파일 그룹인 fileG2에 대한 데이터 백업을 받는다.  
backup database fileG filegroup='fileG2' to disk='c:\file2.bak'  

9) 데이터를 추가한다.  
insert b values(2)  
insert c values(2)  
insert a values(2)  

10) fileG에 대한 로그 백업을 받는다.  
backup log fileG to disk='c:\log2.bak'  

11) 세번째 파일 그룹인 fileG3에 대해 백업을 받는다.  
backup database fileG filegroup='fileG3'  
to disk='c:\file3.bak'  

12) 데이터를 업데이트 한다.  
insert c values(3)  
insert a values(3)  
insert b values(3)  

13) 이 때 장애가 세번째 파일 그룹의 데이터 파일이 손상되었다.  
(fileG3.ndf를 삭제한다.)  

14) 이 때까지의 로그를 받는다.  
backup log fileG to disk='c:\log3.bak'  
with init,no_truncate  

15) 이제 손상된 fileG를 복원한다.  
이때는 전체 백업을 복구하는 것이 아니라 세번째 파일 그룹에 대한 백업과  
마지막에 받은 로그를 가지고 복원을 한다.  

restore database fileG filegroup='fileG3'  
from disk='c:\file3.bak'with norecovery  

restore log fileG from disk='c:\log3.bak'  

16) fileG의 모든 table을 select 해 본다.  
use fileG  
go  
select * from a  
select * from b  
select * from c  

모든 항목들이 다 나와 있음을 알 수 있다.  
File Group의 특징은 대용량 데이터 베이스를 백업 및 복원을 할 때 모든  
데이터에 대하여 하는 것이 아니라 file Group 별로 나누어 백업을 하고 특정  
파일그룹이 깨진 경우에는 해당되는 file Group의 백업만 복원해 주면 되므로  
백업과 복원에 시간이 적게 걸리게 되어 유지보수에 유용한 모델이다.  

2. 특정 시점으로 복원하기.  
: stopat, stopatmark, stopbeforemark  

1) stopat  
: 데이터를 원하는 시점으로 되돌릴 수 있는 방법.  
다음과 같은 경우에 적용된다.  
a. 오전 9:00 전체백업  
b. 다양한 작업을 함.  
c. 오전 10:00 실수로 where 절 없이 delete문 수행하여 테이블 A의 모든 데이터를  
지움.  
d. 오전 10:30분 로그 백업.  
e. 11:00 대량으로 잘못된 작업이 수행되었음을 발견.  

이 때는 다음과 같이 작업해 준다.  
ㄱ. 전체백업을 복원한다.  
ㄴ. 백업된 로그를 복원하면서 다음과 같은 옵션을 준다.  
RESTORE LOG … FROM …  
WITH STOPAT = ‘2001-12-24 10:00:01  

예제] pubs db를 이용하여 stopat을 테스트 해 본다.  
a. 현재의 titles.price 컬럼의 가격이 얼마로 시작되는지 확인한다.  
SELECT TOP 1 price FROM pubs..titles (19.99가 나온다.)  
b. pubs database를 전체복구 모드로 바꾼다.  
ALTER DATABASE pubs SET RECOVERY full  
Exec sp_helpdb pubs  
c. pubs database를 전체백업 받는다.  
BACKUP DATABASE pubs to disk = ‘c:\pubsfull.bak’  
d. titles의 값을 두배로 만든다.  
UPDATE pubs..titles SET price=price*2  
SELECT TOP 1 price FROM pubs..titles (39.98이 나온다.)  
e. log 백업을 받는다.  
BACKUP LOG pubs to disk = ‘c:\pubslog1.bak’  
f. 한번 더 가격을 인상한다.  
UPDATE pubs..titles SET price=price*2  
SELECT TOP 1 price FROM pubs..titles (79.96이 나온다.)  
g. 서버의 시간을 기록한다.  
SELECT getdate()  
h. 이번에는 titles의 값을 전부 100으로 변경한다.  
(이 작업은 잠시 시차를 두고 하는 것이 좋다.)  
UPDATE pubs..titles SET price = 100  
SELECT TOP 1 price FROM pubs..titles (100이 나온다.)  
i. 다시 한번 로그 백업을 받는다.  
BACKUP LOG pubs to disk = ‘c:\pubslog2.bak’  
j. 지금 현재 full 백업과 로그 백업이 2개가 있다.  
각각을 사용하여 복원을 시도해 보면 다음과 같은 결과가 나온다.  

Full 백업만 사용하여 복원한 경우  
RESTORE DATABASE pubs FROM disk = ‘c:\pubsfull.bak’  
SELECT TOP 1 price FROM pubs..titles (19.99가 나온다.)  

첫번째 로그까지 사용하여 복원한 경우  
RESTORE DATABASE pubs FROM disk = ‘c:\pubsfull.bak  
WITH NORECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\pubslog1.bak’  
SELECT TOP 1 price FROM pubs..titles (39.98이 나온다.)  

두번째 로그까지 사용하여 복원한 경우  
RESTORE DATABASE pubs FROM disk = ‘c:\pubsfull.bak’  
WITH NORECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\pubslog1.bak’  
WITH NORECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\pubslog2.bak’  
SELECT TOP 1 price FROM pubs..titles (100이 나온다.)  
잘못된 작업을 하기 전의 데이터로 돌리려면 STOPAT 옵션을 사용한다.  

RESTORE DATABASE pubs FROM disk =’c:\pubsfull.bak’  
WITH NO RECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\pubslog1.bak’  
WITH NORECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\pubslog2.bak’  
WITH STOPAT = ‘2001-12-24 14:53:07.310’(잘못된 작업을 하기 전의 시간)  

SELECT TOP 1 price FROM pubs..titles  
(79.96이 나온다. 즉, 잘못된 작업을 하기 전의 값이 나온다.)  

일반적으로 STOPAT 옵션은 시간을 기억해서 올바른 시간을 입력해야 한다는 부담이  
있다. 이것을 극복하기 위해 나온 옵션이 STOPATMARK 옵션이다.  

2) STOPATMARK, STOPBEFOREMARK  
: STOPAT옵션이 시간을 기반으로 되돌리는 작업을 했다면, STOPATMARK는 해당 MARK까지  
복원한다. 이를 사용하기 위해서는 트랜잭션을 시작할 때 마크를 지정해야 한다.  

BEGIN TRAN tran1 WITH MARK  
… (해당작업)  
COMMIT  

복원 시는 다음과 같이 사용한다.  

RESTORE LOG … FROM …  
WITH STOPATMARK = ‘tran1’  

Transaction이 여러 번 사용되었으면 다음과 같이 AFTER 옵션을 준다.  
WITH STOPAT = ‘tran1’ AFTER 2001-12-24 14:53:07.310  
STOPATMARK는 해당 트랜잭션까지 복원하고,  
STOPBEFOREMARK는 해당 트랜잭션 직전에서 복원을 중지한다.  

예제] stopatmark를 이용하여 데이터 복구하기  
a. pubs database를 Full 복원모드로 변경한 후 전체 백업을 받는다.  
ALTER DATABASE pubs SET RECOVERY FULL  
BACKUP DATABASE pubs to disk = ‘c:\fullpubs.bak’  
b. sales table에 총 21건의 데이터가 있음을 확인하다.  
use pubs  
select count(*) from sales  
c. 다음과 같은 트랜잭션에 표시를 주고 시작한다.  
Begin tran tran1 WITH MARK  
set rowcount 10  
delete sales  
set rowcount 0  
select count(*) from sales  
COMMIT (10개의 행이 지워져 총 11행이 남는다.)  
d. 다시 모든 행을 지운다.  
delete sales  
e. 로그 백업을 한다.  
BACKUP LOG pubs to disk = ‘c:\log1.bak’  
f. 백업을 모두 복원한다.  
use master  
RESTORE DATABASE pubs FROM disk = ‘c:\fullpubs.bak’  
WITH NORECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\log1.bak’  
SELECT count(*) from pubs..sales  
( 0개가 나온다.)  
g. STOPATMARK를 사용하여 transaction의 끝까지만 복원을 한다.  
RESTORE DATABASE pubs FROM disk = ‘c:\fullpubs.bak’  
WITH NORECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\log1.bak’  
WITH STOPATMARK = ‘tran1’  
SELECT count(*) from pubs..sales  
(11건의 데어터가 나온다.)  

h. STOPBEFOREMARK를 사용하여 표시된 트랜잭션 작업 직전까지만 복원한다.  
RESTORE DATABASE pubs FROM disk = ‘c:\fullpubs.bak’  
WITH NORECOVERY  
RESTORE LOG pubs FROM disk = ‘c:\log1.bak’  
WITH STOPBEFOREMARK = ‘tran1’  

SELECT count(*) from pubs..sales  
(21건이 나온다.)  

3) 데이터 파일로부터 복원  
: sp_attach_db, sp_detach_db, sp_attach_single_file_db  
DB를 복구하려고 하는데 백업본이 없고 데이터 파일과 로그 파일만 있는 경우 또는  
데이터 파일만 있는 경우 이 파일들을 이용하여 데이터베이스를 복원할 수 있다.  

a. sp_attach_db  
: 데이터와 로그 파일을 모두 가지고 있는 경우 사용되는 방법으로 사용법은  
다음과 같다.  

sp_attach_db ‘test’, ‘c:\data\test.mdf’,  
‘c:\data\test_log.ldf’  
(test.mdf와 test_log.ldf 두 개의 파일이 있을 때 이 파일을 이용하여  
test라는 database를 만든다.)  

b. sp_attach_single_file_db  
: 로그 파일은 없고 데이터 파일만 남은 경우 사용한다.  

sp_attach_single_file_db ‘test’, ‘c:\data\test.mdf’  
(test.mdf 데이터 파일만 가지고 test db를 다시 만들었다.  
이 때 로그는 새로 만들어 진다.)  

c. sp_detach_db  
: 기존의 database를 data와 log 파일만 남겨 놓은 채 지워버린다.  

sp_detach_db ‘test’  
(test database를 지운 후 데이터 파일과 로그 파일만 남긴다.  
이 프로시저는 sp_attach_db와 같이 사용되어 한 서버에  
있는 데이터베이스를 다른 서버로 이동할 때 사용된다.)  

예제] sp_detach_db와 sp_attach_db, sp_attach_single_file_db 를 이용하기  

a. pubs database를 detach 한다.  
sp_detach_db pubs  

b. select를 수행하여 pubs database의 테이블을 query한다.  
SELECT * from pubs..titles  
(pubs database를 찾을 수 없다고 나온다.)  

c. pubs.mdf와 pubs_log.ldf를 c:\data 폴더로 옮긴다.  

d. pubs database를 attach한다.  
sp_attach_db 'pubs', 'c:\data\pubs.mdf',  
'c:\data\pubs_log.ldf'  

e. SELECT를 하여 pubs database가 다시 사용가능한 것을 확인한다.  
SELECT * from pubs..titles  
(결과값이 출력되는 것을 확인할 수 있다.)  

f. 다시 pubs database를 detach한다.  
sp_detach_db pubs  

g. 로그파일(pubs_log.ldf)을 삭제한다.  

h. sp_attach_single_file_db를 실행한다.  
sp_attach_single_file_db ‘pubs’, ‘c:\data\pubs.mdf’  
(pubs database가 다시 생기고 log도 다시 생성되어 있음을 알 수 있다.)
