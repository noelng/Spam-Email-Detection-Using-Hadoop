set -x

BASE_DIR=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))
HBASE_SCRIPT_DIR=$BASE_DIR/Resource/2-HBase

hadoop fs -rm -R -f /group-project/stage-2

# Initialize
hbase shell $HBASE_SCRIPT_DIR/Setup.txt

# Load data
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="," -Dimporttsv.columns="HBASE_ROW_KEY,cf:label,cf:text" emails /group-project/stage-1/JSON-TO-CSV/000000_0
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="," -Dimporttsv.columns="HBASE_ROW_KEY,cf:label,cf:text" emails /group-project/stage-1/XML-TO-CSV/000000_0
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="," -Dimporttsv.columns="HBASE_ROW_KEY,cf:label,cf:text" emails /group-project/stage-1/CSV-TO-CSV/000000_0
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="," -Dimporttsv.columns="HBASE_ROW_KEY,cf:label,cf:text" emails /group-project/stage-1/AVRO-TO-CSV/000000_0
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="," -Dimporttsv.columns="HBASE_ROW_KEY,cf:label,cf:text" emails /group-project/stage-1/RCFILE-TO-CSV/000000_0
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="," -Dimporttsv.columns="HBASE_ROW_KEY,cf:label,cf:text" emails /group-project/stage-1/PARQUET-TO-CSV/000000_0

# Remove header
hbase shell $HBASE_SCRIPT_DIR/Cleaning.txt