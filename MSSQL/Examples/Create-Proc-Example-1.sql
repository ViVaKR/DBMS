use Movies
go
-- (3) Output Parameter
Alter 
-- Create
Proc spFilmsInYear
(
	@Year int,
	@FilmList nvarchar(max) output, -- 리턴값 파라미터
	@FilmCount int output			-- 리턴값 파라미터
)
as
begin
	declare @Film nvarchar(max)
	set @Film = ''
	Select
		@Film = @Film + FilmName + ', '

	From
		tblFilm
	Where
		year(FilmReleaseDate) = @Year
	Order by
		FilmName asc

	Set @FilmCount = @@rowcount -- 리턴값
	Set @FilmList = @Film
end
go

-- (3-2) Output Parameter : return 방식
Alter
-- Create 
proc spGetFilmCount
(
	@CountryId int
)
as
begin
	declare @Count int
	select
		@Count = count(*)
	from
		tblFilm
	where 
		FilmCountryID = @CountryId
	
	return @Count
end

-- select count(*) from tblFilm Where FilmCountryID = 241
-- select @@rowcount

-- # 가상 에러 중단점
raiserror('Oh no a fatal error', 20, -1) with log
go

-- (2) 파라미터 형
Alter Proc spFilmCriteria 
	(
		@MinLength int = null, -- 기본값 있을 때에는 없어도 되고 있어도 되고
		@MaxLength int = null,
		@Title nvarchar(max)
	)
as
begin
	select
	FilmName,
	FilmReleaseDate,
	FilmRunTimeMinutes
from
	tblFilm
Where 
	(@MinLength is null or FilmRunTimeMinutes >= @MinLength) and
	(@MaxLength is null or FilmRunTimeMinutes <= @MaxLength) and
	FilmName like '%' + @Title + '%'
order by
	FilmName asc
end
go

-- (1) 기본형
alter proc spFilmList
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
End
--
go
use Movies
go
create table Test(
Id int
)
