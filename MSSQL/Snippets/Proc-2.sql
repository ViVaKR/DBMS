declare @Names nvarchar(max)
declare @Count int

exec spFilmsInYear @Year = 2000, @FilmList = @Names output, @FilmCount = @Count output
select @Count as [Number of Films],  @Names as [List of Films]

go

declare @Count int
exec @Count = spFilmsInYearReturn @Year = 2000

select @Count as [Number of Films]

go

-- IF 문
declare @NumFilms int
declare @ActionFilms int
set @NumFilms = (select count(*) from tblFilm where FilmStudioID =  3)
set @ActionFilms = (select count(*) from tblFilm where FilmStudioID = 1)

if @NumFilms > 0
	Begin
		Print 'WARNING'
		Print 'There are too name remantic film in the database'
		if @ActionFilms > 10
			begin
				print 'Phew there sar enough'
			end
		else
			begin
				print 'Theree are not enought'
			end
	End
else
	begin
		print 'Information'
		Print 'There ar no more than five romantic films'
	end


select * from tblFilm
exec spVariableData @InfoType='Dlephant'

go

select FilmID, FilmName from tblfilm

select 
	FilmName,
	FilmReleaseDate,
	dbo.fnLongDate(FilmReleaseDate)
from
	tblFilm

select
	DirectorName,
	LEFT(DirectorName, charindex(' ', DirectorName)-1) -- 공란이 있는 텍스트 왼쪽 묶음 가져오기
from
	tblDirector

-- 테이블 반환 함수 호출
select
	FilmName
	,FilmReleaseDate
	,FilmRunTimeMinutes
from
	dbo.FilmInYear(2000, 2002)

-- Multi Table Get (10)
use Movies
go
select 
	* 
from
	dbo.PeopleInYear(1945)

-- (11) CTE, Common Table Expressions
use Movies
go
with EarlyFilms as
(
select
	FilmName,
	FilmReleaseDate,
	FilmRunTimeMinutes
from
	tblFilm
where
	FilmReleaseDate < '2000-01-01'
)
select *
from EarlyFilms
where FilmRunTimeMinutes > 120
--
go
with FilmCounts(Country, NumberOfFilms) as -- 컬럼명 주기
(
select
	FilmCountryID,
	COUNT(*)
from
	tblFilm
group by
	FilmCountryID
)
(
select
	Country,
	NumberOfFilms
from
	FilmCounts

--select
--	AVG([NumberOfFilms])
--from
--	FilmCounts
)
go

-- Muti CTEs
with EarlyFilms As
(
	select
		FilmName,
		FilmReleaseDate
	from
		tblFilm
	Where
		FilmReleaseDate < '2000-01-01'
),
RecentFilms as	-- New
(
	select
		FilmName,
		FilmReleaseDate
	from
		tblFilm
	where FilmReleaseDate >= '2000-01-01'
)
select
	*
from
	EarlyFilms as e
	inner join RecentFilms as r
	on e.FilmName = r.FilmName

-- (12) Cursors, 커서
declare FilmCursor Cursor
	for select FilmID, FilmName, FilmReleaseDate  from tblFilm

open FilmCursor	
	--Do sumething
	fetch next from FilmCursor
	
	--  0 => Fetch 문 성공
	-- -1 => fetch 문 실패 또는 행이 결과 집합 범위를 벗어남
	-- -2 -> 인출된 행이 없습니다.
	while @@FETCH_STATUS = 0
		fetch next from FilmCursor

close FilmCursor
deallocate FilmCursor

go
-- 역순방향 커서
declare FilmCursor Cursor Scroll
	for select FilmID, FilmName, FilmReleaseDate  from tblFilm
open FilmCursor	
	--Do sumething
	-- fetch first from FilmCursor
	fetch last from FilmCursor
	while @@FETCH_STATUS = 0
		-- fetch next from FilmCursor
		fetch prior from FilmCursor

close FilmCursor
deallocate FilmCursor

go

