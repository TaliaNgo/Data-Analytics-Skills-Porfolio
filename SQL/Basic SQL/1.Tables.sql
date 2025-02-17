-- CREATE DATABASE TABLES

-- create location table
CREATE TABLE location
(LocationCode CHAR(3),
LocationName VARCHAR(50),
PRIMARY KEY (LocationCode));

-- create route table
CREATE TABLE route
(RouteID CHAR(3),
RouteDesc VARCHAR(1000),
SourceLocationCode CHAR(3),
DesLocationCode CHAR(3),
PRIMARY KEY (RouteID),
FOREIGN KEY (SourceLocationCode) REFERENCES location (LocationCode),
FOREIGN KEY (DesLocationCode) REFERENCES location (LocationCode));

-- create cruise table
CREATE TABLE cruise
(CruiseID CHAR(3),
CruiseName VARCHAR(50),
NumOfDays INTEGER,
RouteID CHAR(3),
PRIMARY KEY (CruiseID),
FOREIGN KEY (RouteID) REFERENCES route (RouteID));

-- create schedule table
CREATE TABLE schedule 
(ScheduleID CHAR(4),
StartDate DATE,
MaxCapacity INTEGER,
CruiseID CHAR(3),
PRIMARY KEY (ScheduleID),
FOREIGN KEY (CruiseID) REFERENCES cruise (CruiseID));

-- create staff table
CREATE TABLE staff
(StaffID CHAR(3),
StaffName VARCHAR(50),
ManagerID CHAR(3), 
Position VARCHAR(20), 
StaffPay DECIMAL(5,2), 
PRIMARY KEY (StaffID),
FOREIGN KEY (ManagerID) REFERENCES staff (StaffID));

-- create qualifications table
CREATE TABLE qualifications
(StaffID CHAR(3),
SkillName VARCHAR(50),
PRIMARY KEY (StaffID, SkillName),
FOREIGN KEY (StaffID) REFERENCES staff (StaffID));

-- create roster table
CREATE TABLE roster
(ScheduleID CHAR(4),
StaffID CHAR(3),
StartDateTime DATETIME,
EndDateTime DATETIME,
PRIMARY KEY (ScheduleID, StaffID),
FOREIGN KEY (ScheduleID) REFERENCES schedule (ScheduleID),
FOREIGN KEY (StaffID) REFERENCES staff (StaffID));

-- create tour table
CREATE TABLE tour
(CruiseID CHAR(3),
TourCode CHAR(3),
TourName VARCHAR(50),
TourCost DECIMAL(7,2),
TourType VARCHAR(20),
PRIMARY KEY (TourCode, CruiseID),
FOREIGN KEY (CruiseID) REFERENCES cruise (CruiseID));

-- create model table
CREATE TABLE model
(ModelID CHAR(3),
ModelName VARCHAR(50),
ModelCapacity INTEGER,
PRIMARY KEY (ModelID));

-- create vessel table
CREATE TABLE vessel
(VesselID CHAR(3),
VesselName VARCHAR(50),
VPurchaseYear year,
ModelID CHAR(3),
PRIMARY KEY (VesselID),
FOREIGN KEY (ModelID) REFERENCES model (ModelID));

-- create booking table
CREATE TABLE booking 
(VesselID CHAR(3),
CruiseID CHAR(3),
FromDate date,
ToDate date,
PRIMARY KEY (VesselID, CruiseID),
FOREIGN KEY (VesselID) REFERENCES vessel (VesselID),
FOREIGN KEY (CruiseID) REFERENCES cruise (CruiseID));

-- create route table
CREATE TABLE route
(RouteID CHAR(3),
RouteDesc VARCHAR(1000),
SourceLocationCode CHAR(3),
DesLocationCode CHAR(3),
PRIMARY KEY (RouteID),
FOREIGN KEY (SourceLocationCode) REFERENCES location(LocationCode),
FOREIGN KEY (DesLocationCode) REFERENCES location(LocationCode));

