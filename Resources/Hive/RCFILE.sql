CREATE EXTERNAL TABLE emails_rcfile (id STRING, label STRING, text STRING)
    STORED AS RCFILE
    LOCATION '/group-project/source/RCFILE';

CREATE TABLE emails_4 (id STRING, label STRING, text STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/group-project/stage-1/RCFILE-TO-CSV';

INSERT INTO emails_4 SELECT * FROM emails_rcfile;