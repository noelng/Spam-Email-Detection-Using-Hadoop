CREATE EXTERNAL TABLE tmp_csv_emails3 (id STRING, label STRING, text STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/group-project/temp/emails-3-csv';

CREATE TABLE tmp_avro_emails3 (id STRING, label STRING, text STRING)
STORED AS AVRO
LOCATION '/group-project/temp/emails-3-avro';

INSERT INTO tmp_avro_emails3 SELECT * FROM tmp_csv_emails3;