set -x

BASE_DIR=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))
DATA_DIR=$BASE_DIR/Resource/DataSource
HIVE_SCRIPT_DIR=$BASE_DIR/Resource/1-Hive

# Initialize
hive -f $HIVE_SCRIPT_DIR/Setup.sql

hdfs dfs -mkdir -p /group-project/source/ /group-project/stage-1/ \
    && hdfs dfs -rm -R -f /group-project/source/* /group-project/stage-1/* \
    && hdfs dfs -put $DATA_DIR/JSON /group-project/source/ \
    && hdfs dfs -put $DATA_DIR/XML /group-project/source/ \
    && hdfs dfs -mkdir -p /group-project/source/CSV \
    && hdfs dfs -put $DATA_DIR/CSV/emails-2.csv /group-project/source/CSV/ \
    && hdfs dfs -put $DATA_DIR/AVRO /group-project/source/ \
    && hdfs dfs -put $DATA_DIR/RCFILE /group-project/source/ \
    && hdfs dfs -put $DATA_DIR/PARQUET /group-project/source/

# Import data
hive -f $HIVE_SCRIPT_DIR/JSON.sql \
    && hive -f $HIVE_SCRIPT_DIR/XML.sql \
    && hive -f $HIVE_SCRIPT_DIR/CSV.sql \
    && hive -f $HIVE_SCRIPT_DIR/AVRO.sql \
    && hive -f $HIVE_SCRIPT_DIR/RCFILE.sql \
    && hive -f $HIVE_SCRIPT_DIR/PARQUET.sql