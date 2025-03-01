-- CREATE DATABASE TABLES
DROP TABLE IF EXISTS Borrowedby, Holding, Authoredby, Author, Book, Publisher, Member, Branch;

CREATE TABLE Branch (
  BranchID INT NOT NULL,
  BranchSuburb varchar(255) NOT NULL,
  BranchState char(3) NOT NULL,

  PRIMARY KEY (BranchID)
);

CREATE TABLE Member (
  MemberID INT NOT NULL, 
  MemberStatus char(9) DEFAULT 'REGULAR',
  MemberName varchar(255) NOT NULL,
  MemberAddress varchar(255) NOT NULL,
  MemberSuburb varchar(25) NOT NULL,
  MemberState char(3) NOT NULL,
  MemberExpDate DATE,
  MemberPhone varchar(10),
  OverdueFee decimal(10,2) unsigned default 0,

  PRIMARY KEY (MemberID)
);

CREATE TABLE Publisher (
  PublisherID INT NOT NULL, 
  PublisherName varchar(255) NOT NULL,
  PublisherAddress varchar(255) DEFAULT NULL,

  PRIMARY KEY (PublisherID)
);

CREATE TABLE Book (
  BookID INT NOT NULL,
  BookTitle varchar(255) NOT NULL,
  PublisherID INT NOT NULL,
  PublishedYear INT4,
  Price Numeric(5,2) NOT NULL,

  PRIMARY KEY (BookID),
  KEY PublisherID (PublisherID),
  CONSTRAINT publisher_fk_1 FOREIGN KEY (PublisherID) REFERENCES Publisher (PublisherID) ON DELETE RESTRICT
);

CREATE TABLE Author (
  AuthorID INT NOT NULL, 
  AuthorName varchar(255) NOT NULL,
  AuthorAddress varchar(255) NOT NULL,

  PRIMARY KEY (AuthorID)
);

CREATE TABLE Authoredby (
  BookID INT NOT NULL,
  AuthorID INT NOT NULL,

  PRIMARY KEY (BookID,AuthorID),
  KEY BookID (BookID),
  KEY AuthorID (AuthorID),
  CONSTRAINT book_fk_1 FOREIGN KEY (BookID) REFERENCES Book (BookID) ON DELETE RESTRICT,
  CONSTRAINT author_fk_1 FOREIGN KEY (AuthorID) REFERENCES Author (AuthorID) ON DELETE RESTRICT
);

CREATE TABLE Holding (
  BranchID INT NOT NULL, 
  BookID INT NOT NULL,
  InStock INT DEFAULT 1,
  OnLoan INT DEFAULT 0,

  PRIMARY KEY (BranchID, BookID),
  KEY BookID (BookID),
  KEY BranchID (BranchID),
  CONSTRAINT holding_cc_1 CHECK(InStock>=OnLoan),
  CONSTRAINT book_fk_2 FOREIGN KEY (BookID) REFERENCES Book (BookID) ON DELETE RESTRICT,
  CONSTRAINT branch_fk_1 FOREIGN KEY (BranchID) REFERENCES Branch (BranchID) ON DELETE RESTRICT
);

CREATE TABLE Borrowedby (
  BookIssueID INT UNSIGNED NOT NULL AUTO_INCREMENT,
  BranchID INT NOT NULL,
  BookID INT NOT NULL,
  MemberID INT NOT NULL,
  DateBorrowed DATE,
  DateReturned DATE DEFAULT NULL,
  ReturnDueDate DATE,

  PRIMARY KEY (BookIssueID),
  KEY BookID (BookID),
  KEY BranchID (BranchID),
  KEY MemberID (MemberID),
  CONSTRAINT borrowedby_cc_1 CHECK(DateBorrowed<ReturnDueDate),
  CONSTRAINT holding_fk_1 FOREIGN KEY (BookID,BranchID) REFERENCES holding (BookID,BranchID) ON DELETE RESTRICT,
  CONSTRAINT member_fk_1 FOREIGN KEY (MemberID) REFERENCES Member (MemberID) ON DELETE RESTRICT
);

CREATE TABLE CountSuspension (
  MemberID INT NOT NULL,
  SuspendedDate DATE NOT NULL,
  
  PRIMARY KEY (MemberID, SuspendedDate),
  KEY MemberID (MemberID),
  CONSTRAINT suspension_fk FOREIGN KEY (MemberID) REFERENCES Member (MemberID)
);

-- POPULATE TABLES
DELETE FROM Author;
INSERT INTO Author VALUES ('1', 'Tolstoy','Russian Empire');
INSERT INTO Author VALUES ('2', 'Tolkien','England');
INSERT INTO Author VALUES ('3', 'Asimov','America');
INSERT INTO Author VALUES ('4', 'Silverberg','America');
INSERT INTO Author VALUES ('5', 'Paterson','Australia');

