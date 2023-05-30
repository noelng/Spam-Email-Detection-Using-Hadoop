add jar /home/WQD7007/hive/lib/json-serde-1.3.8-jar-with-dependencies.jar;
add jar /home/WQD7007/hive2/lib/json-serde-1.3.8-jar-with-dependencies.jar;

CREATE EXTERNAL TABLE emails_json (id STRING, label STRING, text STRING)
    ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
    LOCATION '/group-project/source/JSON';

CREATE TABLE emails_0 (id STRING, label STRING, text STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/group-project/stage-1/JSON-TO-CSV';

INSERT INTO emails_0 SELECT * FROM emails_json;