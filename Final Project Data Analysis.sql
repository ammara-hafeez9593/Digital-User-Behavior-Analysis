CREATE DATABASE logicstack_july2026;
USE logicstack_july2026;
USE logicstack_july2026;

CREATE TABLE client_site_dataset (
    user_id VARCHAR(20),
    session_id VARCHAR(20),
    event_time VARCHAR(20),
    event VARCHAR(50),
    device VARCHAR(30),
    region VARCHAR(50),
    channel VARCHAR(50),
    product_category VARCHAR(50),
    revenue DECIMAL(10,2),
    bonus_flag VARCHAR(10)
);
LOAD DATA LOCAL INFILE 'C:/Users/User/Downloads/client_site_dataset.csv'
INTO TABLE client_site_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(user_id,
 session_id,
 event_time,
 event,
 device,
 region,
 channel,
 product_category,
 revenue,
 bonus_flag);
 
 -- Task 1: Data Exploration
 
 -- Total Rows in Dataset
 SELECT COUNT(*) AS Total_Rows
FROM client_site_dataset;

-- Unique Users
SELECT COUNT(DISTINCT user_id) AS Unique_Users
FROM client_site_dataset;

--  Unique Sessions
SELECT COUNT(DISTINCT session_id) AS Unique_Sessions
FROM client_site_dataset;

-- List All Event Types
SELECT DISTINCT event
FROM client_site_dataset;

-- Task 2: Funnel Stage Analysis

-- Task 2.1: Count Total Events by Type
SELECT
    event,
    COUNT(*) AS Total_Events
FROM client_site_dataset
GROUP BY event
ORDER BY Total_Events DESC;

-- Task 2.2: Count Unique Users per Event Type
SELECT
    event,
    COUNT(DISTINCT user_id) AS Unique_Users
FROM client_site_dataset
GROUP BY event
ORDER BY Unique_Users DESC;

-- Task 2.3: Conversion from Browse to Purchase
SELECT
    COUNT(DISTINCT CASE WHEN event = 'Browse' THEN user_id END) AS Browse_Users,
    COUNT(DISTINCT CASE WHEN event = 'Purchase' THEN user_id END) AS Purchase_Users,
    ROUND(
        COUNT(DISTINCT CASE WHEN event = 'Purchase' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event = 'Browse' THEN user_id END),
        2
    ) AS Conversion_Rate_Percentage
FROM client_site_dataset;

-- Task 3: Revenue Analysis

-- Task 3.1: Calculate Total Revenue
SELECT
    SUM(revenue) AS Total_Revenue
FROM client_site_dataset;

-- Task 3.2: Calculate Revenue by Region
SELECT
    region,
    SUM(revenue) AS Total_Revenue
FROM client_site_dataset
GROUP BY region
ORDER BY Total_Revenue DESC;

-- Task 3.3: Calculate Revenue by Channel
SELECT
    channel,
    SUM(revenue) AS Total_Revenue
FROM client_site_dataset
GROUP BY channel
ORDER BY Total_Revenue DESC;

-- Task 3.4: Calculate Revenue by Device
SELECT
    device,
    SUM(revenue) AS Total_Revenue
FROM client_site_dataset
GROUP BY device
ORDER BY Total_Revenue DESC;

-- Task 4: Business Insights Queries

-- Task 4.1: Top 5 Users by Revenue
SELECT
    user_id,
    SUM(revenue) AS Total_Revenue
FROM client_site_dataset
GROUP BY user_id
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Task 4.2: Best Performing Channel
SELECT
    channel,
    SUM(revenue) AS Total_Revenue
FROM client_site_dataset
GROUP BY channel
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Task 4.3: Highest Revenue Region
SELECT
    region,
    SUM(revenue) AS Total_Revenue
FROM client_site_dataset
GROUP BY region
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Task 4.4: Device with Highest Conversion Rate
SELECT
    device,
    COUNT(DISTINCT CASE WHEN event = 'Browse' THEN user_id END) AS Browse_Users,
    COUNT(DISTINCT CASE WHEN event = 'Purchase' THEN user_id END) AS Purchase_Users,
    ROUND(
        COUNT(DISTINCT CASE WHEN event = 'Purchase' THEN user_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event = 'Browse' THEN user_id END),
        2
    ) AS Conversion_Rate
FROM client_site_dataset
GROUP BY device
ORDER BY Conversion_Rate DESC;

-- Task 5: Drop-off Analysis
-- Task 5.1: Funnel Drop-off Analysis
SELECT
    event,
    COUNT(*) AS Total_Events
FROM client_site_dataset
GROUP BY event
ORDER BY Total_Events DESC;

-- Task 5.2: Event Type with Lowest Conversion
SELECT
    event,
    COUNT(*) AS Total_Events,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM client_site_dataset WHERE event = 'Browse'),
        2
    ) AS Conversion_Percentage
FROM client_site_dataset
GROUP BY event
ORDER BY Conversion_Percentage ASC;

