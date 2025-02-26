-- Step 1: Extract recent book borrow records into a temporary table
SELECT [BookIssueID],  
       [MemberID],  
       [BookID],  
       [BranchID],  
       [DateBorrowed],  
       [ReturnDueDate],  
       [DateReturned]  
INTO #RecentBorrowedBooks  
FROM Borrowedby  
WHERE [DateBorrowed] BETWEEN '2024-01-01' AND '2024-08-31'  
ORDER BY [DateBorrowed] DESC;  

-- Step 2: Extract book details
SELECT [BookID],  
       [BookTitle],  
       [PublishedYear],  
       [Price]  
INTO #BookDetails  
FROM Book;  

-- Step 3: Join borrowed books with book details to create a summary
SELECT b.*, d.[BookTitle], d.[PublishedYear], d.[Price]  
INTO #BorrowedBookSummary  
FROM #RecentBorrowedBooks b  
LEFT JOIN #BookDetails d  
ON b.[BookID] = d.[BookID]  
ORDER BY b.[DateBorrowed] DESC;  

-- Step 4: Retrieve member details
SELECT [MemberID],  
       [MemberName],  
       [MemberStatus],  
       [OverdueFee]  
INTO #MemberData  
FROM Member;  

-- Step 5: Final report - Join book summary with member details
SELECT s.*, m.[MemberName], m.[MemberStatus], m.[OverdueFee]  
FROM #BorrowedBookSummary s  
LEFT JOIN #MemberData m  
ON s.[MemberID] = m.[MemberID]  
ORDER BY s.[DateBorrowed] DESC;