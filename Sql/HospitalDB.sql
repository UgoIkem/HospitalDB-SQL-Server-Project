---

-- QUESTION 1
DATABASE CREATION AND NORMALISED TABLE DESIGN (3NF)
---------------------------------------------------

CREATE DATABASE HospitalDB;
GO

USE HospitalDB;
GO

---

-- 1.1 DEPARTMENT TABLE

CREATE TABLE Department (
DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
DepartmentName VARCHAR(100) UNIQUE NOT NULL
CHECK (LEN(TRIM(DepartmentName)) > 0)
);

---

-- 1.2 PATIENT TABLE

CREATE TABLE Patient (
PatientID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL
CHECK (LEN(TRIM(FirstName)) > 0),
LastName VARCHAR(50) NOT NULL
CHECK (LEN(TRIM(LastName)) > 0),
Address VARCHAR(150) NOT NULL
CHECK (LEN(TRIM(Address)) > 0),
DateOfBirth DATE NOT NULL
CHECK (DateOfBirth <= CAST(GETDATE() AS DATE)),
Insurance VARCHAR(50) NOT NULL
CHECK (LEN(TRIM(Insurance)) > 0),
Username VARCHAR(50) NOT NULL UNIQUE
CHECK (LEN(TRIM(Username)) > 0),
PasswordHash VARCHAR(255) NOT NULL
CHECK (LEN(TRIM(PasswordHash)) > 0),
Email VARCHAR(100),
PhoneNumber VARCHAR(20),
RegistrationDate DATE NOT NULL
CHECK (RegistrationDate <= CAST(GETDATE() AS DATE)),
DateLeftHospital DATE,
CHECK (DateLeftHospital >= RegistrationDate)
);

---

-- 1.3 DOCTOR TABLE

CREATE TABLE Doctor (
DoctorID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL
CHECK (LEN(TRIM(FirstName)) > 0),
LastName VARCHAR(50) NOT NULL
CHECK (LEN(TRIM(LastName)) > 0),
Specialty VARCHAR(50) NOT NULL
CHECK (LEN(TRIM(Specialty)) > 0),
DepartmentID INT NOT NULL,
FOREIGN KEY (DepartmentID)
REFERENCES Department(DepartmentID)
);

---

-- 1.4 APPOINTMENT TABLE

CREATE TABLE Appointment (
AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
AppointmentDate DATE NOT NULL
CHECK (AppointmentDate >= CAST(GETDATE() AS DATE)),
AppointmentTime TIME NOT NULL,
Status VARCHAR(20) NOT NULL
CHECK (Status IN ('Pending', 'Cancelled', 'Completed', 'Available')),
Feedback VARCHAR(500),
ArrivalTime TIME,
CompletedTime TIME,
CHECK (CompletedTime > ArrivalTime),
PatientID INT NOT NULL,
FOREIGN KEY (PatientID)
REFERENCES Patient(PatientID),
DoctorID INT NOT NULL,
FOREIGN KEY (DoctorID)
REFERENCES Doctor(DoctorID),
UNIQUE (DoctorID, AppointmentDate, AppointmentTime),
UNIQUE (PatientID, AppointmentDate, AppointmentTime)
);

---

-- 1.5 MEDICAL RECORD TABLE

CREATE TABLE MedicalRecord (
MedicalRecordID INT IDENTITY(1,1) PRIMARY KEY,
RecordDate DATE NOT NULL,
AppointmentID INT NOT NULL UNIQUE,
FOREIGN KEY (AppointmentID)
REFERENCES Appointment(AppointmentID)
);

---

-- 1.6 DIAGNOSIS TABLE

CREATE TABLE Diagnosis (
DiagnosisID INT IDENTITY(1,1) PRIMARY KEY,
DiagnosisName VARCHAR(80) NOT NULL
CHECK (LEN(TRIM(DiagnosisName)) > 0),
MedicalRecordID INT NOT NULL,
FOREIGN KEY (MedicalRecordID)
REFERENCES MedicalRecord(MedicalRecordID)
);

---

-- 1.7 PATIENT ALLERGY TABLE

CREATE TABLE PatientAllergy (
PatientID INT NOT NULL,
AllergyName VARCHAR(80) NOT NULL
CHECK (LEN(TRIM(AllergyName)) > 0),
PRIMARY KEY (PatientID, AllergyName),
FOREIGN KEY (PatientID)
REFERENCES Patient(PatientID)
);

---

-- 1.8 PRESCRIPTION TABLE

CREATE TABLE Prescription (
PrescriptionID INT IDENTITY(1,1) PRIMARY KEY,
MedicineName VARCHAR(100) NOT NULL
CHECK (LEN(TRIM(MedicineName)) > 0),
Dosage VARCHAR(50),
Duration VARCHAR(50),
PrescribedDate DATE NOT NULL,
MedicalRecordID INT NOT NULL,
FOREIGN KEY (MedicalRecordID)
REFERENCES MedicalRecord(MedicalRecordID)
);

---

-- QUESTION 2


