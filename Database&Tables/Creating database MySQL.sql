-- creating a database in MySQL
CREATE database drugservice;

CREATE TABLE drugs (
    drug_id INT AUTO_INCREMENT PRIMARY KEY,
    drug_code VARCHAR(50) UNIQUE NOT NULL,
    drug_name VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    is_controlled BOOLEAN NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
SELECT *
FROM drugs;

CREATE TABLE facilities (
    facility_id INT AUTO_INCREMENT PRIMARY KEY,
    facility_name VARCHAR(200),
    facility_type VARCHAR(50),
    region VARCHAR(100)
);
 SELECT *
 FROM facilities;

INSERT INTO drugs
(drug_code, drug_name, category, is_controlled, created_date)
VALUES
('PARA500', 'Paracetamol 500mg', 'Pain Relief', FALSE, '2024-01-10'),
('IBU200', 'Ibuprofen 200mg', 'Pain Relief', FALSE, '2024-01-12'),
('ASP100', 'Aspirin 100mg', 'Pain Relief', FALSE, '2024-01-15'),
('AMOX500', 'Amoxicillin 500mg', 'Antibiotic', FALSE, '2024-02-01'),
('AZI250', 'Azithromycin 250mg', 'Antibiotic', FALSE, '2024-02-05'),
('MET1000', 'Metformin 1000mg', 'Diabetes', FALSE, '2024-02-20'),
('ATOR20', 'Atorvastatin 20mg', 'Cholesterol', FALSE, '2024-03-01');


 -- check the data in the drugs table
 SELECT *
 FROM drugs;
 
INSERT INTO facilities
(facility_name, facility_type, region)
VALUES
('National Referral Hospital', 'Hospital', 'Central'),
('North City General Hospital', 'Hospital', 'North'),
('East Regional Hospital', 'Hospital', 'East'),
('South Community Pharmacy', 'Pharmacy', 'South'),
('West End Pharmacy', 'Pharmacy', 'West'),
('Central Medical Clinic', 'Clinic', 'Central'),
('Northern District Pharmacy', 'Pharmacy', 'North');

select*
from facilities;


-- create staging database

CREATE DATABASE drugservice_staging;
CREATE TABLE drugservice_staging.drug_staging
LIKE drugservice.drugs;

select*
from drug_staging;

INSERT INTO drugservice_staging.drug_staging
select  *
from drugservice.drugs;

select *
from drug_staging;

-- creating the second table
CREATE TABLE drugservice_staging.facilities_staging
LIKE drugservice.facilities;

SELECT *
FROM facilities_staging;

INSERT INTO drugservice_staging.facilities_staging
select*
from drugservice.facilities;

select *
from facilities_staging;



