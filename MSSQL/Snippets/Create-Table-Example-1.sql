
if object_id('dbo.Cutomers','U') is not null
drop table dbo.Customers;
go

create table dbo.Customers
(
	CustomerId int not null primary key,
	Name nvarchar(50),
	Location nvarchar(50) not null,
	Email nvarchar(50) not null
);
go

-- Enc Line --
