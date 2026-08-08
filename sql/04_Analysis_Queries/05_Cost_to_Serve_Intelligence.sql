/* Investigation 5: Cost-to-Serve Intelligence */

/* Analysis 5.1: Overall Cost Overview */

USE `telecom_service_assurance`;

SELECT
    COUNT(*) AS `Total Incidents`,
    ROUND(SUM(Estimated_Operational_Cost), 2) AS `Total Operational Cost`,
    ROUND(SUM(Estimated_Service_Impact_Cost), 2) AS `Total Service Impact Cost`,
    ROUND(SUM(Estimated_Total_Incident_Cost), 2) AS `Total Incident Cost`,
    ROUND(AVG(Estimated_Total_Incident_Cost), 2) AS `Average Cost per Incident`
FROM Fact_Incident;


/* Analysis 5.2: Resolution Strategies Driving Service Assurance Cost */

SELECT
    Resolution_Type,
    COUNT(*) AS `Total Incidents`,
    ROUND(SUM(Estimated_Total_Incident_Cost), 2) AS `Total Incident Cost`,
    ROUND(
        SUM(Estimated_Total_Incident_Cost) * 100.0 /
        (SELECT SUM(Estimated_Total_Incident_Cost) FROM Fact_Incident),
        2
    ) AS `Cost Contribution (%)`,
    ROUND(AVG(Estimated_Total_Incident_Cost), 2) AS `Average Cost per Incident`
FROM Fact_Incident
GROUP BY Resolution_Type
ORDER BY `Total Incident Cost` DESC;


/* Analysis 5.3: Fault Categories Driving High-Cost Resolution Strategies */

SELECT
    Resolution_Type,
    Fault_Category,
    COUNT(*) AS `Total Incidents`,
    ROUND(SUM(Estimated_Total_Incident_Cost), 2) AS `Total Incident Cost`,
    ROUND(AVG(Estimated_Total_Incident_Cost), 2) AS `Average Cost per Incident`
FROM Fact_Incident
WHERE Resolution_Type IN (
    'Fiber Team Dispatch',
    'Vendor Support'
)
GROUP BY
    Resolution_Type,
    Fault_Category
ORDER BY
    Resolution_Type,
    `Total Incident Cost` DESC;
    
    
    /* Analysis 5.4: Cost Efficiency of Resolution Strategies */

SELECT
    Resolution_Type,
    COUNT(*) AS `Total Incidents`,
    ROUND(AVG(Estimated_Operational_Cost), 2) AS `Avg Operational Cost`,
    ROUND(AVG(Estimated_Service_Impact_Cost), 2) AS `Avg Service Impact Cost`,
    ROUND(AVG(Estimated_Total_Incident_Cost), 2) AS `Avg Total Incident Cost`
FROM Fact_Incident
GROUP BY Resolution_Type
ORDER BY `Avg Total Incident Cost` DESC;


/* Analysis 5.5: Financial Impact of SLA Breaches and Escalations */

SELECT
    SLA_Breach,
    Escalation,
    COUNT(*) AS `Total Incidents`,
    ROUND(AVG(Estimated_Operational_Cost), 2) AS `Avg Operational Cost`,
    ROUND(AVG(Estimated_Service_Impact_Cost), 2) AS `Avg Service Impact Cost`,
    ROUND(AVG(Estimated_Total_Incident_Cost), 2) AS `Avg Total Incident Cost`,
    ROUND(SUM(Estimated_Total_Incident_Cost), 2) AS `Total Incident Cost`
FROM Fact_Incident
GROUP BY
    SLA_Breach,
    Escalation
ORDER BY
    `Avg Total Incident Cost` DESC;
    
/*Key Takeaway   
-- Field dispatches account for the largest share of service assurance costs.
-- Vendor support and hardware replacements are the most expensive resolution methods when they are required.
-- Improving first-time diagnosis and reducing unnecessary escalations can help lower overall operational costs.