set -x

SCRIPT_DIR=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))

hive -f $SCRIPT_DIR/SetupInHive.sql

hdfs dfs -rm -R -f /group-project/temp \
    && hdfs dfs -mkdir -p /group-project/temp/emails-3-csv/ \
    && hdfs dfs -mkdir -p /group-project/temp/emails-4-csv/ \
    && hdfs dfs -put $SCRIPT_DIR/CSV/emails-3.csv /group-project/temp/emails-3-csv/ \
    && hdfs dfs -put $SCRIPT_DIR/CSV/emails-4.csv /group-project/temp/emails-4-csv/

hive -f $SCRIPT_DIR/TransformToAVRO.sql
hive -f $SCRIPT_DIR/TransformToRCFILE.sql

rm -rf $SCRIPT_DIR/AVRO $SCRIPT_DIR/RCFILE \
    && mkdir -p $SCRIPT_DIR/AVRO $SCRIPT_DIR/RCFILE \
    && hdfs dfs -get /group-project/temp/emails-3-avro/000000_0 $SCRIPT_DIR/AVRO/emails-3.avro \
    && hdfs dfs -get /group-project/temp/emails-4-rcfile/000000_0 $SCRIPT_DIR/RCFILE/emails-4.rcfile