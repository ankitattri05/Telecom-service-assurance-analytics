-- ==========================================================
-- Telecom Service Assurance & Cost-to-Serve Analytics Platform
-- File: 02_Create_Database.sql
-- Purpose: Create database, dimension tables, fact table,
--          primary keys and foreign key relationships.
-- ==========================================================

USE `telecom_service_assurance`;

-- ==========================================================
-- Dimension Table: Dim_Date
-- ==========================================================

CREATE TABLE `Dim_Date` (

    `Date_ID` INT UNSIGNED NOT NULL,
    `Date` DATE NOT NULL,
    `Year` SMALLINT UNSIGNED NOT NULL,
    `Quarter` CHAR(2) NOT NULL,
    `Month_Number` TINYINT UNSIGNED NOT NULL,
    `Month_Name` VARCHAR(10) NOT NULL,
    `Month_Short` CHAR(3) NOT NULL,
    `Week_Number` TINYINT UNSIGNED NOT NULL,
    `Day_Number` TINYINT UNSIGNED NOT NULL,
    `Day_Name` VARCHAR(10) NOT NULL,
    `Is_Weekend` BOOLEAN NOT NULL,
    `Year_Month` CHAR(7) NOT NULL,
    `Year_Month_Label` CHAR(8) NOT NULL,

    PRIMARY KEY (`Date_ID`)

) ENGINE=InnoDB;

-- ==========================================================
-- Dimension Table: Dim_VendorTechnology
-- ==========================================================

CREATE TABLE `Dim_VendorTechnology` (

    `VendorTech_ID` TINYINT UNSIGNED NOT NULL,
    `Vendor` VARCHAR(20) NOT NULL,
    `Technology` VARCHAR(20) NOT NULL,
    `Vendor_MTTR_Profile` DECIMAL(4,2) NOT NULL,
    `Vendor_SLA_Risk_Profile` DECIMAL(4,2) NOT NULL,
    `Vendor_Reliability_Profile` DECIMAL(4,2) NOT NULL,

    PRIMARY KEY (`VendorTech_ID`)

) ENGINE=InnoDB;

-- ==========================================================
-- Dimension Table: Dim_Site
-- ==========================================================

CREATE TABLE `Dim_Site` (

    `Site_ID` CHAR(8) NOT NULL,
    `Zone` VARCHAR(15) NOT NULL,
    `State_UT` VARCHAR(25) NOT NULL,
    `Circle` VARCHAR(30) NOT NULL,
    `City` VARCHAR(30) NOT NULL,
    `Site_Cluster` VARCHAR(20) NOT NULL,
    `Site_Type` VARCHAR(20) NOT NULL,
    `Site_Criticality` VARCHAR(10) NOT NULL,
    `Customer_Base` INT UNSIGNED NOT NULL,
    `Power_Backup` VARCHAR(20) NOT NULL,
    `Primary_VendorTech_ID` TINYINT UNSIGNED NOT NULL,
    `Sampling_Weight` DECIMAL(8,2) NOT NULL,
    `Sampling_Probability` DECIMAL(10,8) NOT NULL,

    PRIMARY KEY (`Site_ID`),

    CONSTRAINT `FK_Site_VendorTechnology`
        FOREIGN KEY (`Primary_VendorTech_ID`)
        REFERENCES `Dim_VendorTechnology` (`VendorTech_ID`)

) ENGINE=InnoDB;

-- ==========================================================
-- Dimension Table: Dim_Fault
-- ==========================================================

CREATE TABLE `Dim_Fault` (

    `Fault_ID` CHAR(4) NOT NULL,
    `Fault_Category` VARCHAR(25) NOT NULL,
    `Fault_Name` VARCHAR(50) NOT NULL,
    `Network_Layer` VARCHAR(20) NOT NULL,
    `Fault_Type` VARCHAR(20) NOT NULL,
    `Incident_Share_Weight` TINYINT UNSIGNED NOT NULL,

    PRIMARY KEY (`Fault_ID`)

) ENGINE=InnoDB;

-- ==========================================================
-- Fact Table: Fact_Incident
-- ==========================================================

CREATE TABLE `Fact_Incident` (

    `Incident_ID` CHAR(9) NOT NULL,
    `Date_ID` INT UNSIGNED NOT NULL,
    `Site_ID` CHAR(8) NOT NULL,
    `VendorTech_ID` TINYINT UNSIGNED NOT NULL,
    `Fault_ID` CHAR(4) NOT NULL,

    `Fault_Name` VARCHAR(50) NOT NULL,
    `Fault_Category` VARCHAR(25) NOT NULL,
    `Network_Layer` VARCHAR(20) NOT NULL,
    `Fault_Type` VARCHAR(20) NOT NULL,
    `Vendor_MTTR_Profile` DECIMAL(4,2) NOT NULL,

    `Severity` VARCHAR(10) NOT NULL,
    `Resolution_Type` VARCHAR(25) NOT NULL,
    `Resolution_Minutes` SMALLINT UNSIGNED NOT NULL,
    `SLA_Target_Minutes` SMALLINT UNSIGNED NOT NULL,

    `SLA_Breach` CHAR(3) NOT NULL,
    `Customers_Impacted` INT UNSIGNED NOT NULL,
    `Dispatch_Required` CHAR(3) NOT NULL,
    `Dispatch_Cost` INT UNSIGNED NOT NULL,
    `Estimated_Operational_Cost` DECIMAL(14,2) NOT NULL,
    `Estimated_Service_Impact_Cost` DECIMAL(14,2) NOT NULL,
    `Estimated_Downtime_Cost` DECIMAL(14,2) NOT NULL,
    `Repeat_Fault` CHAR(3) NOT NULL,
    `Escalation` CHAR(3) NOT NULL,

    PRIMARY KEY (`Incident_ID`),

    CONSTRAINT `FK_Fact_Date`
        FOREIGN KEY (`Date_ID`)
        REFERENCES `Dim_Date` (`Date_ID`),

    CONSTRAINT `FK_Fact_Site`
        FOREIGN KEY (`Site_ID`)
        REFERENCES `Dim_Site` (`Site_ID`),

    CONSTRAINT `FK_Fact_VendorTechnology`
        FOREIGN KEY (`VendorTech_ID`)
        REFERENCES `Dim_VendorTechnology` (`VendorTech_ID`),

    CONSTRAINT `FK_Fact_Fault`
        FOREIGN KEY (`Fault_ID`)
        REFERENCES `Dim_Fault` (`Fault_ID`)

) ENGINE=InnoDB;

-- ==========================================================
-- Database schema created successfully.
-- Next: Execute 03_Load_Data.sql to populate all tables.
-- ==========================================================