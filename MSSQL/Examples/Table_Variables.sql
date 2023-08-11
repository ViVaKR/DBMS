--* 테이블을 변수로 생성 (임시테이블과 유사한 기능제공)
declare @TempPeople Table
(
	PersonName nvarchar(max),
	PersonDOB Datetime
)

insert into @TempPeople
select
	ActorName,
	ActorDOB
from
	tblActor
where 
	ActorDOB < '1950-01-01'

select * from @TempPeople
go
