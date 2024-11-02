use Movies
go

Alter 
-- Create
trigger trgActorInserted
on Actor
instead of insert
as 
begin
	raiserror ('No more actores can be inserted', 16, 1)
end
go

set nocount on
insert into Actor (FirstName, FamilyName) values('GilSan', 'Jang')
go
select * from Actor order by ActorID desc

-- End Line --
