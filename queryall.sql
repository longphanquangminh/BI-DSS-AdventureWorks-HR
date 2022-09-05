--can't backup now? error
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2014 TO sa;
ALTER AUTHORIZATION ON DATABASE::K19406C_Group7_HR TO sa;
BACKUP DATABASE K19406C_Group7_HR
TO DISK = 'C:\Users\Long\Desktop\BIBAK\K19406C_Group7_HR.bak';


-- làm dim time 1900 hiệu quả: --https://www.codeproject.com/Articles/647950/Create-and-Populate-Date-Dimension-for-Data-Wareho
USE K19406C_Group7_HR
DROP TABLE [dbo].[Dim_Time]

USE K19406C_Group7_HR
select DateKey as TimeKey, Date, Year, Month, DayOfMonth as Day, DayName as DateName, DayOfWeekUSA as DayNumberOfWeek, DayOfMonth as DayNumberOfMonth,
DayOfYear as DayNumberOfYear, WeekOfYear as WeekNumberOfYear, Quarter
from DimDate

select DateKey as TimeKey, Date, YEAR(Date) Year, Month, DayOfMonth as Day, DayName as DateName, cast(DayOfWeekUSA as int) as DayNumberOfWeek, DayOfMonth as DayNumberOfMonth,
DayOfYear as DayNumberOfYear, WeekOfYear as WeekNumberOfYear, Quarter
into [K19406C_Group7_HR].dbo.Dim_Time
from DimDate
select * from Dim_Time --where timekey=20061117
select * from DimDate
select * from DimTimeTemp
select * from DimTimeTemp2

USE AdventureWorks2014
select min(enddate)  from [HumanResources].[EmployeeDepartmentHistory]
select * from [HumanResources].[Department]
select *  from [HumanResources].[Employee]
where HireDate like '2006-06-30'
select MIN(HireDate)  from [HumanResources].[Employee]
where jobtitle like '%Vice President%'
--where BusinessEntityID=294
select 
--count(businessentityid) as 'cbd',
--BusinessEntityID
*
from [HumanResources].[EmployeeDepartmentHistory]
where BusinessEntityID in (4,16,223,234,250)
group by BusinessEntityID
HAVING COUNT(businessentityid)>1;
select * from [HumanResources].[EmployeePayHistory]
select * from [HumanResources].[JobCandidate]
select * from [HumanResources].[Shift]

USE AdventureWorks2014
select *, SalesYTD - SalesLastYear as 'Work better?' from [Sales].[SalesPerson]
select *, SalesYTD - SalesQuota as 'Work better?' from [Sales].[SalesPerson]

USE AdventureWorks2014
select a.*, b.HireDate from [Sales].[SalesPerson] a
join [HumanResources].[Employee] b on a.BusinessEntityID=b.BusinessEntityID
--where BusinessEntityID=274

USE AdventureWorks2014
select * from [Purchasing].[PurchaseOrderHeader]

USE AdventureWorks2014
select * from [Person].[Person]
--where BusinessEntityID=294
--where BusinessEntityID=291
--where BusinessEntityID=296
where BusinessEntityID<291 and BusinessEntityID>0

