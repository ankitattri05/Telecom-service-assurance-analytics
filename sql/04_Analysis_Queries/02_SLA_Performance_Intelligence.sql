/* Investigation 2: SLA Performance Intelligence */

/* Analysis 2.1: Overall SLA Performance */

USE `telecom_service_assurance`;

SELECT
    COUNT(*) AS `Total Incidents`,

    SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) AS `SLA Breaches`,

    SUM(CASE WHEN SLA_Breach = 'No' THEN 1 ELSE 0 END) AS `SLA Met`,

    ROUND(
        SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS `SLA Breach (%)`,

    ROUND(
        SUM(CASE WHEN SLA_Breach = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS `SLA Compliance (%)`,

    ROUND(AVG(Resolution_Minutes), 2) AS `Avg Resolution Time (Minutes)`

FROM Fact_Incident;


/* Analysis 2.2: Resolution Strategies Causing SLA Breaches */

SELECT
    Resolution_Type,
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) AS `SLA Breaches`,
    ROUND(
        SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS `SLA Breach (%)`,
    ROUND(AVG(Resolution_Minutes), 2) AS `Avg Resolution Time (Minutes)`
FROM Fact_Incident
GROUP BY Resolution_Type
ORDER BY `SLA Breach (%)` DESC, `Total Incidents` DESC;


/* Analysis 2.3: Fault Categories Contributing to SLA Breaches */

SELECT
    Fault_Category,
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) AS `SLA Breaches`,
    ROUND(
        SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        SUM(SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END)) OVER (),
        2
    ) AS `Share of SLA Breaches (%)`,
    ROUND(
        SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS `SLA Breach Rate (%)`
FROM Fact_Incident
GROUP BY Fault_Category
ORDER BY `SLA Breaches` DESC;


/* Analysis 2.4: Impact of Escalation and Repeat Faults on SLA Performance */

SELECT
    Escalation,
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) AS `SLA Breaches`,
    ROUND(
        SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS `SLA Breach Rate (%)`
FROM Fact_Incident
GROUP BY Escalation
ORDER BY `SLA Breach Rate (%)` DESC;

SELECT
    Repeat_Fault,
    COUNT(*) AS `Total Incidents`,
    SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) AS `SLA Breaches`,
    ROUND(
        SUM(CASE WHEN SLA_Breach = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS `SLA Breach Rate (%)`
FROM Fact_Incident
GROUP BY Repeat_Fault
ORDER BY `SLA Breach Rate (%)` DESC;


/*Key Takeaway
-- Most SLA breaches are driven by field operations, especially escalated incidents and network-related faults.
-- Focusing on these areas will have the biggest impact on improving SLA performance.