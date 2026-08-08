/* Investigation 1: Operational Cost Intelligence */

/* Analysis 1.1: Overall Cost-to-Serve */
USE `telecom_service_assurance`;
SELECT

    COUNT(*) AS `Total Incidents`,

    ROUND(SUM(`Estimated_Operational_Cost`), 2) AS `Operational Cost (₹)`,

    ROUND(SUM(`Estimated_Service_Impact_Cost`), 2) AS `Service Impact Cost (₹)`,

    ROUND(SUM(`Estimated_Total_Incident_Cost`), 2) AS `Total Cost-to-Serve (₹)`,

    ROUND(AVG(`Estimated_Operational_Cost`), 2) AS `Avg Operational Cost / Incident (₹)`,

    ROUND(AVG(`Estimated_Service_Impact_Cost`), 2) AS `Avg Service Impact Cost / Incident (₹)`,

    ROUND(AVG(`Estimated_Total_Incident_Cost`), 2) AS `Avg Total Cost / Incident (₹)`

FROM Fact_Incident;


/* Analysis 1.2: Operational Cost Drivers */

SELECT

    Dispatch_Required,

    COUNT(*) AS `Incidents`,

    ROUND(SUM(Estimated_Operational_Cost),2) AS `Operational Cost (₹)`,

    ROUND(AVG(Estimated_Operational_Cost),2) AS `Avg Cost / Incident (₹)`,

    ROUND(
        SUM(Estimated_Operational_Cost) * 100 /
        (SELECT SUM(Estimated_Operational_Cost)
         FROM Fact_Incident),2
    ) AS `Cost Contribution (%)`

FROM Fact_Incident

GROUP BY Dispatch_Required

ORDER BY `Operational Cost (₹)` DESC;


/* Analysis 1.3: Resolution Strategies Driving Dispatch */ 

SELECT

    Severity,

    COUNT(*) AS `Total Incidents`,

    SUM(CASE WHEN Dispatch_Required = 'Yes' THEN 1 ELSE 0 END) AS `Dispatched Incidents`,

    ROUND(
        SUM(CASE WHEN Dispatch_Required = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),2
    ) AS `Dispatch Rate (%)`,

    ROUND(
        AVG(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN Estimated_Operational_Cost
            END),2
    ) AS `Avg Operational Cost (₹)`,

    ROUND(
        SUM(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN Estimated_Operational_Cost
                ELSE 0
            END),2
    ) AS `Total Operational Cost (₹)`

FROM Fact_Incident

GROUP BY Severity

ORDER BY
    `Dispatch Rate (%)` DESC,
    `Total Operational Cost (₹)` DESC;
    
    

SELECT

    Resolution_Type,

    COUNT(*) AS `Total Incidents`,

    SUM(CASE
            WHEN Dispatch_Required = 'Yes'
            THEN 1
            ELSE 0
        END) AS `Dispatched Incidents`,

    ROUND(
        SUM(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN 1
                ELSE 0
            END) * 100.0 /
        COUNT(*),2
    ) AS `Dispatch Rate (%)`,

    ROUND(
        AVG(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN Estimated_Operational_Cost
            END),2
    ) AS `Avg Operational Cost (₹)`,

    ROUND(
        SUM(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN Estimated_Operational_Cost
                ELSE 0
            END),2
    ) AS `Total Operational Cost (₹)`

FROM Fact_Incident

GROUP BY Resolution_Type

ORDER BY
    `Dispatch Rate (%)` DESC,
    `Total Operational Cost (₹)` DESC;
    
    
    /* Analysis 1.4: Fault Categories Driving Dispatch */

SELECT

    Fault_Category,

    COUNT(*) AS `Total Incidents`,

    SUM(CASE
            WHEN Dispatch_Required = 'Yes'
            THEN 1
            ELSE 0
        END) AS `Dispatched Incidents`,

    ROUND(
        SUM(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN 1
                ELSE 0
            END) * 100.0 /
        COUNT(*),2
    ) AS `Dispatch Rate (%)`,

    ROUND(
        SUM(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN Estimated_Operational_Cost
                ELSE 0
            END),2
    ) AS `Operational Cost (₹)`,

    ROUND(
        AVG(CASE
                WHEN Dispatch_Required = 'Yes'
                THEN Estimated_Operational_Cost
            END),2
    ) AS `Avg Cost / Dispatch (₹)`

FROM Fact_Incident

GROUP BY Fault_Category

ORDER BY
    `Dispatch Rate (%)` DESC,
    `Operational Cost (₹)` DESC;
    
    
/* Analysis 1.5: Operational Cost by Vendor Technology */

SELECT

    dvt.Vendor,

    dvt.Technology,

    COUNT(*) AS `Total Incidents`,

    SUM(CASE
            WHEN fi.Dispatch_Required = 'Yes' THEN 1
            ELSE 0
        END) AS `Dispatched Incidents`,

    ROUND(
        SUM(CASE
                WHEN fi.Dispatch_Required = 'Yes' THEN 1
                ELSE 0
            END) * 100.0 /
        COUNT(*),2
    ) AS `Dispatch Rate (%)`,

    ROUND(
        SUM(CASE
                WHEN fi.Dispatch_Required = 'Yes'
                THEN fi.Estimated_Operational_Cost
                ELSE 0
            END),2
    ) AS `Operational Cost (₹)`

FROM Fact_Incident fi

INNER JOIN Dim_VendorTechnology dvt
ON fi.VendorTech_ID = dvt.VendorTech_ID

GROUP BY
    dvt.Vendor,
    dvt.Technology

ORDER BY
    `Operational Cost (₹)` DESC,
    `Dispatch Rate (%)` DESC;
    
    
/*Key Takeaway
--Most operational costs come from field dispatch.
-- Reducing unnecessary dispatches will have the biggest impact on operational cost.