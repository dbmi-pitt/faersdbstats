--######################################################
--# Create FDA New Drug Application (NDA) Orange Book staging table DDL and
--# Load the data file into the nda table
--#
--# Lifted Up 614 LLC
--######################################################
set search_path = ${DATABASE_SCHEMA};

--drop table if exists nda;
create table if not exists nda
(
ingredient varchar,
dfroute varchar,
trade_name varchar,
applicant varchar,
strength varchar,
appl_type varchar,
appl_no varchar,
product_no varchar,
te_code varchar,
approval_date varchar,
rld varchar,
rs varchar,
type varchar,
applicant_full_name varchar,
drug_form varchar,
route varchar
);
--truncate nda;