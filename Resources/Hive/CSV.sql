CREATE EXTERNAL TABLE emails_csv (id STRING, label STRING, text STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    LOCATION '/group-project/source/CSV';

CREATE TABLE emails_2 (id STRING, label STRING, text STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/group-project/stage-1/CSV-TO-CSV';

INSERT INTO emails_2 SELECT * FROM emails_csv;