-- 절대값 커서
declare FilmCursor Cursor Scroll
	for select FilmID, FilmName, FilmReleaseDate  from tblFilm
open FilmCursor	

	fetch absolute -10 from FilmCursor -- 절대값 커서 위치
	while @@FETCH_STATUS = 0
		fetch relative -10 from FilmCursor -- 10개 단위로 커서 움직이기

close FilmCursor
deallocate FilmCursor


go

-- (20) 커서 견본 : 저장 프로시저와 연계된 커서 샘플
declare @Id int
declare @Name nvarchar(max)
declare @Date datetime

declare FilmCursor Cursor
	for select FilmID, FilmName, FilmReleaseDate from tblFilm
Open FilmCursor
	Fetch next from FilmCursor
		into @ID, @Name, @Date
	while @@FETCH_STATUS = 0
		begin
			
			-- 이부분을 저장 프로시저로 바꿈..
			--print @Name + ' released on ' + convert(char(10), @Date, 103)
			--print '========================================================'
			--print 'List of Characters'

			--select
			--	CastCharacterName
			--from
			--	tblCast
			--where CastFilmID = @Id

			exec spListCharacters @ID, @Name, @Date

			Fetch next from FilmCursor
				into @ID, @Name, @Date

		end
Close Filmcursor
Deallocate FilmCursor


go

-- 커서의 종류
Declare FilmCursor Cursor scroll  -- Local or Global (기본 옵션 값, 옵션에서 수정 적용)
	-- 커서옵션의 종류: static, keyset, read_only, scroll_locks, optimistic, Globa, forward_only, fast_forward 
	for select FilmId, FilmName, FilmReleaseDate from tblFilm

Open FilmCursor
	
	fetch first from FilmCursor

Close FilmCursor
DeAllocate FilmCursor

-- 커서를 이용한 업데이트 (누적 합계 구하기)
declare @FilmOscars int
declare @TotalOscars int

set @TotalOscars = 0

declare FilmCursor Cursor
	for select FilmOscarWins from tblFilm
	for update of FilmCumulativeOscars -- 업데이트 할 컬럼명

open FilmCursor
	
	fetch next from FilmCursor into @FilmOscars

	while @@FETCH_STATUS = 0
	begin

		set @TotalOscars += @FilmOscars

		update tblFilm
		set FilmCumulativeOscars = @TotalOscars
		where current of FilmCursor

		fetch next from FilmCursor into @FilmOscars

	end

close FilmCursor
deallocate FilmCursor

go

--(21) Dynamic SQL
declare @TableName nvarchar(128)
declare @SQLString nvarchar(max)
declare @Number int
declare @NumberString nvarchar(4)

set @Number = 3
set @NumberString = CAST(@Number as nvarchar(4))
set @TableName = N'tblFilm'
set @SQLString = N'select top ' + @NumberString + ' * from ' + @TableName

-- execute ('select * from tblFilm')
exec sp_executesql @SQLString

go

-- (21) Call Dynamic SQL
exec spVariableTable 'tblFilm', 5 -- 테이블 명과 가져올 갯수 파라미터


--
-- (22) Call
exec spFilmYears '2000, 2001, 2002'

-- Parameters of sp_executesql 견본
exec sp_executesql
	N'select FilmName, FilmReleaseDate, FilmRunTimeMinutes
	From tblFilm
	Where FilmRunTimeMinutes > @Length
	and FilmReleaseDate > @StartDate'
	, N'@Length int, @StartDate DateTime'
	, @Length = 120
	, @StartDate = '2000-01-01'

-- SQL Injection
exec spVariableTable 'tblActor; drop table 테이블명', 5


-- Transactions
declare @IronMan int

begin tran AddIronMan3
-- Adding
insert into tblFilm (FilmName, FilmReleaseDate)
Values ('Iron Man 3', '2013-04-25')

select @IronMan = COUNT(*) from tblFilm where FilmName = 'Iron Man 3'

if @IronMan > 1
	begin
		rollback tran AddIronMan3
		print 'Iron Man 3 was already there'
	end
