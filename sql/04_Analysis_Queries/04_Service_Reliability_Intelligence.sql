/* Investigation 4: Service Reliability Intelligence */

/* Analysis 4.1: Overall Service Reliability */

USE `telecom_service_assurance`;

SELECT
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) AS `Repeat Faults`,
    SUM(CASE WHEN Repeat_Fault = 'No' THEN 1 ELSE 0 END) AS `First-Time Faults`,
    ROUND(
        SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
        2
    ) AS `Repeat Fault Rate (%)`
FROM Fact_Incident;


/* Analysis 4.2: Fault Categories Driving Repeat Faults */

SELECT
    Fault_Category,
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) AS `Repeat Faults`,
    ROUND(
        SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        SUM(SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END)) OVER (),
        2
    ) AS `Contribution to Repeat Faults (%)`,
    ROUND(
        SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
        2
    ) AS `Repeat Fault Rate (%)`
FROM Fact_Incident
GROUP BY Fault_Category
HAVING `Repeat Faults` > 0
ORDER BY `Repeat Faults` DESC;


/* Analysis 4.3: Resolution Strategies Driving Repeat Faults */

SELECT
    Resolution_Type,
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) AS `Repeat Faults`,
    ROUND(
        SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        SUM(SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END)) OVER (),
        2
    ) AS `Contribution to Repeat Faults (%)`,
    ROUND(
        SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
        2
    ) AS `Repeat Fault Rate (%)`
FROM Fact_Incident
GROUP BY Resolution_Type
HAVING `Repeat Faults` > 0
ORDER BY `Repeat Fault Rate (%)` DESC,
         `Repeat Faults` DESC;
         
         
/* Analysis 4.4: Resolution Strategies for High-Repeat Fault Categories */

SELECT
    Fault_Category,
    Resolution_Type,
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) AS `Repeat Faults`,
    ROUND(
        SUM(CASE WHEN Repeat_Fault = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
        2
    ) AS `Repeat Fault Rate (%)`
FROM Fact_Incident
WHERE Fault_Category IN (
    'Customer Premises',
    'Optical Network',
    'Access Equipment'
)
GROUP BY
    Fault_Category,
    Resolution_Type
HAVING `Total Incidents` >= 50
ORDER BY
    Fault_Category,
    `Repeat Fault Rate (%)` DESC;
    
    
/* Analysis 4.5: Business Impact of Repeat Faults */

SELECT
    Repeat_Fault,
    COUNT(*) AS `Total Incidents`,
    ROUND(SUM(Estimated_Operational_Cost),2) AS `Operational Cost`,
    ROUND(SUM(Estimated_Service_Impact_Cost),2) AS `Service Impact Cost`,
    ROUND(SUM(Estimated_Total_Incident_Cost),2) AS `Total Incident Cost`,
    ROUND(AVG(Estimated_Total_Incident_Cost),2) AS `Avg Cost per Incident`
FROM Fact_Incident
GROUP BY Repeat_Fault;
    
    
/*Key Takeaway
-- Repeat faults do not cost more per incident, but reducing them can improve service reliability by preventing recurring operational issues.