set -x

BASE_DIR=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))
PIG_SCRIPT_DIR=$BASE_DIR/Resource/3-Pig

hdfs dfs -mkdir -p /group-project/stage-3/ \
    && hdfs dfs -rm -R -f /group-project/stage-3/* \
    && hdfs dfs -put $PIG_SCRIPT_DIR/stopwords.csv /group-project/stage-3

pig $PIG_SCRIPT_DIR/Script.pig

TMP_FOLDER=tmp-stage-3
rm -rf $TMP_FOLDER \
    && mkdir -p $TMP_FOLDER $TMP_FOLDER/sorted/spam $TMP_FOLDER/sorted/ham \
    && hdfs dfs -get /group-project/stage-3/output/ $TMP_FOLDER \
    && find $TMP_FOLDER/output/ham -name *-0,000 -exec cp '{}' $TMP_FOLDER/sorted/ham/ \; \
    && find $TMP_FOLDER/output/spam -name *-0,000 -exec cp '{}' $TMP_FOLDER/sorted/spam/ \; \
    && hdfs dfs -mkdir /group-project/stage-3/output-sorted \
    && hdfs dfs -put $TMP_FOLDER/sorted/spam /group-project/stage-3/output-sorted/ \
    && hdfs dfs -put $TMP_FOLDER/sorted/ham /group-project/stage-3/output-sorted/