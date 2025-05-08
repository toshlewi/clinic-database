
-- Clinic Management System Database
-- Author: Lewis Gitonga
-- Description: SQL script to create tables and sample data for a clinic in Kenya

-- Create Database
CREATE DATABASE clinicdb;
USE clinicdb;
-- Create table: Patients
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(20) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(255),
    location VARCHAR(100)
);

-- Create table: Specializations
CREATE TABLE Specializations (
    specialization_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Create table: Doctors
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    specialization_id INT,
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id)
);

-- Create table: Treatments
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost DECIMAL(10,2) NOT NULL
);

-- Create table: Appointments
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- M-M relationship table: Appointment_Treatments
CREATE TABLE Appointment_Treatments (
    appointment_id INT NOT NULL,
    treatment_id INT NOT NULL,
    PRIMARY KEY (appointment_id, treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (treatment_id) REFERENCES Treatments(treatment_id)
);

-- Sample Data Insertions

-- Specializations
INSERT INTO Specializations (name) VALUES 
('General Medicine'),
('Pediatrics'),
('Dermatology'),
('Gynecology');

-- Doctors
INSERT INTO Doctors (first_name, last_name, email, phone_number, specialization_id) VALUES
('Mwangi', 'Kamau', 'mwangi.k@clinic.co.ke', '0712345678', 1),
('Achieng', 'Otieno', 'achieng.o@clinic.co.ke', '0723456789', 2),
('Mutiso', 'Njeri', 'njeri.m@clinic.co.ke', '0734567890', 3);

-- Patients
INSERT INTO Patients (first_name, last_name, national_id, date_of_birth, phone_number, email, location) VALUES
('John', 'Kiptoo', '12345678', '1990-04-10', '0700111222', 'john.kiptoo@mail.com', 'Eldoret'),
('Grace', 'Nyambura', '87654321', '1985-08-15', '0711223344', 'grace.nyambura@mail.com', 'Nairobi'),
('Ali', 'Mohammed', '11223344', '1992-12-01', '0700123456', NULL, 'Mombasa');

-- Treatments
INSERT INTO Treatments (name, cost) VALUES
('Malaria Test', 500.00),
('Blood Sugar Test', 300.00),
('Skin Consultation', 1500.00),
('Antenatal Checkup', 1200.00);

-- Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, notes) VALUES
(1, 1, '2025-05-10 10:00:00', 'Scheduled', 'Patient complained of fever'),
(2, 2, '2025-05-12 14:00:00', 'Scheduled', 'Routine checkup for child'),
(3, 3, '2025-05-15 09:00:00', 'Scheduled', 'Skin rash consultation');

-- Appointment_Treatments
INSERT INTO Appointment_Treatments (appointment_id, treatment_id) VALUES
(1, 1),
(1, 2),
(2, 4),
(3, 3);
