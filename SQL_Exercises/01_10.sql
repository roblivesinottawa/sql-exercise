-- Common Table Expressions (CTEs)
USE AdventureWorksDW2014
GO


-- use a CTE to get an aggregate of an aggregate
-- Show number of profitable weeks
WITH Sales_CTE (Yr, WeekNum, WeeklySales)  
AS  
(  
    SELECT YEAR(OrderDate) as Yr, DATEPART(wk,OrderDate) as WeekNum, sum(SalesAmount) as WeeklySales
    FROM FactInternetSales  
    GROUP BY YEAR(OrderDate), DATEPART(wk,OrderDate) 
)  
SELECT *, CASE WHEN WeeklySales > 140000 THEN 1 ELSE 0 END as 'Profitable'
FROM Sales_CTE
ORDER BY 1,2 
GO  

-- Summarize by Year
WITH Sales_CTE (Yr, WeekNum, WeeklySales)  
AS  
(  
    SELECT YEAR(OrderDate) as Yr, DATEPART(wk,OrderDate) as WeekNum, sum(SalesAmount) as WeeklySales
    FROM FactInternetSales  
    GROUP BY YEAR(OrderDate), DATEPART(wk,OrderDate) 
)  
SELECT Yr, SUM(CASE WHEN WeeklySales > 140000 THEN 1 ELSE 0 END) as 'Profitable'
FROM Sales_CTE
GROUP BY Yr
ORDER BY 1 
GO



-------------------------------------------------------------------------
-- Use CTE to navigate employee hierarchy
WITH DirectReports (ManagerID, EmployeeID, Title, DeptID, Level)
AS
(
-- Anchor member definition
    SELECT e.ParentEmployeeKey, e.EmployeeKey, e.Title, e.DepartmentName, 
        0 AS Level
    FROM DimEmployee AS e
    WHERE e.ParentEmployeeKey IS NULL
    UNION ALL
-- Recursive member definition
    SELECT e.ParentEmployeeKey, e.EmployeeKey, e.Title, e.DepartmentName,
        Level + 1
    FROM DimEmployee AS e
    INNER JOIN DirectReports AS d
        ON e.ParentEmployeeKey = d.EmployeeID
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title, DeptID, Level
FROM DirectReports
WHERE DeptID = 'Information Services' OR Level = 0