-----------------------------------------------------
-- INSERTING DATA 
-----------------------------------------------------
INSERT INTO Department (DepartmentName)
VALUES
('Cardiology'),
('Neurology'),
('Orthopedics'),
('Pediatrics'),
('Dermatology'),
('Oncology'),
('General Surgery');

INSERT INTO Doctor
(
FirstName,
LastName,
Specialty,
DepartmentID
)
VALUES
('John','Smith','Cardiologist',1),
('Sarah','Johnson','Neurologist',2),
('Michael','Brown','Orthopedic Surgeon',3),
('Emma','Davis','Pediatrician',4),
('David','Wilson','Dermatologist',5),
('Sophia','Taylor','Oncologist',6),
('James','Anderson','General Surgeon',7);

INSERT INTO Patient
(
FirstName,
LastName,
Address,
DateOfBirth,
Insurance,
Username,
PasswordHash,
Email,
PhoneNumber,
RegistrationDate
)
VALUES
('Alice','Walker','12 Main Street','1990-05-15','AXA','alice90','HASH001','alice@email.com','1234567890','2025-01-01'),

('Robert','King','15 Oak Road','1985-08-22','Allianz','rob85','HASH002','robert@email.com','1234567891','2025-01-05'),

('Linda','Scott','20 Pine Lane','1995-03-10','AXA','linda95','HASH003','linda@email.com','1234567892','2025-01-10'),

('Mark','Evans','7 River Ave','1988-07-18','Bupa','mark88','HASH004','mark@email.com','1234567893','2025-01-12'),

('Nancy','Young','40 Green St','1992-12-01','Allianz','nancy92','HASH005','nancy@email.com','1234567894','2025-01-15'),

('Peter','Hall','55 King Rd','1980-06-06','Bupa','peter80','HASH006','peter@email.com','1234567895','2025-01-20'),

('Olivia','White','3 Queen Ave','2000-09-09','AXA','olivia00','HASH007','olivia@email.com','1234567896','2025-01-25');



INSERT INTO Appointment
(
AppointmentDate,
AppointmentTime,
Status,
PatientID,
DoctorID
)
VALUES
('2026-07-01','09:00','Pending',1,1),
('2026-07-01','10:00','Pending',2,1),
('2026-07-02','11:00','Pending',3,2),
('2026-07-02','12:00','Pending',4,3),
('2026-07-03','09:30','Pending',5,4),
('2026-07-03','10:30','Pending',6,5),
('2026-07-04','14:00','Pending',7,6);

INSERT INTO MedicalRecord
(
RecordDate,
AppointmentID
)
VALUES
('2026-07-01',1),
('2026-07-01',2),
('2026-07-02',3),
('2026-07-02',4),
('2026-07-03',5),
('2026-07-03',6),
('2026-07-04',7);

INSERT INTO Diagnosis
(
DiagnosisName,
MedicalRecordID
)
VALUES
('Diabetes',1),
('Hypertension',1),
('Migraine',2),
('Fracture',3),
('Asthma',4),
('Skin Rash',5),
('Cancer Screening',6),
('High Cholesterol',7);

INSERT INTO PatientAllergy
(
PatientID,
AllergyName
)
VALUES
(1,'Peanuts'),
(1,'Dust'),
(2,'Penicillin'),
(3,'Shellfish'),
(4,'Pollen'),
(5,'Latex'),
(6,'Eggs'),
(7,'Seafood');

INSERT INTO Prescription
(
MedicineName,
Dosage,
Duration,
PrescribedDate,
MedicalRecordID
)
VALUES
('Metformin','500mg','30 Days','2026-07-01',1),
('Lisinopril','10mg','30 Days','2026-07-01',1),
('Ibuprofen','400mg','5 Days','2026-07-01',2),
('Calcium Tablets','1 Tablet','14 Days','2026-07-02',3),
('Ventolin Inhaler','2 Puffs','30 Days','2026-07-02',4),
('Hydrocortisone Cream','Apply Twice Daily','14 Days','2026-07-03',5),
('Vitamin D','1000 IU','30 Days','2026-07-04',6),
('Atorvastatin','20mg','30 Days','2026-07-04',7);



------------------------------

-- QUESTION 3

-- PATIENTS OLDER THAN 40 WITH CANCER DIAGNOSIS
------------------------------

CREATE FUNCTION dbo.CalculateAge
(
@DateOfBirth DATE
)
RETURNS INT
AS
BEGIN
DECLARE @Age INT;

SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE());

RETURN @Age;

END;
GO


SELECT DISTINCT
    p.PatientID,
    p.FirstName,
    p.LastName,
    dbo.CalculateAge(p.DateOfBirth) AS Age,
    d.DiagnosisName
FROM Patient p

JOIN Appointment a
    ON p.PatientID = a.PatientID

JOIN MedicalRecord m
    ON a.AppointmentID = m.AppointmentID

JOIN Diagnosis d
    ON m.MedicalRecordID = d.MedicalRecordID

