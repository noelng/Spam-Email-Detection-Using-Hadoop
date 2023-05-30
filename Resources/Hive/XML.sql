CREATE EXTERNAL TABLE emails_xml (xml STRING)
    LOCATION '/group-project/source/XML';

CREATE TABLE emails_1 (id STRING, label STRING, text STRING)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/group-project/stage-1/XML-TO-CSV';

INSERT INTO emails_1
    SELECT
        XPATH_STRING(xml, 'body/id') AS id,
        XPATH_STRING(xml, 'body/label') AS label,
        XPATH_STRING(xml, 'body/text') AS text
    FROM emails_xml;