-- Tạo DimEmployee
SELECT B.BusinessEntityID, A.FirstName, A.MiddleName, A.LastName, C.PhoneNumber, B.BirthDate, B.Gender,
B.MaritalStatus,D.EmailAddress, F.AddressLine1, F.City, G.Name StateProvince, H.Name CountryRegion, B.OrganizationLevel,
B.JobTitle, B.NationalIDNumber, B.HireDate, B.VacationHours,B.SickLeaveHours
INTO [K19406C_Group7_HR].dbo.DimEmployeeTemp
FROM Person.Person A INNER JOIN HumanResources.Employee B on A.BusinessEntityID = B.BusinessEntityID
 INNER JOIN Person.PersonPhone C on B.BusinessEntityID = C.BusinessEntityID
 INNER JOIN person.EmailAddress D on C.BusinessEntityID =
D.BusinessEntityID
 INNER JOIN Person.BusinessEntityAddress E on E.BusinessEntityID =
D.BusinessEntityID
 INNER JOIN Person.Address F on F.AddressID = E.AddressID
 INNER JOIN Person.StateProvince G ON
G.StateProvinceID=F.StateProvinceID
 INNER JOIN Person.CountryRegion H ON
H.CountryRegionCode=G.CountryRegionCode
GROUP BY B.BusinessEntityID, A.FirstName, A.MiddleName, A.LastName, C.PhoneNumber, B.BirthDate, B.Gender,
B.MaritalStatus,D.EmailAddress, F.AddressLine1, F.City, G.Name, H.Name, B.OrganizationLevel, B.JobTitle,
B.NationalIDNumber, B.HireDate, B.VacationHours,B.SickLeaveHours

--Tạo DimDepartment
SELECT A.DepartmentID, A.Name, A.GroupName
FROM HumanResources.Department A

--Tạo DimShift
SELECT A.ShiftID, A.Name, A.StartTime, A.EndTime
FROM HumanResources.Shift A

--Tạo FactPayHistory
SELECT A.BusinessEntityID, c.DepartmentID, b.ShiftID,
 CAST(YEAR(a.RateChangeDate) AS nvarchar)+ RIGHT('0' +CAST(MONTH(a.RateChangeDate) AS
nvarchar),2) + RIGHT('0' +CAST(DAY(a.RateChangeDate) AS nvarchar),2) AS RateChangeDate,
 a.Rate,a.PayFrequency
from HumanResources.EmployeePayHistory a left join HumanResources.EmployeeDepartmentHistory
b on a.BusinessEntityID = b.BusinessEntityID
left join HumanResources.Department c on b.DepartmentID = c.DepartmentID
INNER JOIN HumanResources.Shift D on D.ShiftID = b.ShiftID
WHERE (a.RateChangeDate = b.StartDate and b.EndDate is null)
or (a.RateChangeDate <= b.StartDate and b.EndDate is not null)
or (a.RateChangeDate >= b.StartDate and b.EndDate is null)
or (a.RateChangeDate = b.EndDate)

--Tạo FactDepartmentHistory
SELECT A.BusinessEntityID, E.DepartmentID, b.ShiftID,
(A.SickLeaveHours +A.VacationHours) TimeOffHours, CAST(YEAR(B.StartDate) AS
nvarchar)+ RIGHT('0' +CAST(MONTH(B.StartDate) AS nvarchar),2) + RIGHT('0'
+CAST(DAY(B.StartDate) AS nvarchar),2) AS StartDate,
 CAST(YEAR(B.EndDate) AS nvarchar)+ RIGHT('0' +CAST(MONTH(B.EndDate) AS
nvarchar),2) + RIGHT('0' +CAST(DAY(B.EndDate) AS nvarchar),2) AS EndDate
FROM HumanResources.Employee A inner join HumanResources.EmployeeDepartmentHistory B on
A.BusinessEntityID = B.BusinessEntityID
INNER JOIN HumanResources.Shift D on D.ShiftID = B.ShiftID
INNER JOIN HumanResources.Department E on E.DepartmentID = b.DepartmentID


-- Department trong Visual Studio
UPDATE [K19406C_Group7_HR].[dbo].[FactDepartmentHistory]
SET [TimeOffHours] =?
WHERE [BusinessEntityKey]=?
AND [DepartmentKey]=?
AND [ShiftKey]=?
AND [StartDate]=?
AND [EndDate]=?

-- FactPayHistory trong Visual Studio
UPDATE [K19406C_Group7_HR].[dbo].[FactPayHistory]
SET [Rate] =?, [PayFrequency]=?
WHERE [BusinessEntityKey]=?
AND [DepartmentKey]=?
AND [ShiftKey]=?
AND [RateChangeDate]=?