## 📖 Intermediate SQL Queries for Library Database  

This project showcases my ability to **work with more complex queries and functions of SQL**. I have built a library database, implemented stored procedures and triggers, and executed complex queries using some intermediate SQL techniques.

### 📌 Key SQL Skills Demonstrated  
✅ **Database Design & Management** – Creating and modifying tables   
✅ **Stored Procedures & Triggers** – Automating database actions   
✅ **Advanced Querying** – Using `Window Functions` - `PARTITION BY`, `ROW_NUMBER()`   
✅ **Aggregations & Analytics** – Summarising and refining data   
✅ **Common Table Expressions (CTEs)** – Organising complex queries   

---

### 📂 [1. Library Database](./DB.sql)
This SQL script creates a small database for a library, with the structure as followed:   
![Library DB Diagram](https://github.com/user-attachments/assets/8899822e-8773-4702-bfc1-7d43d8b3025f)

---

### ⚙️ [2. Stored Procedure & Trigger](./Procedure_Trigger.sql)
This script includes automated database logic to maintain data integrity and enforce business rules:   
- **Stored Procedure**:   
  This procedure handles membership termination based on overdue books and suspensions. It changes the member's status to "TERMINATED" when that member has at least an overdue item or has their membership suspended in the last 3 years.   
- **Trigger**:   
  This trigger automatically updates a member's status from "SUSPENDED" to "REGULAR" when the member has no outstanding fees or no overdue items. It is triggered when there is an update on the Borrowedby table.   

---

### 📊 [3. Report](./Report_Branch_Borrowings.sql)
The SQL query in this script generates a report on the total number of book borrowings for January 2025, categorised by branch and daily borrowing activity. Key concepts include:  
- **Window Functions**: `PARTITION_BY()`, `ROW_NUMBER() OVER`, `COUNT() OVER`
- **CASE Statement**
- **CTEs**

A sample of the report header is below:   
Branch ID | Branch Location | Borrowed Date | Book Title | Daily Borrowing Count | Branch Borrowing Count
--- | --- | --- | --- | --- | ---   
1 | Parramatta | 06/01/2025 | Crime and Punishment | 2 | 3
||| 06/01/2025 | Dopamine Nation ||
||| 08/01/2025 | The Alchemist | 1 |
2 | North Ryde | 10/01/2025 | The Psychology of Money | 3 | 6
