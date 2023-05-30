CREATE EXTERNAL TABLE tmp_csv_emails4 (id STRING, label STRING, text STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LOCATION '/group-project/temp/emails-4-csv';

CREATE TABLE tmp_rcfile_emails4 (id STRING, label STRING, text STRING)
STORED AS RCFILE
LOCATION '/group-project/temp/emails-4-rcfile';

INSERT INTO tmp_rcfile_emails4 SELECT * FROM tmp_csv_emails4;