CREATE EXTERNAL TABLE emails_avro (id STRING, label STRING, text STRING)
    STORED AS AVRO
    LOCATION '/group-project/source/AVRO';

CREATE TABLE emails_3 (id STRING, label STRING, text STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/group-project/stage-1/AVRO-TO-CSV';

INSERT INTO emails_3 SELECT * FROM emails_avro;