DELETE FROM Branch;
INSERT INTO Branch VALUES ('1','Parramatta','NSW');
INSERT INTO Branch VALUES ('2','North Ryde','NSW');
INSERT INTO Branch VALUES ('3','Sydney City','NSW');

DELETE FROM Publisher;
INSERT INTO Publisher VALUES ('1','Penguin','New York');
INSERT INTO Publisher VALUES ('2','Platypus','Sydney');
INSERT INTO Publisher VALUES ('3','Another Choice','Patagonia');

DELETE FROM Member;
INSERT INTO Member VALUES ('1','REGULAR','Joe','4 Nowhere St','Here','NSW','2021-09-30','0434567811');
INSERT INTO Member VALUES ('2','REGULAR','Pablo','10 Somewhere St','There','ACT','2022-09-30','0412345678');
INSERT INTO Member VALUES ('3','REGULAR','Chen','23/9 Faraway Cl','Far','QLD','2020-11-30','0412346578');
INSERT INTO Member VALUES ('4','REGULAR','Zhang','Dunno St','North','NSW','2020-12-31','');
INSERT INTO Member VALUES ('5','REGULAR','Saleem','44 Magnolia St','South','SA','2020-09-30','1234567811');
INSERT INTO Member VALUES ('6','SUSPENDED','Homer','Middle of Nowhere','North Ryde','NSW','2020-09-30','1234555811');
INSERT INTO Member VALUES ('7', 'REGULAR', 'Talia', '41 Somewhere Rd', 'Suburb 1', 'NSW', '2023-12-31', '041829374', '18');
INSERT INTO Member VALUES ('8', 'SUSPENDED', 'James', '41 Nowhere Rd', 'Suburb 9', 'NSW', '2023-12-31', '040948373', '-20');

DELETE FROM Book;
INSERT INTO Book VALUES ('1','Crime and Punishment','1','2003',40.75);
INSERT INTO Book VALUES ('2','Dopamine Nation','2','2023',20.99);
INSERT INTO Book VALUES ('3','All The Light We Cannot See','2','2019',10.19);
INSERT INTO Book VALUES ('4','The Alchemist','2','1999',29.99);
INSERT INTO Book VALUES ('5','The Psychology of Money','3','2010',35.99);

DELETE FROM Authoredby;
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('1', '1');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('2', '1');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('3', '2');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('4', '3');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('5', '3');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('5', '4');

DELETE FROM Holding;
INSERT INTO Holding VALUES ('1', '1','2','2');
INSERT INTO Holding VALUES ('1', '2','2','1');
INSERT INTO Holding VALUES ('1', '3','3','1');
INSERT INTO Holding VALUES ('2', '1','1','1');
INSERT INTO Holding VALUES ('2', '4','3','2');
INSERT INTO Holding VALUES ('3', '4','4','0');
INSERT INTO Holding VALUES ('3', '5','2','1');

DELETE FROM Borrowedby;
INSERT INTO Borrowedby VALUES ('1', '1','2',CURDATE(),NULL,DATE_ADD(CURDATE(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby VALUES ('2', '4','4',CURDATE(),NULL,DATE_ADD(CURDATE(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby VALUES ('2', '1','4',CURDATE(),NULL,DATE_ADD(CURDATE(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby VALUES ('2', '4','1',CURDATE(),NULL,DATE_ADD(CURDATE(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby VALUES ('3', '5','3',CURDATE(),NULL,DATE_ADD(CURDATE(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby VALUES ('1', '1','1','2020-08-30',NULL,'2020-09-30');
INSERT INTO Borrowedby VALUES ('1', '2','2','2020-08-30',NULL,'2020-09-30');
INSERT INTO Borrowedby VALUES ('3', '4','2','2020-08-30',NULL,'2020-09-30');
INSERT INTO Borrowedby VALUES ('10','2', '4', '8', '2023-09-30', null, '2023-10-21'),
INSERT INTO Borrowedby VALUES ('11','1', '1', '8', '2023-10-01', null, '2023-10-22'),
INSERT INTO Borrowedby VALUES ('12','3', '5', '8', '2023-10-02', null, '2023-10-23');

INSERT INTO CountSuspension VALUES
('1', '2023-10-09'),
('1', '2021-09-30'),
('2', '2022-09-30'),
('7', '2021-07-09'),
('7', '2022-03-10'),
('6', '2019-12-20'),
('6', '2020-09-30'),
('8', '2023-10-23'),
('8', '2020-10-19');