else
	begin
		commit tran AddIronMan3
		print 'Iron Man 3 add to database'
	end

go

-- Using Error Handing - Transaction
begin try
begin tran AddIm
insert into tblFilm (FilmName, FilmReleaseDate)
Values ('Iron Man 3', '2013-04-25')

update tblFilm
set FilmDirectorID = 4
Where FilmName = 'Iron Man 3'

select * from tblFilm where FilmName = 'Iron Man 3'

commit tran AddIm
end try

begin catch
	Rollback Tran AddIm
	print 'Adding Iron Man failed - check data types'
	-- identity 재설정
		declare @Tbname nvarchar(128)
		declare @MaxId int
		set @Tbname = 'tblFilm'
		select top 1 @MaxId =  FilmID from tblFilm order by FilmID desc
		DBCC CHECKIDENT (@Tbname, RESEED, @MaxId);
		select IDENT_CURRENT(@Tbname)
end catch
go
select * from tblFilm order by FilmID desc

-- Nested transactions basics
begin tran Tran1
	
	print 'Tran = ' +  cast(@@trancount as nvarchar(4))
	
	Save Tran SavePoint
		print 'Tran = ' +  cast(@@trancount as nvarchar(4))
	Rollback tran SavePoint
	print 'Tran = ' +  cast(@@trancount as nvarchar(4))

commit tran Tran1

go

-- (24) Call 
declare @DirectorId int

begin tran AddIm
	
	insert into tblFilm (FilmName, FilmReleaseDate)
	values ('Iron Man 3', '2013-04-25')

	--Call stored procedure to get DirectorID
	exec @DirectorId = spGetDirector 'Shane Black'

	update tblFilm
	set FilmDirectorID = @DirectorId
	where FilmName = 'Iron Man 3'

commit tran AddIm

select * from tblFilm where FilmName = 'Iron Man 3'
select * from tblDirector where DirectorName = 'Shane Black'

update tblDirector set DirectorName = 'Shane Black' where DirectorID = 126
-- 
-- 임시 삭제
delete from tblFilm where FilmName = 'Iron Man 3'

select * from tblFilm order by FilmID desc

		declare @Tbname nvarchar(128)
		declare @MaxId int
		set @Tbname = 'tblFilm'
		select top 1 @MaxId =  FilmID from tblFilm order by FilmID desc
		DBCC CHECKIDENT (@Tbname, RESEED, @MaxId);
		select IDENT_CURRENT(@Tbname)

		select * from tblDirector

-- Triggers ------------------------
-- DML : Data Manipulation Language (Insert, Update, Delete), Can be After or Instead of, Attached to Tables or Views
-- DDL : Data Definition Language
-- Logon
------------------------------------

-- (1) Trigger Call
use Movies
go

set nocount on

insert into tblActor(ActorID, ActorName)
values (999, 'Test Actor')

update tblActor
Set ActorDOB = GETDATE()
where ActorId = 999

delete from tblActor
Where ActorID = 999

-- (2) Trigger Inserted 삽입금지
use Movies
go

set nocount on
insert into tblActor (ActorID, ActorName)
values (999, 'New Actor')
go

select * from tblActor Where ActorID = 999

-- update tblActor set ActorDateOfDeath = '2013-11-22' where ActorID = 999
-- (4) -- 사망한 배우가 있을 때 삽입 방지
use Movies
go

insert into tblCast(CastID, CastActorID, CastFilmID, CastCharacterName)
Values(9999, 999, 333, 'Random Red Shirt')

select * from tblCast order by CastID desc


--DDL Trigger in SQL Server
-- Data definition Events

--(5) 테이블 생성 방지 트리거 테스트
create table tblTest(Id int)
go
create table #tblTest(Id int) -- 임시테이블은 영향 받지 않음

drop table tblTest

--
use Movies
go
exec sp_settriggerorder
	@triggername = 'trgFirstTrigger',
	@order = 'first',
	@stmttype = 'create_table',
	@namespace = 'Database'

-- End Line --
