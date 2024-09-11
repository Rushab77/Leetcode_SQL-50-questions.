-- Step 1: Find the first order for each customer
WITH FirstOrders AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
),

-- Step 2: Join the first orders with the original table to get the delivery details
FirstOrderDetails AS (
    SELECT 
        d.customer_id,
        d.delivery_id,
        d.order_date,
        d.customer_pref_delivery_date
    FROM Delivery d
    JOIN FirstOrders fo
    ON d.customer_id = fo.customer_id
    AND d.order_date = fo.first_order_date
),

-- Step 3: Determine if each first order is immediate
ImmediateOrders AS (
    SELECT
        COUNT(*) AS immediate_count
    FROM FirstOrderDetails
    WHERE order_date = customer_pref_delivery_date
),

-- Step 4: Count total number of first orders
TotalFirstOrders AS (
    SELECT
        COUNT(*) AS total_count
    FROM FirstOrderDetails
)

-- Step 5: Calculate the percentage of immediate orders
SELECT
    ROUND(
        (SELECT immediate_count FROM ImmediateOrders) / 
        (SELECT total_count FROM TotalFirstOrders) * 100,
        2
    ) AS immediate_percentage
;
