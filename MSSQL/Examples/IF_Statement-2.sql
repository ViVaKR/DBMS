use Movies
go

alter proc spVariableData
    (
        @InfoType nvarchar(9) -- This can be All, Award or Financial
    )
as
begin
    if @InfoType = 'All'
        begin
            (select * from Film )
            return 
        end
    else if @InfoType = 'Award'
        begin
            (select Title, OscarWins, OscarNominations from Film)
            return
        end
    else if @InfoType = 'Financial'
        begin
            (select Title, BoxOfficeDollars, BudgetDollars from Film)
            return
        end
    
    select 'You must choose All, Award or Financial'
end

-- End Line --
