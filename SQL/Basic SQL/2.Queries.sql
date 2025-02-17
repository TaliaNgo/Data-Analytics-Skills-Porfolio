/*
1. Print the name of vessels if:
- They're booked for 10 days or above
- They're purchased between the years 2015 and 2020
*/
SELECT DISTINCT VesselName
FROM vessel v
JOIN booking b
USING (VesselID)
WHERE ToDate-FromDate >='10'
AND VPurchaseYear BETWEEN '2015' AND '2020'
ORDER BY VesselName;

/*
2. Print Model Name and its Capacity if model is from a vessel that's purchased within the last 5 years
*/
SELECT ModelName, ModelCapacity
FROM model
WHERE ModelID in (SELECT ModelID
				  FROM vessel
                  WHERE YEAR(CURRENT_DATE()) - VPurchaseYear <= 5);

/*
3. Print Staff and their Manager's Names and Positions, with their last rostered date within the last 5 years
*/
SELECT s.StaffName 'Staff Name', s.Position 'Staff Position', 
m.StaffName 'Manager Name', m.Position 'Manager Position', 
MAX(YEAR(StartDateTime)) as 'Last Rostered Date'
FROM Roster r 
JOIN Staff s ON s.StaffID = r.StaffID
LEFT JOIN Staff m ON s.ManagerID = m.StaffID
AND (YEAR(CUR_DATE()) - YEAR(StartDateTime)) = 5
GROUP BY s.StaffName, s.Position, m.StaffName, m.Position;

/*
4. Print details of all cruises that has never been scheduled
*/
SELECT c.*
FROM cruise c
LEFT JOIN schedule s ON c.CruiseID = s.CruiseID
WHERE s.ScheduleID IS NULL;

/*
5. Print Staff Name and the number of qualifications they have, only include staff with more than 1 qualification
*/
SELECT StaffName, COUNT(SkillName) 'Number of Skills'
FROM staff s
JOIN qualifications q ON s.StaffID = q.StaffID
GROUP BY StaffName
HAVING COUNT(SkillName) > '1';

/*
6. Print:
- Staff and their maximum continual working days
- Original and Updated Tour Cost for Business tour type
*/
SELECT s1.StaffName 'Staff Name', MAX(DATEDIFF(r.EndDateTime,r.StartDateTime)) 'Max Working Days', 
t.TourCost 'Tour Cost', ROUND(t.TourCost*1.027, 2) 'Updated Tour Cost'
FROM staff s1
JOIN roster r ON s1.StaffID = r.StaffID 
JOIN schedule s2 ON r.ScheduleID = s2.ScheduleID
JOIN cruise c ON s2.CruiseID = c.CruiseID 
JOIN tour t ON c.CruiseID = t.CruiseID
WHERE t.TourType = 'Business'
GROUP BY s1.StaffName, s2.ScheduleID, c.CruiseID, t.TourCost;

/*
7. Print all the tours:
- That costs more than $2,500, and scheduled in Jan or between 2020 and 2022
- Order by the highest cost first
*/
SELECT DISTINCT t.*
FROM tour t 
INNER JOIN schedule s ON t.CruiseID = s.CruiseID
WHERE TourCost > 2500
AND (MONTH(StartDate) = 01
OR YEAR(StartDate) IN (2020,2022))
ORDER BY TourCost DESC;

/*
8. Print Cruise details and their respective total number of days. 
Only include cruises that are longer than 10 days
- JOIN-ON
*/
SELECT c.CruiseID, CruiseName, NumOfDays
FROM cruise c
JOIN tour t ON c.CruiseID = t.CruiseID
WHERE TourType='Basic' AND NumOfDays > 10
GROUP BY c.CruiseID;

/*
9. Print Staff's average earnings in the fourth quarter of 2022
*/
SELECT CEILING(AVG(s.StaffPay))
FROM staff s
JOIN roster r ON s.StaffID = r.StaffID
WHERE QUARTER(r.EndDateTime) = 4 AND YEAR(r.EndDateTime) = '2022';

/*
10. Print Staff who are rostered from afternoon to midday next day, with the manager and cruise they're on
- multiple JOINs
*/
SELECT s2.StaffName, s1.StaffName 'ManagerName', CruiseName
FROM staff s1
LEFT JOIN staff s2 ON s1.StaffID = s2.ManagerID
JOIN roster r ON s2.StaffID = r.StaffID
JOIN schedule s ON r.ScheduleID = s.ScheduleID
JOIN cruise c ON s.CruiseID = c.CruiseID
WHERE (TIME(r.StartDateTime) BETWEEN '12:00:00' AND '15:00:00') 
AND (TIME(r.EndDateTime) BETWEEN '06:00:00' AND '12:00:00');

/*
11. Print the year, staff and their salary. Only include staff that has salary lower than the yearly average.
*/
SELECT YEAR(r.EndDateTime), s.StaffName, s.StaffPay
FROM staff s
JOIN roster r ON r.StaffID = s.StaffID
GROUP BY YEAR(r.EndDateTime), s.StaffName
HAVING s.StaffPay < (SELECT AVG(s.StaffPay)
					FROM staff s);

/*
12. Print all locations along with the details of any routes that start from them. 
*/
SELECT l.LocationCode, l.LocationName, r.RouteID, r.RouteDesc
FROM location l
RIGHT JOIN route r ON l.LocationCode = r.SourceLocationCode;