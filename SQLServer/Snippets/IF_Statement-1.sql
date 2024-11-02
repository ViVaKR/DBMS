use Movies
go

declare @NumFilms int
declare @ActionoFilms int
set @NumFilms = (select count(*)
from Film
where GenreID = 3)
set @ActionoFilms = (select count(*)
from Film
Where GenreID = 1)

if @NumFilms > 0
    begin
    print 'Warning!'
    print 'There ar too many romantic films in the database'
    if @ActionoFilms > 20
            begin
        print 'Phew! There are enoungh action films to make p for it!'
    end
        else 
            begin
        print 'There are not enought action films either!'
    end
end
else 
    begin
    print 'Information'
    print 'There are no more than five romantic films'
end

-- End Line --
