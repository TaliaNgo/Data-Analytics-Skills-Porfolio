-- Get unique book borrowings
WITH UniqueBorrowings AS 
(SELECT DISTINCT b.BookIssueID, b.BranchID, b.DateReturned, b.BookID
 FROM Borrowedby b
 WHERE b.DateReturned BETWEEN '2025-01-01' AND '2025-01-31'
 AND b.BranchID IN (1, 2, 3)
),

-- Count total borrowings per branch
BorrowingCounts AS
(SELECT u.BranchID,
        FORMAT(u.DateReturned, 'dd/MM/yyyy') AS 'ReturnDate',
        u.BookIssueID,
        bk.BookTitle,
        ROW_NUMBER() OVER (PARTITION BY u.BranchID ORDER BY u.DateReturned) AS 'Count',
        COUNT(u.BookIssueID) OVER (PARTITION BY u.BranchID) AS 'BorrowingCount'
 FROM UniqueBorrowings u
 LEFT JOIN Book bk ON u.BookID = bk.BookID)

-- Format column names for final results
SELECT CASE WHEN Count = 1 THEN BranchID ELSE '' END AS 'BranchID',
       ReturnDate,
       BookIssueID,
       BookTitle AS 'BookTitle',
       CASE WHEN Count = 1 THEN BorrowingCount ELSE NULL END AS 'BorrowingCount'
FROM BorrowingCounts;