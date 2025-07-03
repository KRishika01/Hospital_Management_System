CREATE DATABASE Dna_project;
USE Dna_project;

CREATE TABLE DEPARTMENT (
DeptID INT PRIMARY KEY,
HOD INT, 
Dpt_Name VARCHAR(255),			
UNIQUE (HOD)
);

CREATE TABLE DOCTOR (
DoctorID INT PRIMARY KEY,
Doc_Fname VARCHAR(255),
Doc_Mname VARCHAR(255),
Doc_Lname VARCHAR(255),
DOB DATE,
Gender VARCHAR(10),
Contact_No BIGINT,
DeptID INT,
Supervisor_ID INT,
FOREIGN KEY (DeptID)                      
        REFERENCES DEPARTMENT(DeptID),               
FOREIGN KEY (Supervisor_ID)                      
        REFERENCES DOCTOR(DoctorID),                
CHECK (LENGTH(Contact_No) = 10 AND Contact_No REGEXP '^[0-9]{10}$')
);

CREATE TABLE DOCTOR_AVAIL_TIME (
DoctorID INT,
Available_time TIME,
FOREIGN KEY (DoctorID)
	REFERENCES DOCTOR(DoctorID),
PRIMARY KEY (DoctorID, Available_time)
);

CREATE TABLE NURSE (
Nurse_ID INT PRIMARY KEY,
NFname VARCHAR(255),
NMname VARCHAR(255),
NLname VARCHAR(255),
Dept_ID INT,
Gender VARCHAR(10),
FOREIGN KEY (Dept_ID)
	REFERENCES DEPARTMENT(DeptID)
);

CREATE TABLE PATIENT (
PatientID INT PRIMARY KEY,
PFname VARCHAR(255),
PMname VARCHAR(255),
PLname VARCHAR(255),
Patient_DOB DATE,
Age INT,
Contact_No BIGINT,
Lane VARCHAR(255),
City VARCHAR(255),
State VARCHAR(255),
Country VARCHAR(255),
Weight INT,
Emergency_contact BIGINT NOT NULL,
Nurse_Id INT,
FOREIGN KEY (Nurse_Id)
	REFERENCES NURSE (Nurse_ID),
CHECK (LENGTH(Contact_No) = 10 AND Contact_No REGEXP '^[0-9]{10}$'),
CHECK (LENGTH(Emergency_contact) = 10 AND Emergency_contact REGEXP '^[0-9]{10}$')
);

CREATE TABLE STAFF (
StaffName VARCHAR(255),
Staff_ID INT PRIMARY KEY,
Role VARCHAR(255)
);

CREATE TABLE PATIENT_PROBLEM (
Patient_ID INT,
Problem VARCHAR(255) NOT NULL,
FOREIGN KEY (Patient_ID)
	REFERENCES PATIENT(PatientID),
PRIMARY KEY (Patient_ID, Problem)
);

CREATE TABLE APPOINTMENT (
Appointment_Id INT PRIMARY KEY,
Doctor_Id INT NOT NULL,
Appointment_Time TIME,
Date DATE NOT NULL,
Patient_Id INT,
FOREIGN KEY (Doctor_Id)
	REFERENCES DOCTOR (DoctorID),
FOREIGN KEY (Patient_Id)
	REFERENCES PATIENT (PatientID)
);

CREATE TABLE PHARMACY (
Medicine_Name VARCHAR(255),
Medicine_Id INT PRIMARY KEY,
Quantity_Available INT,
Price_per_unit DECIMAL(20,3),
Expiry_Date DATE
);

CREATE TABLE LAB (
Lab_ID INT PRIMARY KEY,
LabName VARCHAR(255),
Staff_ID INT,
FOREIGN KEY (Staff_ID)
	REFERENCES STAFF (Staff_ID)
);

CREATE TABLE LAB_EQUIPMENTS (
Lab_ID INT,
Lab_equipments VARCHAR(255),
FOREIGN KEY (Lab_ID)
	REFERENCES LAB (Lab_ID),
PRIMARY KEY (Lab_ID, Lab_equipments)
);

CREATE TABLE ROOM (
Room_No INT PRIMARY KEY,
Checkin TIME,
CheckOut TIME
);

CREATE TABLE ROOM_PATIENTS (
Room_No INT,
PatientID INT,
FOREIGN KEY (Room_No)
	REFERENCES ROOM (Room_No),
PRIMARY KEY (Room_No, PatientID)
);

