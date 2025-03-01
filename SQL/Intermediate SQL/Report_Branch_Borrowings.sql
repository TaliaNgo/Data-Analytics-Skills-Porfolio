-- January 2025 Branch-Wise Daily Borrowing Report
-- Get book borrowings in January
WITH Borrowings AS 
(SELECT DISTINCT b.BookIssueID, b.BranchID, b.DateBorrowed, b.BookID
 FROM Borrowedby b
 WHERE b.DateBorrowed BETWEEN '2025-01-01' AND '2025-01-31'
 AND b.BranchID IN (1, 2, 3)
),

-- Count total borrowings for each day per branch
BorrowingCounts AS
(SELECT bo.BranchID,
        b.BranchSuburb,
        FORMAT(bo.DateBorrowed, 'dd/MM/yyyy') AS 'BorrowedDate',
        bo.BookIssueID,
        bk.BookTitle,
        ROW_NUMBER() OVER (PARTITION BY bo.BranchID, bo.DateBorrowed ORDER BY bo.BookIssueID) AS 'DayCount', -- partiion by day
        ROW_NUMBER() OVER (PARTITION BY bo.BranchID ORDER BY bo.DateBorrowed) AS 'BranchCount', -- partition by branch
        COUNT(bo.BookIssueID) OVER (PARTITION BY bo.BranchID, bo.DateBorrowed) AS 'DailyBorrowingCount', -- count books by day
        COUNT(bo.BookIssueID) OVER (PARTITION BY bo.BranchID) AS 'BranchBorrowingCount' -- count books by branch
 FROM Borrowings bo
 LEFT JOIN Book bk ON bo.BookID = bk.BookID
 LEFT JOIN Branch b ON bo.BranchID = b.BranchID)

-- Format column names for final report
SELECT CASE WHEN BranchCount = 1 THEN BranchID ELSE '' END AS 'Branch ID',
       BranchSuburb AS 'Branch Location',
       BorrowedDate AS 'Borrowed Date',
       BookTitle AS 'Book Title',
       CASE WHEN DayCount = 1 THEN DailyBorrowingCount ELSE NULL END AS 'Daily Borrowing Count',
       CASE WHEN BranchCount = 1 THEN BranchBorrowingCount ELSE NULL END AS 'Branch Borrowing Count'
FROM BorrowingCounts;