--* 행 번호
Select ROW_NUMBER() OVER (ORDER BY (SELECT 1)) as No, * From [테이블]

--* Real To Time(7)
Declare @time real
Set @time = 0.534722222
Select CONVERT(time(7), CAST(CAST(@time as real) AS datetime))