CREATE TABLE ROOM_STAFF (
Room_No INT,
StaffID INT,
FOREIGN KEY (Room_No)
	REFERENCES ROOM (Room_No),
FOREIGN KEY (StaffID)
	REFERENCES STAFF (Staff_ID),
PRIMARY KEY(StaffID, Room_No)
);

CREATE TABLE PRESCRIPTION (
PrescriptionID INT PRIMARY KEY,
DocID INT,
PatientID INT,
FOREIGN KEY (DocID)
	REFERENCES DOCTOR (DoctorID),
FOREIGN KEY (PatientID)
	REFERENCES PATIENT (PatientID)
);

CREATE TABLE PRESCRIBED_MEDICINES (
Prescription_ID INT,
Medicines_prescribed VARCHAR(255),
FOREIGN KEY (Prescription_ID)
	REFERENCES PRESCRIPTION (PrescriptionID)
);

CREATE TABLE PRESCRIBED_TESTS (
Prescription_ID INT,
Tests_prescribed VARCHAR(255),
FOREIGN KEY (Prescription_ID)
	REFERENCES PRESCRIPTION (PrescriptionID),
PRIMARY KEY ( Prescription_ID, Tests_prescribed)
);

CREATE TABLE TREATMENT (
Patient_ID INT,
Current_condition VARCHAR(255),
Review_date DATE,
FOREIGN KEY (Patient_ID)
	REFERENCES PATIENT (PatientID)
);

CREATE TABLE TREATMENT_DET (
Patient_ID INT,
Treatment_details VARCHAR(255),
FOREIGN KEY (Patient_ID)
	REFERENCES PATIENT (PatientID),
PRIMARY KEY (Patient_ID, Treatment_details)
);

CREATE TABLE INSURANCE (
Patient_id INT,
Insurance_id INT PRIMARY KEY,
Insurance_name VARCHAR(255),
Description VARCHAR(255),
Amount_given DECIMAL(20,3),
FOREIGN KEY (Patient_id)
	REFERENCES PATIENT (PatientID)
);

CREATE TABLE INVOICE (
Patient_Id INT,
Invoice_Id INT PRIMARY KEY,
Date DATE,
Service_name VARCHAR(255),
Quantity INT,
Unit_cost DECIMAL(20,3),
Total_amount DECIMAL(20,3),
FOREIGN KEY (Patient_Id)
	REFERENCES PATIENT (PatientID)
);

CREATE TABLE CONSULTS (
Patient_Id INT,
Doctor_Id INT,
FOREIGN KEY (Patient_Id)
	REFERENCES PATIENT (PatientID),
FOREIGN KEY (Doctor_Id)
	REFERENCES DOCTOR (DoctorID)
);

CREATE TABLE PRESCRIBES (
Prescription_Id INT,
Patient_Id INT,
Doctor_Id INT,
FOREIGN KEY (Patient_Id)
	REFERENCES PATIENT (PatientID),
FOREIGN KEY (Prescription_Id)
	REFERENCES PRESCRIPTION (PrescriptionID),
FOREIGN KEY (Doctor_Id)
	REFERENCES DOCTOR (DoctorID)
);

CREATE TABLE SURGERY (
Surgery_Id INT PRIMARY KEY,
Doctor_Id INT,
Patient_Id INT,
Room_No INT,
Nurse_Id INT,
FOREIGN KEY (Doctor_Id)
	REFERENCES DOCTOR (DoctorID),
FOREIGN KEY (Patient_Id)
	REFERENCES PATIENT (PatientID),
FOREIGN KEY (Room_No)
	REFERENCES ROOM (Room_No),
FOREIGN KEY (Nurse_Id)
	REFERENCES NURSE (Nurse_ID)
);

CREATE TABLE MANAGES (
Staff_Id INT,
Room_No INT,
FOREIGN KEY (Room_No)
	REFERENCES ROOM (Room_No),
FOREIGN KEY (Staff_Id)
	REFERENCES STAFF (Staff_ID)
);

INSERT INTO DEPARTMENT (DeptID, HOD, Dpt_Name) VALUES 
(1, 101, 'Cardiology'),
(2, 102, 'Neurology'),
(3, 103, 'Pediatrics'),
(4, 104, 'Oncology'),
(5, 105, 'Dermatology');