USE AdventureWorks2014
--USE AdventureWorks2019
select a.BusinessEntityID,
h.PersonType,
--h.NameStyle,h.Title,
h.FirstName,h.MiddleName,h.LastName,
--h.Suffix,h.EmailPromotion, h.AdditionalContactInfo,h.Demographics,
a.NationalIDNumber,a.LoginID,a.OrganizationNode,a.OrganizationLevel,a.JobTitle,FORMAT(a.BirthDate,'dd-MM-yyyy') BirthDate,
a.MaritalStatus,a.Gender,FORMAT(a.HireDate,'dd-MM-yyyy') HireDate,a.SalariedFlag,a.VacationHours,a.SickLeaveHours,a.CurrentFlag,
--a.rowguid, a.ModifiedDate,
b.departmentid, c.name departmentname, c.groupname, b.ShiftID, b.StartDate, b.EndDate,
d.name ShiftName, CONVERT(varchar,d.StartTime,8) as StartTime, CONVERT(varchar,d.EndTime,8) as EndTime,e.ratechangedate,f.rate,f.PayFrequency
--,g.JobCandidateID,g.Resume
--into [Demo_HR_AdventureWorks2014].dbo.HR -- đem data sang DW khác
--into [K19406C_Group7_HR].dbo.DimEmployee2 -- đem data sang DW khác
from [HumanResources].[Employee] a
left join [HumanResources].[EmployeeDepartmentHistory] b  on a.BusinessEntityID=b.BusinessEntityID
join [HumanResources].[Department] c on c.DepartmentID = b.DepartmentID
join [HumanResources].[Shift] d on d.ShiftID = b.ShiftID
--join [HumanResources].[EmployeePayHistory] e on e.BusinessEntityID = b.BusinessEntityID
join [HumanResources].[EmployeePayHistory] f on f.BusinessEntityID=a.BusinessEntityID
join (select BusinessEntityID, max(ratechangedate) as ratechangedate from [HumanResources].[EmployeePayHistory]
group by BusinessEntityID) e on (e.BusinessEntityID = a.BusinessEntityID and e.ratechangedate=f.RateChangeDate)
left join [HumanResources].[JobCandidate] g on g.BusinessEntityID=a.BusinessEntityID
join [Person].[Person] h on h.BusinessEntityID=a.BusinessEntityID
where a.BusinessEntityID=250
--WHERE b.EndDate is null
--where a.BusinessEntityID in (4,16,223,234,250)
--WHERE b.EndDate is not null
--and a.BusinessEntityID in (4,16,224,234,250)
where a.BusinessEntityID in (4,16,224,234,250)
and (a.VacationHours<0 or a.SickLeaveHours<0)
and g.JobCandidateID is not null
--and h.AdditionalContactInfo is not null -- ko có
--and h.suffix='Jr.' -- có 1 người, Sr. ko có ai
--and h.Title='Ms.' -- Mr va Ms đều có, kể cả những người có chức vụ bình thường trở lên như Data Engineer...


--USE AdventureWorksDW2014
--select * from [dbo].[DimEmployee]
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2014 TO sa;

use Sale_DW
select * from [dbo].[Dim_Customer]
select * from [dbo].[Dim_Product]
select * from [dbo].[Dim_Time]

use AdventureWorksDW2014
select * from [dbo].[DimDepartmentGroup]
select * from [dbo].[DimEmployee]

use Demo_HR_AdventureWorks2014
select * from dbo.HR




USE AdventureWorksDW2014
select * from [dbo].[AdventureWorksDWBuildVersion]
select * from [dbo].[DatabaseLog]
select * from [dbo].[DimAccount]
select * from [dbo].[DimCurrency]
select * from [dbo].[DimCustomer]
select * from [dbo].[DimDate]
select * from [dbo].[DimDepartmentGroup]
select * from [dbo].[DimEmployee]
where parentEmployeeKey>290
select * from [dbo].[DimGeography]
select * from [dbo].[DimOrganization]
select * from [dbo].[DimProduct]
select * from [dbo].[DimProductCategory]
select * from [dbo].[DimProductSubcategory]
select * from [dbo].[DimPromotion]
select * from [dbo].[DimReseller]
select * from [dbo].[DimSalesReason]
select * from [dbo].[DimSalesTerritory]
select * from [dbo].[DimScenario]


select * from [dbo].[FactAdditionalInternationalProductDescription]
select * from [dbo].[FactCallCenter]
select * from [dbo].[FactCurrencyRate]
select * from [dbo].[FactFinance]
select * from [dbo].[FactInternetSales]
select * from [dbo].[FactInternetSalesReason]
select * from [dbo].[FactProductInventory]
select * from [dbo].[FactResellerSales]
select * from [dbo].[FactSalesQuota]
select * from [dbo].[FactSurveyResponse]
select * from [dbo].[NewFactCurrencyRate]
select * from [dbo].[ProspectiveBuyer]



ALTER AUTHORIZATION ON DATABASE::AdventureWorksDW2014 TO sa;

USE K19406C_Group7_HR
--USE Nhom7_HR_DW_Demo
select * from DimDepartment
select * from DimEmployee
select * from DimShift
select * from DimTime
select * from FactDepartmentHistory
where BusinessEntityKey=250
select * from FactPayHistory
where DepartmentKey=5
USE K19406C_Group7_HR
--DROP TABLE [dbo].[FactDepartmentHistory]
select JobTitle from [HumanResources].[Employee]
group by JobTitle

select * from [AdventureWorks2014].HumanResources.Employee
where JobTitle like '%Quality Assurance%'

select * from [AdventureWorks2014].[HumanResources].[vEmployeeDepartment]
where jobtitle like '%purchasing manager%'