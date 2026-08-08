-- ==========================================================
-- Telecom Service Assurance & Cost-to-Serve Analytics Platform
-- File: 03_Load_Data.sql
-- Purpose: Load dimension and fact tables from CSV files.
-- ==========================================================

USE `telecom_service_assurance`;

-- ==========================================================
-- Load: Dim_Date
-- ==========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Dead By Sunrise/Desktop/Telecom Service Assurance Tables/Dim_Date.csv'
INTO TABLE `Dim_Date`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
`Date`,
`Date_ID`,
`Year`,
`Quarter`,
`Month_Number`,
`Month_Name`,
`Month_Short`,
`Week_Number`,
`Day_Number`,
`Day_Name`,
`Is_Weekend`,
`Year_Month`,
`Year_Month_Label`
);

-- ==========================================================
-- Load: Dim_Fault
-- ==========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Dead By Sunrise/Desktop/Telecom Service Assurance Tables/Dim_Fault.csv'
INTO TABLE `Dim_Fault`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
`Fault_ID`,
`Fault_Category`,
`Fault_Name`,
`Network_Layer`,
`Fault_Type`,
`Incident_Share_Weight`
);

-- ==========================================================
-- Load: Dim_VendorTechnology
-- ==========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Dead By Sunrise/Desktop/Telecom Service Assurance Tables/Dim_VendorTechnology.csv'
INTO TABLE `Dim_VendorTechnology`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
`Vendor`,
`Technology`,
`VendorTech_ID`,
`Vendor_MTTR_Profile`,
`Vendor_SLA_Risk_Profile`,
`Vendor_Reliability_Profile`
);

-- ==========================================================
-- Load: Dim_Site
-- ==========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Dead By Sunrise/Desktop/Telecom Service Assurance Tables/Dim_Site.csv'
INTO TABLE `Dim_Site`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
`Site_ID`,
`Zone`,
`State_UT`,
`Circle`,
`City`,
`Site_Cluster`,
`Site_Type`,
`Site_Criticality`,
`Customer_Base`,
`Power_Backup`,
`Primary_VendorTech_ID`,
`Sampling_Weight`,
`Sampling_Probability`
);

-- ==========================================================
-- Load: Fact_Incident
-- ==========================================================

LOAD DATA LOCAL INFILE
'C:/Users/Dead By Sunrise/Desktop/Telecom Service Assurance Tables/Fact_Incident.csv'
INTO TABLE `Fact_Incident`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
`Incident_ID`,
`Date_ID`,
`Site_ID`,
`VendorTech_ID`,
`Fault_ID`,
`Fault_Name`,
`Fault_Category`,
`Network_Layer`,
`Fault_Type`,
`Vendor_MTTR_Profile`,
`Severity`,
`Resolution_Type`,
`Resolution_Minutes`,
`SLA_Target_Minutes`,
`SLA_Breach`,
`Customers_Impacted`,
`Dispatch_Required`,
`Dispatch_Cost`,
`Estimated_Operational_Cost`,
`Estimated_Service_Impact_Cost`,
`Estimated_Total_Incident_Cost`,
`Repeat_Fault`,
`Escalation`
);

-- ==========================================================
-- Data loaded successfully.
-- Next: Execute 04_Data_Validation.sql
-- ==========================================================