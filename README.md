# Spam-Email-Detection-Using-Hadoop

Prerequisite:
(1) Run "0-Setup.sh".
(2) Restart the Virtual Machine running ubuntu for the changes to take effect.

Modelling steps:

## Step 1: Data Collection

Run "1-Hive.sh".

Expected output:

    Email data in different formats are extracted and output as CSV.

    Input and output tables in Hive:
        JSON    --> emails_json, emails_0
        XML     --> emails_xml, emails_1
        CSV     --> emails_csv, emails_2
        AVRO    --> emails_avro, emails_3
        RCFILE  --> emails_rcfile, emails_4
        PARQUET --> emails_parquet, emails_5

    Physical file output in HDFS:
        JSON    --> /project/stage-1/JSON-TO-CSV/000000_0 (999 rows)
        XML     --> /project/stage-1/XML-TO-CSV/000000_0 (1,000 rows)
        CSV     --> /project/stage-1/CSV-TO-CSV/000000_0 (1,000 rows + 1 header)
        AVRO    --> /project/stage-1/AVRO-TO-CSV/000000_0 (1,000 rows + 1 header)
        RCFILE  --> /project/stage-1/RCFILE-TO-CSV/000000_0 (1,000 rows + 1 header)
        PARQUET --> /project/stage-1/PARQUET-TO-CSV/000000_0 (173 rows + 1 header)
        Note: The "000000_0" is actually a CSV file.

## Step 2: Data Integration

Run "2-HBase.sh".

Expected output:

    Staging table in HBase:
        emails
        --> 5,173 rows during initial load (5,172 rows + 1 header)
        --> 5,172 rows after removing header

## Step 3: Data Cleaning

Run "3-Pig.sh".

Expected output:

    Physical file output in HDFS
        /group-project/stage-3/output-sorted/spam/* (1,500 files)
        /group-project/stage-3/output-sorted/ham/* (3,672 files)

## Step 4: Data Modelling

Run "4-Mahout.sh".