-- create servicedock table
CREATE TABLE servicedock
(ServiceDockID CHAR(4),
ServiceDockName VARCHAR(50),
PRIMARY KEY (ServiceDockID));

-- create service table
CREATE TABLE service
(VesselID CHAR(3),
ServiceDockID CHAR(4),
ServiceDate date,
PRIMARY KEY (VesselID, ServiceDockID),
FOREIGN KEY (VesselID) REFERENCES vessel(VesselID),
FOREIGN KEY (ServiceDockID) REFERENCES servicedock(ServiceDockID));

-- create location table
CREATE TABLE location
(LocationCode CHAR(3),
LocationName VARCHAR(50),
PRIMARY KEY (LocationCode));

-- INSERT VALUES INTO DATABASE TABLES

-- location table
INSERT INTO location VALUES ('L01', 'Sydney');
INSERT INTO location VALUES ('L02', 'Singapore');
INSERT INTO location VALUES ('L03', 'Taipei');
INSERT INTO location VALUES ('L04', 'Osaka');
INSERT INTO location VALUES ('L05', 'Melbourne');

-- route table
INSERT INTO route VALUES ('R01', 'Sydney-Taipei', 'L01', 'L03');
INSERT INTO route VALUES ('R02', 'Singapore-Taipei', 'L02', 'L03');
INSERT INTO route VALUES ('R03', 'Osaka-Melbourne', 'L04', 'L05');
INSERT INTO route VALUES ('R04', 'Melbourne-Singapore', 'L05', 'L02');
INSERT INTO route VALUES ('R05', 'Taipei-Singapore', 'L03', 'L02');

-- cruise table
INSERT INTO cruise VALUES ('C01', 'RoyalCruise', '7', 'R01');
INSERT INTO cruise VALUES ('C02', 'PrincessCruise', '5', 'R02');
INSERT INTO cruise VALUES ('C03', 'CarnivalCruise', '10', 'R03');
INSERT INTO cruise VALUES ('C04', 'CelebrityCruise', '15', 'R04');
INSERT INTO cruise VALUES ('C05', 'NorwegianCruise', '12', 'R05');

-- schedule table
INSERT INTO schedule VALUES ('SC01', '2019-05-28', '130', 'C01');
INSERT INTO schedule VALUES ('SC02', '2019-12-11', '130', 'C02');
INSERT INTO schedule VALUES ('SC03', '2022-01-07', '220', 'C03');
INSERT INTO schedule VALUES ('SC04', '2022-09-15', '350', 'C04');
INSERT INTO schedule VALUES ('SC05', '2019-10-03', '220', 'C05');

-- staff table
INSERT INTO staff VALUES ('S05', 'Imelda Rivera', null, 'F&B Manager', '72.00'); 
INSERT INTO staff VALUES ('S06', 'Kit Connor', null, 'General Manager', '75.00');
INSERT INTO staff VALUES ('S01', 'Edvin Ryding', 'S05', 'Bartender', '50.00'); 
INSERT INTO staff VALUES ('S02', 'Ben Hope', 'S06', 'Room Attendant', '41.20'); 
INSERT INTO staff VALUES ('S03', 'Ingrid Yun', 'S06', 'Receptionist', '50.30');

-- qualifications table
INSERT INTO qualifications VALUES ('S01', 'Making drinks');
INSERT INTO qualifications VALUES ('S02', 'Swimming');
INSERT INTO qualifications VALUES ('S02', 'Tour guide');
INSERT INTO qualifications VALUES ('S04', 'Cooking');
INSERT INTO qualifications VALUES ('S05', 'Diving');

-- roster table
INSERT INTO roster VALUES ('SC01', 'S03', '2022-01-07 11:30:00', '2022-01-10 17:00:00');
INSERT INTO roster VALUES ('SC02', 'S02', '2022-11-01 10:00:00', '2022-11-05 15:00:00');
INSERT INTO roster VALUES ('SC03', 'S01', '2022-01-08 21:30:00', '2022-01-12 02:30:00');
INSERT INTO roster VALUES ('SC04', 'S05', '2022-09-15 08:00:00', '2022-09-16 20:00:00');
INSERT INTO roster VALUES ('SC05', 'S04', '2022-09-16 07:30:00', '2022-09-20 18:30:00');

