# Clinic Management System 

## 1. Entity Relationship Diagram (ERD)



```mermaid
erDiagram
    Patients ||--o{ Appointments : "1-M"
    Doctors ||--o{ Appointments : "1-M"
    Specializations ||--o{ Doctors : "1-M"
    Appointments }o--|| Appointment_Treatments : "1-M"
    Treatments }o--|| Appointment_Treatments : "1-M"

    Patients {
        int patient_id PK
        varchar(100) first_name
        varchar(100) last_name
        varchar(20) national_id
        date date_of_birth
        varchar(15) phone_number
        varchar(255) email
        varchar(100) location
    }

    Doctors {
        int doctor_id PK
        varchar(100) first_name
        varchar(100) last_name
        varchar(255) email
        varchar(15) phone_number
        int specialization_id FK
    }

    Specializations {
        int specialization_id PK
        varchar(100) name
    }

    Treatments {
        int treatment_id PK
        varchar(100) name
        decimal(10,2) cost
    }

    Appointments {
        int appointment_id PK
        int patient_id FK
        int doctor_id FK
        datetime appointment_date
        enum status
        text notes
    }

    Appointment_Treatments {
        int appointment_id PK,FK
        int treatment_id PK,FK
    }
```

## 2. README.md File Content

```markdown
# Kenyan Clinic Management System

## Project Description
A comprehensive database system for managing patient records, doctor appointments, and treatments in a Kenyan clinical setting. The system tracks patient visits, doctor specializations, and treatments administered.

## Features
- Patient registration and management
- Doctor specialization tracking
- Appointment scheduling
- Treatment cost management
- Relationship tracking between appointments and treatments

## Database Schema
![ER Diagram](#) <!-- Insert your generated ERD image here -->

## Setup Instructions

### Prerequisites
- MySQL Server installed
- MySQL Workbench or command line client

### Installation
1. Clone this repository
2. Run the SQL script in your MySQL environment:

```bash
mysql -u username -p < clinicdb.sql
```

### Alternative Method (MySQL Workbench)
1. Open MySQL Workbench
2. Create a new connection if needed
3. File → Open SQL Script → Select `clinicdb.sql`
4. Execute the script (lightning bolt icon)

## Sample Queries

```sql
-- Get all appointments with patient and doctor info
SELECT a.appointment_id, p.first_name AS patient_fname, p.last_name AS patient_lname,
       d.first_name AS doctor_fname, d.last_name AS doctor_lname,
       a.appointment_date, a.status
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- Calculate total treatment costs per appointment
SELECT a.appointment_id, SUM(t.cost) AS total_cost
FROM Appointment_Treatments at
JOIN Treatments t ON at.treatment_id = t.treatment_id
JOIN Appointments a ON at.appointment_id = a.appointment_id
GROUP BY a.appointment_id;
```

## Author
Lewis Gitonga

## License
MIT License
```

## 3. Enhanced SQL Script

Here's your original SQL script with some minor improvements (add this to your clinicdb.sql file):

