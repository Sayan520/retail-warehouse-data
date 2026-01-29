INSERT INTO revenue_transactions (
    order_id,
    customer_id,
    product_id,
    order_date,
    total_amount
)
SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    total_amount
FROM validated_trades;

INSERT INTO revenue_transactions (
    order_id,
    customer_id,
    product_id,
    order_date,
    total_amount
)
SELECT
    validated_trades.order_id,
    validated_trades.customer_id,
    validated_trades.product_id,
    validated_trades.order_date,
    validated_trades.total_amount
FROM validated_trades
JOIN catalog_items
    ON validated_trades.product_id = catalog_items.product_id;

MERGE INTO revenue_transactions
USING validated_trades
ON revenue_transactions.order_id = validated_trades.order_id
WHEN MATCHED THEN
UPDATE SET
    total_amount = validated_trades.total_amount;
