# Spam-Email-Detection-Using-Hadoop

Data Analytics Workflow: 

![Workflow](https://user-images.githubusercontent.com/73273980/226546606-ebb8fc03-61b4-499a-aa2f-a9bda67fb2df.png)

Prerequisite:

(1) Run "0-Setup.sh".

(2) Restart the Virtual Machine running ubuntu for the changes to take effect.

Modelling steps:

## Step 1: Data Collection

---------------------------------------------------------------------------------------------------

The Enron-Spam dataset was used in this project. It was first converted into different 
data formats outside of the data analytics workflow using Python script to simulate the “variety” 
dimension of big data. The data formats supported in this project are .csv, .json, .xml, .avro, 
.parquet and .rcfile. In summary, Hive was used to read the email data in different formats and 
convert them into the CSV format. A total of six CSV files were produced at the end of this stage.

---------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------

HBase was used to read and store all six CSV files in the “emails” table. Subsequently, 
the CSV header row creating during consolidation was removed from the table to prepare for 
direct data loading using Pig. No data export is required in this stage.

---------------------------------------------------------------------------------------------------

Run "2-HBase.sh".

Expected output:

    Staging table in HBase:
        emails
        --> 5,173 rows during initial load (5,172 rows + 1 header)
        --> 5,172 rows after removing header

## Step 3: Data Cleaning

---------------------------------------------------------------------------------------------------

Pig was used mainly for text cleaning in the workflow. Firstly, the “emails” table was 
loaded directly from HBase using the HBaseStorage API. Then, the email text was converted 
into lower case, and text tokenization was performed. After that, the stop words were identified 
using the stopwords-en corpus library, and they were removed from the tokenized email text. 
Lastly, the clean processed email data was exported using the MultiStorage API

---------------------------------------------------------------------------------------------------

Run "3-Pig.sh".

Expected output:

    Physical file output in HDFS
        /group-project/stage-3/output-sorted/spam/* (1,500 files)
        /group-project/stage-3/output-sorted/ham/* (3,672 files)

## Step 4: Data Modelling

---------------------------------------------------------------------------------------------------

Mahout was selected to execute the common data science techniques in the workflow. 
Firstly, the clean processed email data was converted into the SEQUENCEFILE format, which 
is a flat, binary data format that is typically used in Mahout. Next, the TF-IDF
numerical analysis was applied to assess the importance of each word as a whole. After that, 
the resultant word vectors were split into training set and testing set in the ratio of 70:30. 
Lastly, a Naïve Bayes model was built using the training set, and the model performance was 
evaluated using the testing set.

---------------------------------------------------------------------------------------------------

Run "4-Mahout.sh".
