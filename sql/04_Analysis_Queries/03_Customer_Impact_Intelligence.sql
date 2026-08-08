/* Investigation 3: Customer Impact Intelligence */

/* Analysis 3.1: Overall Customer Impact */

USE `telecom_service_assurance`;

SELECT
    COUNT(*) AS `Total Incidents`,
    SUM(Customers_Impacted) AS `Total Customers Impacted`,
    ROUND(AVG(Customers_Impacted),2) AS `Avg Customers Impacted / Incident`,
    MAX(Customers_Impacted) AS `Highest Customer Impact`,
    ROUND(
        SUM(Customers_Impacted) / COUNT(*),
        2
    ) AS `Average Customer Impact`
FROM Fact_Incident;


/* Analysis 3.2: Fault Categories Driving Customer Impact */

SELECT
    Fault_Category,
    COUNT(*) AS `Total Incidents`,
    SUM(Customers_Impacted) AS `Customers Impacted`,
    ROUND(
        SUM(Customers_Impacted) * 100.0 /
        SUM(SUM(Customers_Impacted)) OVER (),
        2
    ) AS `Share of Customer Impact (%)`,
    ROUND(AVG(Customers_Impacted),2) AS `Avg Customers / Incident`
FROM Fact_Incident
GROUP BY Fault_Category
ORDER BY `Customers Impacted` DESC;


/* Analysis 3.3: Customer Impact by Site Criticality */

SELECT
    ds.Site_Criticality,
    COUNT(*) AS `Total Incidents`,
    SUM(fi.Customers_Impacted) AS `Customers Impacted`,
    ROUND(
        SUM(fi.Customers_Impacted) * 100.0 /
        SUM(SUM(fi.Customers_Impacted)) OVER (),
        2
    ) AS `Share of Customer Impact (%)`,
    ROUND(AVG(fi.Customers_Impacted),2) AS `Avg Customers / Incident`
FROM Fact_Incident fi
JOIN Dim_Site ds
    ON fi.Site_ID = ds.Site_ID
GROUP BY ds.Site_Criticality
ORDER BY `Customers Impacted` DESC;


/*Key Takeaway
--Most customer impact is concentrated in a few fault categories and Tier 1 sites.
-- Prioritizing these areas will reduce service disruption for the largest number of customers.