INSERT INTO DOCTOR (DoctorID, Doc_Fname, Doc_Mname, Doc_Lname, DOB, Gender, Contact_No, DeptID, Supervisor_ID) VALUES 
(101, 'John', 'A.', 'Doe', '1975-05-10', 'Male', 9876543210, 1, NULL),
(102, 'Jane', 'B.', 'Smith', '1980-08-15', 'Female', 8765432109, 2, 101),
(103, 'Alice', 'C.', 'Brown', '1985-03-25', 'Female', 7654321098, 3, 102),
(104, 'Mark', 'D.', 'Taylor', '1990-12-10', 'Male', 6543210987, 4, 103),
(105, 'Eve', 'E.', 'Wilson', '1988-06-18', 'Female', 5432109876, 5, 104);

INSERT INTO DOCTOR_AVAIL_TIME (DoctorID, Available_time) VALUES 
(101, '09:00:00'),
(102, '10:30:00'),
(103, '11:00:00'),
(104, '12:00:00'),
(105, '14:30:00');

INSERT INTO NURSE (Nurse_ID, NFname, NMname, NLname, Dept_ID, Gender) VALUES 
(201, 'Emily', 'F.', 'Clark', 1, 'Female'),
(202, 'Daniel', 'G.', 'White', 2, 'Male'),
(203, 'Sophia', 'H.', 'Johnson', 3, 'Female'),
(204, 'Michael', 'I.', 'Lee', 4, 'Male'),
(205, 'Olivia', 'J.', 'Martinez', 5, 'Female');

INSERT INTO PATIENT (PatientID, PFname, PMname, PLname, Patient_DOB, Age, Contact_No, Lane, City, State, Country, Weight, Emergency_contact, Nurse_Id) VALUES 
(301, 'Charlie', 'K.', 'Davis', '2000-07-25', 24, 9988776655, 'Lane 1', 'City A', 'State X', 'Country Y', 70, 8899776655, 201),
(302, 'Sophia', 'L.', 'Garcia', '1995-04-12', 29, 8877665544, 'Lane 2', 'City B', 'State Y', 'Country Z', 65, 7788665544, 202),
(303, 'Liam', 'M.', 'Anderson', '1992-10-10', 32, 7766554433, 'Lane 3', 'City C', 'State Z', 'Country X', 80, 6677554433, 203),
(304, 'Mia', 'N.', 'Taylor', '2005-01-01', 19, 6655443322, 'Lane 4', 'City D', 'State W', 'Country V', 50, 5566443322, 204),
(305, 'Noah', 'O.', 'Walker', '1990-03-03', 34, 5544332211, 'Lane 5', 'City E', 'State U', 'Country T', 75, 4455332211, 205);

INSERT INTO STAFF (StaffName, Staff_ID, Role) VALUES 
('Anna Green', 401, 'Receptionist'),
('Ben Hill', 402, 'Lab Technician'),
('Claire Ross', 403, 'Janitor'),
('David Young', 404, 'Manager'),
('Emma King', 405, 'Security');

INSERT INTO PATIENT_PROBLEM (Patient_ID, Problem) VALUES 
(301, 'Chest Pain'),
(302, 'Migraine'),
(303, 'Fever'),
(304, 'Allergy'),
(305, 'Injury');

INSERT INTO APPOINTMENT (Appointment_Id, Doctor_Id, Appointment_Time, Date, Patient_Id) VALUES 
(501, 101, '10:00:00', '2024-12-01', 301),
(502, 102, '11:00:00', '2024-12-02', 302),
(503, 103, '12:00:00', '2024-12-03', 303),
(504, 104, '13:00:00', '2024-12-04', 304),
(505, 105, '14:00:00', '2024-12-05', 305);

INSERT INTO PHARMACY (Medicine_Name, Medicine_Id, Quantity_Available, Price_per_unit, Expiry_Date) VALUES 
('Paracetamol', 601, 100, 1.50, '2025-06-30'),
('Ibuprofen', 602, 200, 2.00, '2025-12-31'),
('Amoxicillin', 603, 150, 3.75, '2026-03-15'),
('Cetirizine', 604, 300, 0.75, '2025-09-20'),
('Metformin', 605, 120, 5.00, '2026-01-10');

INSERT INTO LAB (Lab_ID, LabName, Staff_ID) VALUES 
(701, 'Pathology', 402),
(702, 'Radiology', 403),
(703, 'Microbiology', 404),
(704, 'Biochemistry', 405),
(705, 'Hematology', 401);

