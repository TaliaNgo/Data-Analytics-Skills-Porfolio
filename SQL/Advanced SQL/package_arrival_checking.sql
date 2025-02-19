-- get unique order no
WITH UniquePackages AS 
(SELECT DISTINCT PackageId, Destination, ArrivalDate
FROM PackageTracking
WHERE ArrivalDate BETWEEN '2025-01-01' AND '2025-01-31'
AND Destination IN ('WarehouseA', 'WarehouseB', 'WarehouseC')),
-- count total based on unique order no
PackageCounts AS
(SELECT u.Destination
        ,FORMAT(u.ArrivalDate, 'dd/MM/yyyy') AS 'ArrivalDate'
	      ,u.PackageId
	      ,p.Detail
	      ,ROW_NUMBER() OVER (PARTITION BY u.Destination ORDER BY u.ArrivalDate) AS 'Count' --partition by each NewLocation name
	      ,COUNT(u.PackageId) OVER (PARTITION BY u.Destination) AS 'PackageCount' --count by each NewLocation name
FROM UniquePackages u
LEFT JOIN Package p ON u.PackageId = p.PackageId)
-- format column names -> final results
SELECT CASE WHEN [Count] = 1 THEN Destination ELSE '' END AS 'Destination'
  , [ArrivalDate]
  , [PackageId]
  , [Detail] AS 'PackageDetail'
  , CASE WHEN [Count] = 1 THEN [PackageCount] ELSE NULL END AS 'PackageCount' --count by each NewLocation name
FROM PackageCounts