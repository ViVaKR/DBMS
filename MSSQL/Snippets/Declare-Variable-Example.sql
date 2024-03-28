use Movies
go
set nocount on
declare @MyDate datetime

--변수선언
declare @NumFilms int
declare @NumActors int
declare @NumDirectors int

set @MyDate = '1970-01-01'
set @NumFilms = (select count(*)
from tblFilm
where FilmReleaseDate >= @MyDate)

set @NumActors = (select count(*)
from tblActor
where ActorDOB >= @MyDate)

set @NumDirectors = (select count(*)
from tblDirector
where DirectorDOB >= @MyDate)


print 'Number of films = ' + cast(@NumFilms as nvarchar(max))
print 'Number of actors = ' + cast(@NumActors as nvarchar(max))
print 'Number of directors = ' + cast(@NumDirectors as nvarchar(max))

-- (3) Variables 
-- union = 중복값 제거, union all = 중복값 모두 표시
    select FilmName as Name, FilmReleaseDate as Date, 'Film' as Type
    from tblFilm
    where FilmReleaseDate >= @MyDate

union all

    select ActorName, ActorDOB, 'Actor'
    from tblActor
    where ActorDOB >= @MyDate

union all

    select DirectorName, DirectorDOB, 'Director'
    from tblDirector
    where DirectorDOB >= @MyDate
order by Date asc -- 가장 먼저의 컬럼 명으로 정렬
go

-- End Line --
