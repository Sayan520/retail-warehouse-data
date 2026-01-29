INSERT INTO master_client_list (customer_id, full_name, email, country)
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name),
    LOWER(email),
    country
FROM online_store_users
WHERE is_active = 1;

INSERT INTO master_client_list (customer_id, full_name, email, country)
SELECT
    online_store_users.customer_id,
    CONCAT(online_store_users.first_name, ' ', online_store_users.last_name),
    LOWER(online_store_users.email),
    online_store_users.country
FROM online_store_users
LEFT JOIN master_client_list
    ON online_store_users.customer_id = master_client_list.customer_id
WHERE master_client_list.customer_id IS NULL;

MERGE INTO master_client_list
USING online_store_users
ON master_client_list.customer_id = online_store_users.customer_id
WHEN MATCHED
AND (
    master_client_list.email <> LOWER(online_store_users.email)
    OR master_client_list.country <> online_store_users.country
)
THEN UPDATE SET
    email = LOWER(online_store_users.email),
    country = online_store_users.country;
