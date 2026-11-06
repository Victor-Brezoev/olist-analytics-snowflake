use role sysadmin;

create warehouse transform_wh
warehouse_size = xsmall
auto_suspend = 60
auto_resume = true
initially_suspended = true;

create warehouse reporting_wh
warehouse_size = xsmall
auto_suspend = 60
auto_resume = true
initially_suspended = true;

create database raw;
create schema raw.olist;
create database analytics;

use role securityadmin;

create role transformer;
create role reporter;
grant role transformer to role sysadmin;
grant role reporter to role sysadmin;

grant usage on warehouse transform_wh to role transformer; 
grant usage on database raw to role transformer;
grant usage on schema raw.olist to role transformer;
grant select on future tables in schema raw.olist to role transformer;
grant usage, create schema on database analytics to role transformer;

grant usage on warehouse reporting_wh to role reporter;
grant usage on database analytics to role reporter;
grant usage on future schemas in database analytics to role reporter;



use role useradmin;
create user dbt_svc
    type = service
    default_role = transformer
    default_warehouse = transform_wh
    rsa_public_key = '<public key>';

use role securityadmin;
grant role transformer to user dbt_svc;