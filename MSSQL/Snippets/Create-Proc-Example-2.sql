use Movies
go
-- begin new batch

Create proc spFilmList
as
begin
	select
		FilmName,
		FilmReleaseDate,
		FilmRunTimeMinutes
	from
		tblFilm
	order by
		FilmName asc
end

go

Alter proc spFilmCriteria
	(
	@MinLength as int = null,
	@MaxLength as int = null,
	@Title as nvarchar(Max)
)
as
begin
	select
		FilmName,
		FilmRunTimeMinutes
	from
		tblFilm
	where
		(@MinLength is null or FilmRunTimeMinutes >= @MinLength) and
		(@MaxLength is null or FilmRunTimeMinutes <= @MaxLength) and
		FilmName like '%' +  @Title + '%'
	order by
		FilmRunTimeMinutes asc
end

go
alter proc spFilmList
as
begin
	select
		FilmName,
		FilmReleaseDate,
		FilmRunTimeMinutes,
		FilmOscarNominations
	from
		tblFilm
	order by
		FilmName
end


drop proc spFilmList

set nocount on

declare @MyDate datetime
declare @NumFilms int
declare @NumActors int
declare @NumDirector int

set @MyDate = '1980-01-01'
set @NumFilms = (select COUNT(*)
from tblFilm
where FilmReleaseDate >= @MyDate)
set @NumActors = (select COUNT(*)
from tblActor
where ActorDOB >= @MyDate)
set @NumDirector = (select count(*)
from tblDirector
where DirectorDOB >= @MyDate)


	select 'Number of films', @NumFilms
union
	select 'Number of actors', @NumActors

print 'Number of films = ' + cast(@NumFilms as nvarchar(max))
print 'Number of Actors = ' + cast(@NumActors as nvarchar(max))
print 'Number of Director = ' + cast(@NumDirector as nvarchar(max))

	select
		FilmName as [Name], FilmReleaseDate as [Date], 'Film' as [Type]
	from
		tblFilm
	where FilmReleaseDate >= @MyDate

union all
	select
		ActorName, ActorDOB, 'Actor'
	from
		tblActor
	where ActorDOB >= @MyDate

union all
	select
		DirectorName, DirectorDOB, 'Director'
	from
		tblDirector
	where DirectorDOB  >= @MyDate
order by [Date] asc

go
use Movies
go


declare @ID int
declare @Name nvarchar(max)
declare @Date Datetime

select top 1
	@ID = ActorID,
	@Name = ActorName,
	@Date = ActorDOB
from
	tblActor
where
	ActorDOB >= '1970-01-01'
order by 
	ActorDOB asc

select @ID, @Name, @Date

select
	f.FilmName,
	c.CastCharacterName
from
	tblFilm as f
	inner join
	tblCast as c on f.FilmID = c.CastActorID
Where
	c.CastActorID = @ID

select *
from tblCast
select *
from tblFilm
go

use Movies
go
declare @NameList nvarchar(max)

set @NameList = ''
select
	@NameList = @NameList + ActorName + char(10) + char(13)
-- 줄바꿈
from
	tblActor
where
	year(ActorDOB) = 1970

select @NameList

print @NameList
go

--* Global Variable, 내장 변수
select @@SERVERNAME
select @@VERSION

select *
from tblActor
select @@ROWCOUNT -- 행수

go

Output param
use Movies
go
alter proc spFilmsInYear
	(
	@Year int,
	@FilmList nvarchar(max) output,
	@FilmCount int output
)
as
begin

	declare @Films nvarchar(max)
	set @Films = ''

	select
		@Films = @Films + filmName + ', '
	from
		tblFilm
	where
		YEAR(FilmReleaseDate) = @Year
	Order by
		FilmName asc

	set @FilmCount = @@ROWCOUNT
	set @FilmList = @Films
end

GO

alter proc spFilmsInYearReturn
	(
	@Year int
)
as
begin

	select
		filmName
	from
		tblFilm
	where
		YEAR(FilmReleaseDate) = @Year
	Order by
		FilmName asc

	return @@rowcount

end
go

alter proc spVariableData
	(
	@InfoType nvarchar(9)
-- This can be ALL, AWARD or FINANCIAL
)
AS
begin
	if @InfoType ='ALL'
		begin
		(select *
		from tblFilm)
		return
	end

	if @InfoType='AWARD'
		begin
		(select FilmName, FilmOscarWins, FilmOscarNominations
		from tblFilm)
		return
	end

	if @InfoType='FINANCIAL'
	begin
		(select FilmName, FilmBoxOfficeDollars, FilmBudgetDollars
		from tblFilm)
		return
	end

	select 'You must chosse ALL, AQARD or FINANCIAL'
end
--

-- While Loop
declare @Counter int
declare @MaxOscars int
declare @NumFilms int
declare @Temp int