INSERT INTO LAB_EQUIPMENTS (Lab_ID, Lab_equipments) VALUES 
(701, 'Microscope'),
(701, 'Slides'),
(702, 'X-ray Machine'),
(702, 'CT Scanner'),
(703, 'Centrifuge'),
(704, 'Spectrophotometer'),
(705, 'Blood Analyzer');

INSERT INTO ROOM (Room_No, Checkin, CheckOut) VALUES 
(801, '09:00:00', '17:00:00'),
(802, '10:00:00', '18:00:00'),
(803, '11:00:00', '19:00:00'),
(804, '12:00:00', '20:00:00'),
(805, '13:00:00', '21:00:00');

INSERT INTO ROOM_PATIENTS (Room_No, PatientID) VALUES 
(801, 301),
(802, 302),
(803, 303),
(804, 304),
(805, 305);

INSERT INTO ROOM_STAFF (Room_No, StaffID) VALUES 
(801, 401),
(802, 402),
(803, 403),
(804, 404),
(805, 405);

INSERT INTO PRESCRIPTION (PrescriptionID, DocID, PatientID) VALUES 
(901, 101, 301),
(902, 102, 302),
(903, 103, 303),
(904, 104, 304),
(905, 105, 305);

INSERT INTO PRESCRIBED_MEDICINES (Prescription_ID, Medicines_prescribed) VALUES 
(901, 'Paracetamol'),
(902, 'Ibuprofen'),
(903, 'Amoxicillin'),
(904, 'Cetirizine'),
(905, 'Metformin');

INSERT INTO PRESCRIBED_TESTS (Prescription_ID, Tests_prescribed) VALUES 
(901, 'Blood Test'),
(902, 'X-ray'),
(903, 'MRI'),
(904, 'Allergy Test'),
(905, 'Diabetes Screening');

INSERT INTO TREATMENT (Patient_ID, Current_condition, Review_date) VALUES 
(301, 'Stable', '2024-12-10'),
(302, 'Under Observation', '2024-12-11'),
(303, 'Recovering', '2024-12-12'),
(304, 'Critical', '2024-12-13'),
(305, 'Stable', '2024-12-14');

INSERT INTO TREATMENT_DET (Patient_ID, Treatment_details) VALUES 
(301, 'Antibiotics administered'),
(302, 'Pain management'),
(303, 'Fluids and rest'),
(304, 'Allergy shots'),
(305, 'Insulin therapy');

INSERT INTO INSURANCE (Patient_id, Insurance_id, Insurance_name, Description, Amount_given) VALUES 
(301, 1001, 'HealthSafe', 'Basic coverage', 2000.00),
(302, 1002, 'MediCare', 'Comprehensive plan', 5000.00),
(303, 1003, 'LifeGuard', 'Critical illness cover', 3000.00),
(304, 1004, 'SecureHealth', 'Standard coverage', 1500.00),
(305, 1005, 'PrimeHealth', 'Premium plan', 7000.00);

INSERT INTO INVOICE (Patient_Id, Invoice_Id, Date, Service_name, Quantity, Unit_cost, Total_amount) VALUES 
(301, 1101, '2024-12-01', 'Consultation', 1, 500.00, 500.00),
(302, 1102, '2024-12-02', 'X-ray', 1, 1000.00, 1000.00),
(303, 1103, '2024-12-03', 'MRI', 1, 3000.00, 3000.00),
(304, 1104, '2024-12-04', 'Allergy Test', 1, 700.00, 700.00),
(305, 1105, '2024-12-05', 'Diabetes Screening', 1, 800.00, 800.00);

INSERT INTO CONSULTS (Patient_Id, Doctor_Id) VALUES 
(301, 101),
(302, 102),
(303, 103),
(304, 104),
(305, 105);

INSERT INTO PRESCRIBES (Prescription_Id, Patient_Id, Doctor_Id) VALUES 
(901, 301, 101),
(902, 302, 102),
(903, 303, 103),
(904, 304, 104),
(905, 305, 105);

INSERT INTO SURGERY (Surgery_Id, Doctor_Id, Patient_Id, Room_No, Nurse_Id) VALUES 
(1201, 101, 301, 801, 201),
(1202, 102, 302, 802, 202),
(1203, 103, 303, 803, 203),
(1204, 104, 304, 804, 204),
(1205, 105, 305, 805, 205);

INSERT INTO MANAGES (Staff_Id, Room_No) VALUES 
(401, 801),
(402, 802),
(403, 803),
(404, 804),
(405, 805);




