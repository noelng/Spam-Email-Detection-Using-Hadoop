-- Load email data directly from the HBase table
emails = LOAD 'hbase://emails' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('cf:label cf:text', '-loadKey true') AS (id:chararray, label:chararray, text:chararray);

-- Load stopwords (source: https://github.com/stopwords-iso/stopwords-en)
stopwords = LOAD '/group-project/stage-3/stopwords.csv' USING PigStorage(',') AS (word:chararray);

-- (Step 1) Convert text to lower case, tokenize, and flatten out the text
-- (Example) "Testing 1 2 3" (one row) ---> "testing", "1", "2", "3" (four rows)
-- Expecting 855,586 records after Step 1
emails_s1 = FOREACH emails GENERATE id, label, FLATTEN(TOKENIZE(LOWER(text))) AS text;

-- (Step 2) Remove stopwords
-- Expecting 476,076 records after Step 2 (a.k.a. removed 379,510 stopwords)
emails_s2a = JOIN emails_s1 BY text LEFT OUTER, stopwords BY word USING 'replicated';
emails_s2b = FILTER emails_s2a BY word IS NULL;
emails_s2 = FOREACH emails_s2b GENERATE id, label, text;

-- Export data
-- File key: <label>/<id>
-- Records with the same file key will be written in the same file
STORE emails_s2 INTO '/group-project/stage-3/output' USING org.apache.pig.piggybank.storage.MultiStorage('/group-project/stage-3/output', '1,0', 'none', ' ', 'TRUE');