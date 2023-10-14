USE MoviesB
go

select CHAR(ASCII('A') - 1 + ROW_NUMBER() OVER(ORDER BY CountryID ASC)) as [No], CountryName
from tblCountry