-- tour table
INSERT INTO tour VALUES ('C01', 'T01', 'Royal', '300.00', 'Family');
INSERT INTO tour VALUES ('C03', 'T01', 'Carnival', '219.99', 'Family');
INSERT INTO tour VALUES ('C02', 'T02', 'Princess', '550.50', 'Adventure');
INSERT INTO tour VALUES ('C07', 'T02', 'Adventure', '399.99', 'Adventure');
INSERT INTO tour VALUES ('C04', 'T03', 'Celebrity', '170.99', 'Basic');

-- model table
INSERT INTO model VALUES ('M01', 'MODEL-100', '100');
INSERT INTO model VALUES ('M02', 'MODEL-200', '200');
INSERT INTO model VALUES ('M03', 'MODEL-300', '300');
INSERT INTO model VALUES ('M04', 'MODEL-400', '400');
INSERT INTO model VALUES ('M05', 'MODEL-500', '500');

-- vessel table
INSERT INTO vessel VALUES ('V01', 'Leila I', '2017', 'M03');
INSERT INTO vessel VALUES ('V02', 'North Star', '2012', 'M04');
INSERT INTO vessel VALUES ('V03', 'Diamond II', '2019', 'M02');
INSERT INTO vessel VALUES ('V04', 'A Morning Song', '2016', 'M02');
INSERT INTO vessel VALUES ('V05', 'Agnes II', '2020', 'M03');

-- booking table
INSERT INTO booking VALUES ('V03', 'C01','2019-05-20' ,'2019-05-27' );
INSERT INTO booking VALUES ('V04', 'C02', '2019-12-11', '2019-12-16' );
INSERT INTO booking VALUES ('V01', 'C03','2022-01-07' , '2022-01-17');
INSERT INTO booking VALUES ('V02', 'C04', '2022-09-15', '2022-09-30' );
INSERT INTO booking VALUES ('V05', 'C05', '2019-10-03' , '2019-10-15' );

-- route table
INSERT INTO route VALUES ('R01', 'Sydney-Taipei', 'L01', 'L03');
INSERT INTO route VALUES ('R02', 'Singapore-Taipei', 'L02', 'L03');
INSERT INTO route VALUES ('R03', 'Osaka-Melbourne', 'L04', 'L05');
INSERT INTO route VALUES ('R04', 'Melbourne-Singapore', 'L05', 'L02');
INSERT INTO route VALUES ('R05', 'Taipei-Singapore', 'L03', 'L02');

-- servicedock table
INSERT INTO servicedock VALUES ('SD01','Dock Brotherson');
INSERT INTO servicedock VALUES ('SD02','Dock Hayes');
INSERT INTO servicedock VALUES ('SD03','Dock Berk');
INSERT INTO servicedock VALUES ('SD04','Dock Caltex');
INSERT INTO servicedock VALUES ('SD05','Dock Macquarie');

-- service table
INSERT INTO service VALUES ('V01', 'SD01', '2020-03-25');
INSERT INTO service VALUES ('V02', 'SD02', '2022-04-18');
INSERT INTO service VALUES ('V03', 'SD03', '2021-09-30');
INSERT INTO service VALUES ('V04', 'SD04', '2019-07-11');
INSERT INTO service VALUES ('V05', 'SD05', '2020-08-27');
INSERT INTO service VALUES ('V02', 'SD01', '2022-08-23');

-- location table
INSERT INTO location VALUES ('L01', 'Sydney');
INSERT INTO location VALUES ('L02', 'Singapore');
INSERT INTO location VALUES ('L03', 'Taipei');
INSERT INTO location VALUES ('L04', 'Osaka');
INSERT INTO location VALUES ('L05', 'Melbourne');

-- MODIFY VALUES
UPDATE location SET LocationName = Brisbane WHERE LocationCode = 'L05';
DELETE FROM service WHERE VesselID = 'V02';