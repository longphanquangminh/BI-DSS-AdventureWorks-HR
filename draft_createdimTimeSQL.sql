USE K19406C_Group7_HR
INSERT INTO [K19406C_Group7_HR].[dbo].[Dim_Time] (TimeKey,Date,Year,Month,Day,DateName,DayNumberOfWeek,DayNumberOfMonth,DayNumberOfYear,WeekNumberOfYear,Quarter)
select CAST(YEAR(PK_Date) AS NVARCHAR) + RIGHT('0' + CAST(MONTH(PK_Date) AS NVARCHAR), 2) + RIGHT('0' + CAST(DAY(PK_Date) AS NVARCHAR),2) TimeKey,
	PK_Date [Date],
	YEAR(PK_Date) Year ,
	RIGHT('0' + CAST(MONTH(PK_Date) AS NVARCHAR), 2) Month,
	RIGHT('0' + CAST(DAY(PK_Date) AS NVARCHAR), 2) Day,
	DATENAME(WEEKDAY,PK_Date) DateName,
	DATEPART(WEEKDAY,PK_Date) DayNumberOfWeek,
	DATEPART(DAY,PK_Date) DayNumberOfMonth,
	DATEPART(DAYOFYEAR,PK_Date) DayNumberOfYear,
	DATEPART(WEEK,PK_Date) WeekNumberOfYear,
	DATEPART(QUARTER,PK_Date) Quarter
	--INTO Dim_Time
from dbo.DimTimeTemp