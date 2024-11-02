-- Dynamic SQL Basics
use Movies
go

Exec (N'Select * From tblFilm') -- Usin Execute
Exec sp_executesql N'Select * From tblFilm' -- Using sp_executesql

go

use Movies
go
Declare @Tablename nvarchar(128)
Set @Tablename = N'tblFilm'
Exec spVariableTable @Tablename, 3

go

-- Concatenating numbers
Declare @Number int
Declare @NumberString nvarchar(4)
Declare @SQLString nvarchar(max)

Set @Number = 10;
Set @NumberString = Cast(@Number as nvarchar(4))
Set @SQLString = N'Select Top ' + @NumberString + ' * From tblFilm Order by FilmReleaseDate'

Exec sp_executesql @SQLString

-- End Line --
