/*
1. The TRIGGER changes a member's status from "SUSPENDED" to "REGULAR" when:
- the member has no outstanding fees and,
- has no or has returned all overdue items
*/
DROP TRIGGER IF EXISTS resetStatus;

DELIMITER //
CREATE TRIGGER resetStatus
AFTER UPDATE ON Borrowedby
FOR EACH ROW
BEGIN
	DECLARE totalOverdueItem, memID INT;
    DECLARE fee DECIMAL(10,2);
    DECLARE memStatus VARCHAR(50);
    
    -- count overdue items of the updated member:
	-- an item is overdue when there is no return date and the due date is passed
    SELECT COUNT(*) INTO totalOverdueItem
    FROM Borrowedby
    WHERE MemberID = new.MemberID 
    AND DateReturned IS NULL 
    AND CURDATE() > ReturnDueDate;
    
    -- get member ID of the updated member
    SET memID = new.MemberID;
    
	-- get overdue fee of the updated member
	SELECT OverdueFee INTO fee
	FROM Member
	WHERE MemberID = memID;
    
	-- get member status of the updated member
	SELECT MemberStatus INTO memStatus
	FROM Member 
	WHERE MemberID = memID;
    
	-- update member status
	IF memStatus LIKE "SUSPENDED" AND fee = 0 AND totalOverdueItem = 0 THEN
		UPDATE Member
		SET MemberStatus = "REGULAR"
        WHERE MemberID = memID;
	END IF;
END //
DELIMITER ;

/*
This STORED PROCEDURE changes the membership status to "TERMINATED" of members who meet the bellow conditions:
- currently have an overdue item
- have membership suspended twice in the last 3 years
*/
DROP PROCEDURE IF EXISTS endMembership;

DELIMITER //
CREATE PROCEDURE endMembership()
BEGIN
	DECLARE totalOverdueItem, suspensionCount, threeYearsAgo INT DEFAULT 0;
	DECLARE memID INT;
	DECLARE done INT DEFAULT 0;
	DECLARE get_memberID_cursor CURSOR FOR
		SELECT MemberID 
    	FROM Member;
	DECLARE EXIT HANDLER FOR NOT FOUND SET done = 1;

	-- get the year that is 3 years ago from this year
	SET threeYearsAgo = YEAR(CURDATE()) - 3;

	-- cursor
	OPEN get_memberID_cursor;
	WHILE NOT done DO
		FETCH get_memberID_cursor INTO memID;
    
	-- count overdue item
	SELECT COUNT(*) INTO totalOverdueItem
	FROM Borrowedby
	WHERE MemberID = memID 
    AND DateReturned IS NULL
    AND CURDATE() > ReturnDueDate;

	-- count the number of times the member got suspended in the past 3 years
	SELECT COUNT(*) INTO suspensionCount
	FROM CountSuspension
	WHERE MemberID = memID
    AND YEAR(SuspendedDate) <= YEAR(CURDATE()) 
    AND YEAR(SuspendedDate) >= threeYearsAgo;

	-- terminate the membership if conditions satisfied
	IF suspensionCount = 2 AND totalOverdueItem = 1 THEN
		-- print out a list of members
		SELECT MemberName AS 'Members with terminated memberships'
        FROM Member
        WHERE MemberID = memID;
    	-- update status to TERMINATED
		UPDATE Member
		SET MemberStatus = 'TERMINATED'
        WHERE MemberID = memID;
	END IF;
	END WHILE;
	CLOSE get_memberID_cursor;
END //
DELIMITER ;

-- run the procedure
CALL endMembership;