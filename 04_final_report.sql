INSERT INTO executive_dashboard (
    customer_id,
    total_orders,
    total_spent
)
SELECT
    master_client_list.customer_id,
    COUNT(revenue_transactions.order_id),
    SUM(revenue_transactions.total_amount)
FROM master_client_list
JOIN revenue_transactions
    ON master_client_list.customer_id = revenue_transactions.customer_id
GROUP BY master_client_list.customer_id;

INSERT INTO executive_dashboard (
    customer_id,
    total_orders,
    total_spent
)
SELECT
    customer_id,
    COUNT(order_id),
    SUM(total_amount)
FROM revenue_transactions
GROUP BY customer_id
HAVING SUM(total_amount) > 10000;

MERGE INTO executive_dashboard
USING (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_spent
    FROM revenue_transactions
    GROUP BY customer_id
)
ON executive_dashboard.customer_id = customer_id
WHEN MATCHED THEN
UPDATE SET
    total_orders = total_orders,
    total_spent = total_spent;