set @Temp = (select count(*)
from tblFilm
where FilmOscarWins = 0)
set @MaxOscars = (select max(FilmOscarWins)
from tblFilm)
set @Counter = 0
	print cast(@MaxOscars as nvarchar(4)) + '--------------'
	print 'FilmOscarWins = 0 count => ' + cast(@Temp as nvarchar(4))

while @Counter <=@MaxOscars
	begin
	set @NumFilms = (select count(*)
	from tblFilm
	where FilmOscarWins = @Counter)
	if	@NumFilms = 0 break

	print cast(@NumFilms as nvarchar(3)) + ' films have won ' + 
				cast(@Counter as nvarchar(2)) + ' Oscars'
	set @Counter = @Counter + 1
end

--* 커서 Cursor --------------------------------------------------------------------------
go
declare @FilmID int
declare @FilmName nvarchar(max)

declare FilmCursor cursor for
	select FilmID, FilmName
from tblFilm

open FilmCursor
fetch next from FilmCursor into @FilmID, @FilmName

while @@FETCH_STATUS = 0
	begin
	print 'Characters in the film ' + @FilmName
	select CastCharactername
	from tblCast
	where CastFilmID = @FilmID
	fetch next from FilmCursor into @FilmID, @FilmName
end
close FilmCursor
deallocate FilmCursor

-- Scalar Function -- 단일 값에 의 단일 결과 값을 반환하는 함수
select
	FilmName,
	FilmReleaseDate,
	DATENAME(dw, FilmReleaseDate) + ' ' +
	DATENAME(d, FilmReleaseDate) + ' ' +
	DATENAME(m, FilmReleaseDate) + ' ' +
	DATENAME(yy, FilmReleaseDate)
from
	tblFilm

-- Create Funtion -- 스칼라 반환 함수
use Movies
go

alter function fnLongDate
	(
		@FullDate as DateTime
	)
returns nvarchar(max)
as
begin
	return DATENAME(dw, @FullDate) + ' ' +
	DATENAME(d, @FullDate) + ' ' +
	case
		when day(@FullDate) In(1, 21, 31) then 'st'
		when day(@FullDate) in(2, 22) then 'nd'
		when day(@FullDate) in(3, 23) then 'rd'
		else 'th'
	end + ' ' +

	DATENAME(m, @FullDate) + ' ' +
	DATENAME(yy, @FullDate)
end

go

use Movies
go

-- 테이블 반환 함수 (begin ~ end  없음)
alter function FilmInYear
(
	@StartYear int,
	@EndYear int
)

returns table
as
return
	select
	FilmName
		, FilmReleaseDate
		, FilmRunTimeMinutes
from
	tblFilm
where
		year(FilmReleaseDate) between @StartYear and @EndYear
go
--* return multi table (10)
use Movies
go

alter function PeopleInYear
(
	@BirthYear int
)
returns @t Table
(
	PersonName nvarchar(max),
	PersonDOB datetime,
	PersonJob nvarchar(8)
)
as
begin
	insert into @t
	select
		DirectorName,
		DirectorDOB,
		'Director'
	from
		tblDirector
	where
		YEAR(DirectorDOB) = @BirthYear

	insert into @t
	select
		ActorName,
		ActorDOB,
		'Actor'
	from
		tblActor
	where
		YEAR(ActorDOB) = @BirthYear

	return
end
go

-- (20)
alter proc spListCharacters
	(
	@FilmID int,
	@FilmName nvarchar(max),
	@FilmDate datetime
)
as
begin

	print @FilmName + ' was released on ' + convert(char(10), @FilmDate, 103)
	print '========================================================'
	print 'List of Characters'
	select
		CastCharacterName
	from
		tblCast
	where CastFilmID = @FilmID
end
go

--(21) Dynamic SQL 
alter proc spVariableTable
	(
	@TableName nvarchar(128),
	@Number int
)
as
begin

	declare @SQLString nvarchar(max)
	declare @NumberString nvarchar(4)

	set @NumberString = cast(@Number as nvarchar(4))
	set @SQLString = N'select top ' + @NumberString + ' * from ' + @TableName

	exec sp_executesql @SQLString

end

-- (22) Dynamic SQL
go
alter proc spFilmYears
	(
	@YearList nvarchar(max)
)
as
begin
	declare @SQLString nvarchar(max)
	set @SQLString = 
		N'select *
		from tblFilm
		where YEAR(FilmReleaseDate) in (' + @YearList + N')
		order by FilmReleaseDate'

	exec sp_executesql @SQLString
end
go

-- (24) 
alter proc spGetDirector(@DirectorName nvarchar(max))
as
begin
	declare @ID int

	save tran AddDirector

	insert into tblDirector
		(DirectorName)
	Values
		(@DirectorName)

	if (select COUNT(*)
	from tblDirector
	where DirectorName = @DirectorName) > 1
		begin
		print 'Direcotr already existed'
		rollback tran AddDirector

	end
	select @ID = DirectorID
	from tblDirector
	where DirectorName = @DirectorName
	return @ID
end

