use Movie
go
alter function fnLongDate  
	(
		@FullDate as datetime
	)
returns nvarchar(max)
as
begin
	return 	
	DATENAME(DW,@FullDate) + ' ' +
	DATENAME(D, @FullDate) + 
	case
		when day(@FullDate) in (1, 21, 31)  then 'st'
		when day(@FullDate) in (2, 22)  then 'nd'
		when day(@FullDate) in (3, 23)  then 'rd'
		else 'th'
	end + ' ' +
	DATENAME(M, @FullDate) + ' ' +
	DATENAME(YY, @FullDate)
end
