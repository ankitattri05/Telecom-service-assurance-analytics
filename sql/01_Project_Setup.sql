-- ==========================================================
-- Telecom Service Assurance & Cost-to-Serve Analytics Platform
-- File: 01_Project_Setup.sql
-- Purpose: Create a clean database for the final validated CSV load.
-- Safety: This affects only telecom_service_assurance_final.
-- ==========================================================

DROP DATABASE IF EXISTS telecom_service_assurance;

CREATE DATABASE telecom_service_assurance
    CHARACTER SET utf8mb4;

USE telecom_service_assurance;

-- ==========================================================
-- Database created.
-- Next: Execute 02_Create_Database.sql
-- ==========================================================