```sql
-- Clinic Management System Database
-- Author: Lewis Gitonga
-- Description: SQL script to create tables and sample data for a clinic in Kenya
-- Date: 2025-05-08

-- Create Database with explicit character set for Kenyan data
CREATE DATABASE clinicdb 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE clinicdb;

-- Create table: Patients with additional constraints
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kenyan National ID',
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL COMMENT 'Format: 07XXXXXXXX',
    email VARCHAR(255) CHECK (email LIKE '%@%.%'),
    location VARCHAR(100) NOT NULL COMMENT 'Town/City in Kenya',
    INDEX (last_name, first_name)
) COMMENT 'Patient demographic information';

-- Create table: Specializations
CREATE TABLE Specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL COMMENT 'Medical specialization area'
) COMMENT 'Doctor specialization categories';

-- Create table: Doctors with improved constraints
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email LIKE '%@%.%'),
    phone_number VARCHAR(15) COMMENT 'Format: 07XXXXXXXX',
    specialization_id INT,
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id),
    INDEX (last_name, first_name)
) COMMENT 'Doctor information and specializations';

-- Create table: Treatments with cost validation
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Medical procedure name',
    cost DECIMAL(10,2) NOT NULL CHECK (cost > 0),
    INDEX (name)
) COMMENT 'Medical treatments and their costs';

-- Create table: Appointments with temporal constraints
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id),
    INDEX (appointment_date),
    CONSTRAINT chk_appointment_date CHECK (appointment_date > NOW())
) COMMENT 'Patient appointment scheduling';

-- M-M relationship table: Appointment_Treatments
CREATE TABLE Appointment_Treatments (
    appointment_id INT NOT NULL,
    treatment_id INT NOT NULL,
    PRIMARY KEY (appointment_id, treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id)
) COMMENT 'Treatments administered during appointments';

-- Sample Data Insertions (Kenyan context)

-- Specializations common in Kenya
INSERT INTO Specializations (name) VALUES 
('General Medicine'),
('Pediatrics'),
('Dermatology'),
('Gynecology'),
('Dentistry'),
('Optometry');

-- Kenyan doctors
INSERT INTO Doctors (first_name, last_name, email, phone_number, specialization_id) VALUES
('Mwangi', 'Kamau', 'mwangi.k@clinic.co.ke', '0712345678', 1),
('Achieng', 'Otieno', 'achieng.o@clinic.co.ke', '0723456789', 2),
('Mutiso', 'Njeri', 'njeri.m@clinic.co.ke', '0734567890', 3),
('Abdullah', 'Mohamed', 'abdullah.m@clinic.co.ke', '0745678901', 4),
('Wanjiku', 'Mugo', 'wanjiku.m@clinic.co.ke', '0756789012', 1);

-- Kenyan patients
INSERT INTO Patients (first_name, last_name, national_id, date_of_birth, phone_number, email, location) VALUES
('John', 'Kiptoo', '12345678', '1990-04-10', '0700111222', 'john.kiptoo@mail.com', 'Eldoret'),
('Grace', 'Nyambura', '87654321', '1985-08-15', '0711223344', 'grace.nyambura@mail.com', 'Nairobi'),
('Ali', 'Mohammed', '11223344', '1992-12-01', '0700123456', 'ali.mohammed@mail.com', 'Mombasa'),
('Wambui', 'Ochieng', '55667788', '1978-05-22', '0722334455', NULL, 'Kisumu'),
('James', 'Mutua', '33445566', '2005-11-30', '0733445566', 'james.mutua@mail.com', 'Nakuru');

-- Common treatments in Kenyan clinics
INSERT INTO Treatments (name, cost) VALUES
('Malaria Test', 500.00),
('Blood Sugar Test', 300.00),
('Skin Consultation', 1500.00),
('Antenatal Checkup', 1200.00),
('Dental Checkup', 800.00),
('Eye Test', 600.00),
('HIV Test', 400.00),
('Typhoid Test', 450.00);

-- Appointments with realistic Kenyan scenarios
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, notes) VALUES
(1, 1, '2025-06-10 10:00:00', 'Scheduled', 'Patient complained of fever and headache - possible malaria'),
(2, 2, '2025-06-12 14:00:00', 'Scheduled', 'Routine checkup for 5-year-old child'),
(3, 3, '2025-06-15 09:00:00', 'Scheduled', 'Skin rash consultation - possible allergic reaction'),
(4, 4, '2025-06-18 11:00:00', 'Scheduled', 'Pregnancy checkup - 6 months along'),
(5, 5, '2025-06-20 08:30:00', 'Scheduled', 'General checkup and vaccination inquiry');

-- Appointment_Treatments (realistic combinations)
INSERT INTO Appointment_Treatments (appointment_id, treatment_id) VALUES
(1, 1),  -- Malaria test for fever
(1, 2),  -- Blood sugar test as well
(2, 4),  -- Antenatal for child checkup
(3, 3),  -- Skin consultation
(4, 4),  -- Antenatal checkup
(5, 5),  -- Dental checkup
(5, 6);  -- Eye test
```

