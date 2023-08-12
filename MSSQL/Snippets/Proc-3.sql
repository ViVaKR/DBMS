use Movies
go -- begins a new batch

-- (2) proc with parameters
alter proc spFilmCriteria
    (
        @MinLength as int = 0 -- default value
        ,@MaxLength as int = null
        ,@Title as nvarchar(max)
    )
as
begin
    print @Title

    select 
        Title
        ,RunTimeMinutes
    from 
        Film 
    where
        (@MinLength is null or RunTimeMinutes >= @MinLength) and 
        (@MaxLength is null or RunTimeMinutes <= @MaxLength) and
        Title like '%' + @Title + '%'
    order by 
        RunTimeMinutes
end
-- (2) end

-- (1) proc 생성
go
alter proc spFilmList
as
begin
    select 
        Title
        ,ReleaseDate
        ,RunTimeMinutes
     from 
        Film 
    order by Title desc
end

go
-- (1) 실행
exec spFilmList

-- (2) 실행

exec spFilmCriteria @MinLength=120, @MaxLength=180, @Title='die'

exec spFilmCriteria 100, 180, 'Star'

go
-- drop proc
-- drop proc spFilmList

select * from Film where Title like '%star%'

-- End Line --
