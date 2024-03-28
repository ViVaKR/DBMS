-- union 견본 : 컬럼수가 동일해야 함
use TutorialDB
go
begin tran
Create Table A반출석부
(
	번호 int primary key,
	이름 nvarchar(10) not null
);
INSERT INTO dbo.A반출석부 (번호, 이름) VALUES (1, '장길산')
INSERT INTO dbo.A반출석부 (번호, 이름) VALUES (2, '일지매')
INSERT INTO dbo.A반출석부 (번호, 이름) VALUES (3, '임꺽정')
go

Create Table B반출석부
(
	번호 int primary key,
	이름 nvarchar(10) not null
);
INSERT INTO dbo.B반출석부 (번호, 이름) VALUES (1, '장길산')
INSERT INTO dbo.B반출석부 (번호, 이름) VALUES (2, '강감찬')
INSERT INTO dbo.B반출석부 (번호, 이름) VALUES (3, '이순신')
go
Commit tran

-- union
select 번호, 이름, 'A반' as 반
from A반출석부
union
select 번호, 이름, 'B반'
from B반출석부
order by 번호

-- union all
select 번호, 이름, 'A반' as 반
from A반출석부
union all
select 번호, 이름, 'B반'
from B반출석부
order by 이름

-- End Line --
