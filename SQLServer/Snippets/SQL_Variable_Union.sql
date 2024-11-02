USE MoviesB
GO

set nocount on

declare @MyDate datetime
declare @NumFilms int
declare @NumActors int
declare @NumDirector int

set @MyDate = '1980-01-01'
set @NumFilms = (select COUNT(*) from tblFilm where FilmReleaseDate >= @MyDate)
set @NumActors = (select COUNT(*) from tblActor where ActorDOB >= @MyDate)
set @NumDirector = (select count(*) from tblDirector where DirectorDOB >= @MyDate)


select 'Number of films', @NumFilms
union
select 'Number of actors', @NumActors

print 'Number of films = ' + cast(@NumFilms as nvarchar(max))
print 'Number of Actors = ' + cast(@NumActors as nvarchar(max))
print 'Number of Director = ' + cast(@NumDirector as nvarchar(max))

--* 

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

--*

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

--* 

declare @NameList nvarchar(max)

set @NameList = ''
select
	@NameList = @NameList + ActorName + char(10) + char(13) -- 줄바꿈
from
	tblActor
where
	year(ActorDOB) = 1970

select @NameList

print @NameList
go

-- Global Variable, 내장 변수
select @@SERVERNAME
select @@VERSION

select * from tblActor
select @@ROWCOUNT -- 행수
GO

Create proc spFilmsInYear
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
Create proc spFilmsInYearReturn
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

-- End Line --