WHERE dbo.CalculateAge(p.DateOfBirth) > 40
AND d.DiagnosisName = 'Cancer Screening';


-- ANOTHER METHOD 
WITH AgeCalculation AS
(
    SELECT
        PatientID,
        FirstName,
        LastName,
        DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
    FROM Patient
)

SELECT DISTINCT
    ac.PatientID,
    ac.FirstName,
    ac.LastName,
    ac.Age,
    d.DiagnosisName
FROM AgeCalculation ac

JOIN Appointment a
    ON ac.PatientID = a.PatientID

JOIN MedicalRecord m
    ON a.AppointmentID = m.AppointmentID

JOIN Diagnosis d
    ON m.MedicalRecordID = d.MedicalRecordID

WHERE ac.Age > 40
AND d.DiagnosisName = 'Cancer Screening';


------------------------------
-- QUESTION 4A
-- SEARCH MEDICINE BY NAME
-- STORED PROCEDURE
------------------------------

CREATE PROCEDURE SearchMedicineByName
@SearchTerm VARCHAR(50)
AS
BEGIN

SELECT
    MedicineName,
    Dosage,
    Duration,
    PrescribedDate
FROM Prescription
WHERE MedicineName LIKE '%' + @SearchTerm + '%'
ORDER BY PrescribedDate DESC;


END;
GO

EXEC SearchMedicineByName 'met';

--------------------
-- QUESTION 4B
-- RETURN DIAGNOSIS AND ALLERGIES FOR A SPECIFIC PATIENT WITH AN APPOINTMENT TODAY
--------------------

CREATE PROCEDURE GetPatientDiagnosisAndAllergies
@PatientID INT
AS
BEGIN


SELECT
    a.PatientID,
    d.DiagnosisName
FROM Appointment a
JOIN MedicalRecord m
    ON m.AppointmentID = a.AppointmentID
JOIN Diagnosis d
    ON m.MedicalRecordID = d.MedicalRecordID
WHERE a.AppointmentDate = CAST(GETDATE() AS DATE)
  AND a.PatientID = @PatientID;

SELECT
    p.PatientID,
    p.AllergyName
FROM Appointment a
JOIN PatientAllergy p
    ON a.PatientID = p.PatientID
WHERE a.AppointmentDate = CAST(GETDATE() AS DATE)
  AND p.PatientID = @PatientID;

END;
GO


EXEC GetPatientDiagnosisAndAllergies 5

------------------------------
-- QUESTION 4C
-- UPDATE EXISTING DOCTOR DETAILS
------------------------------

CREATE PROCEDURE UpdateDoctorDetails
@NewDoctorFirstName VARCHAR(100),
@NewDoctorLastName VARCHAR(100),
@NewDoctorSpecialty VARCHAR(50),
@NewDoctorDepartmentID INT,
@DoctorID INT
AS
BEGIN

UPDATE Doctor
SET FirstName = @NewDoctorFirstName,
    LastName = @NewDoctorLastName,
    Specialty = @NewDoctorSpecialty,
    DepartmentID = @NewDoctorDepartmentID
WHERE DoctorID = @DoctorID;


END;
GO

EXEC UpdateDoctorDetails 'Isaac', 'Nana', 'Cardiologist', 1, 7;

------------------------------
-- QUESTION 4D
-- DELETE COMPLETED APPOINTMENTS
-----------------------------

CREATE PROCEDURE DeleteCompleteStatus
@CompletedStatus VARCHAR(50)
AS
BEGIN


DELETE FROM Appointment
WHERE Status = @CompletedStatus;


END;
GO

------------------------------
-- QUESTION 5
-- APPOINTMENT DETAILS VIEW
------------------------------

CREATE VIEW AppointmentDetails AS

SELECT
d.DoctorID,
d.FirstName,
d.LastName,
d.Specialty,
de.DepartmentName,
a.AppointmentDate,
a.AppointmentTime,
a.Feedback
FROM Appointment a
JOIN Doctor d
ON a.DoctorID = d.DoctorID
JOIN Department de
ON d.DepartmentID = de.DepartmentID;
GO

------------------------------
-- QUESTION 6
-- TRIGGER
-- CHANGE STATUS TO AVAILABLE WHEN APPOINTMENT IS CANCELLED
-----------------------------

CREATE TRIGGER ChangeStatusWhenCancelled
ON Appointment
AFTER UPDATE
AS
BEGIN

UPDATE Appointment
SET Status = 'Available'
WHERE AppointmentID IN
(
    SELECT AppointmentID
    FROM inserted
    WHERE Status = 'Cancelled'
);


END;
GO

------------------------------
-- QUESTION 7
-- COMPLETED APPOINTMENTS FOR GASTROENTEROLOGISTS
------------------------------

SELECT
d.Specialty,
COUNT(*) AS NumberOfCompletedAppointments
FROM Doctor d
JOIN Appointment a
ON d.DoctorID = a.DoctorID
WHERE a.Status = 'Completed'
AND d.Specialty = 'Gastroenterologists'
GROUP BY d.Specialty;



