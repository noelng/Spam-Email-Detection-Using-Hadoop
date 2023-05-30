CREATE EXTERNAL TABLE emails_parquet (id STRING, label STRING, text STRING)
    STORED AS PARQUET
    LOCATION '/group-project/source/PARQUET';

CREATE TABLE emails_5 (id STRING, label STRING, text STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/group-project/stage-1/PARQUET-TO-CSV';

INSERT INTO emails_5 SELECT * FROM emails_parquet;