INSERT INTO catalog_items (product_id, product_name, category)
SELECT DISTINCT
    product_id,
    product_name,
    category
FROM inventory_snapshot;

INSERT INTO validated_trades (
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    total_amount
)
SELECT
    incoming_orders.order_id,
    incoming_orders.customer_id,
    incoming_orders.product_id,
    incoming_orders.order_date,
    incoming_orders.quantity,
    incoming_orders.quantity * inventory_snapshot.price
FROM incoming_orders
JOIN inventory_snapshot
    ON incoming_orders.product_id = inventory_snapshot.product_id;

MERGE INTO validated_trades
USING incoming_orders
ON validated_trades.order_id = incoming_orders.order_id
WHEN MATCHED THEN
UPDATE SET
    quantity = incoming_orders.quantity;
