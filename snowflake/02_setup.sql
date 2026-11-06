use role sysadmin;
use warehouse transform_wh;
use schema raw.olist;

create or replace file format csv_olist
    type = csv
    skip_header = 1
    field_optionally_enclosed_by = '"'
    null_if = ('');

create or replace stage olist_stage
    file_format = (format_name = 'csv_olist');
list @olist_stage;

create table customers (customer_id varchar, customer_unique_id varchar, customer_zip_code_prefix varchar, customer_city varchar, customer_state varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table geolocation (geolocation_zip_code_prefix varchar, geolocation_lat varchar, geolocation_lng varchar, geolocation_city varchar, geolocation_state varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table order_items (order_id varchar, order_item_id varchar, product_id varchar, seller_id varchar, shipping_limit_date varchar, price varchar, freight_value varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table order_payments (order_id varchar, payment_sequential varchar, payment_type varchar, payment_installments varchar, payment_value varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table order_reviews (review_id varchar, order_id varchar, review_score varchar, review_comment_title varchar, review_comment_message varchar, review_creation_date varchar, review_answer_timestamp varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table orders (order_id varchar, customer_id varchar, order_status varchar, order_purchase_timestamp varchar, order_approved_at varchar, order_delivered_carrier_date varchar, order_delivered_customer_date varchar, order_estimated_delivery_date varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table products (product_id varchar, product_category_name varchar, product_name_lenght varchar, product_description_lenght varchar, product_photos_qty varchar, product_weight_g varchar, product_length_cm varchar, product_height_cm varchar, product_width_cm varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table sellers (seller_id varchar, seller_zip_code_prefix varchar, seller_city varchar, seller_state varchar, _source_file varchar, _loaded_at timestamp_ltz);

create table category_translation (product_category_name varchar, product_category_name_english varchar, _source_file varchar, _loaded_at timestamp_ltz);


copy into customers from (select $1,$2,$3,$4,$5, metadata$filename, current_timestamp() from @olist_stage/olist_customers_dataset.csv);
copy into geolocation from (select $1,$2,$3,$4,$5, metadata$filename, current_timestamp() from @olist_stage/olist_geolocation_dataset.csv);
copy into order_items from (select $1,$2,$3,$4,$5,$6,$7, metadata$filename, current_timestamp() from @olist_stage/olist_order_items_dataset.csv);
copy into order_payments from (select $1,$2,$3,$4,$5, metadata$filename, current_timestamp() from @olist_stage/olist_order_payments_dataset.csv);
copy into order_reviews from (select $1,$2,$3,$4,$5,$6,$7, metadata$filename, current_timestamp() from @olist_stage/olist_order_reviews_dataset.csv);
copy into orders from (select $1,$2,$3,$4,$5,$6,$7,$8, metadata$filename, current_timestamp() from @olist_stage/olist_orders_dataset.csv);
copy into products from (select $1,$2,$3,$4,$5,$6,$7,$8,$9, metadata$filename, current_timestamp() from @olist_stage/olist_products_dataset.csv);
copy into sellers from (select $1,$2,$3,$4, metadata$filename, current_timestamp() from @olist_stage/olist_sellers_dataset.csv);
copy into category_translation from (select $1,$2, metadata$filename, current_timestamp() from @olist_stage/product_category_name_translation.csv);


select table_name, file_name, row_parsed, row_count, error_count, status
from raw.information_schema.load_history
where schema_name = 'OLIST'
order by table_name;

select system$clustering_information('raw.olist.geolocation', '(geolocation_zip_code_prefix)');
select count(*) from raw.olist.geolocation where geolocation_zip_code_prefix = '14409';