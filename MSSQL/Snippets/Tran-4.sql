use Movies
go

-- Nested Transactions and stored procedures
Declare @DirectorID int

Begin Tran AddIM

	Insert Into tblFilm (FilmName, FilmReleaseDate)
	Values ('Iron Man 3', '2013-04-25')

	Exec @DirectorID = spGetDirector 'Shane Black'

	update tblFilm
	Set FilmDirectorID = @DirectorID
	Where FilmName = 'Iron Man 3'

Commit Tran AddIM
