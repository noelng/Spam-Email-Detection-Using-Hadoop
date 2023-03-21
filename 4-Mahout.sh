set -x

BASE_DIR=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))
INPUT_DIR=/group-project/stage-3/output-sorted
WORK_DIR=/group-project/model

hdfs dfs -mkdir -p /group-project/model/ \
    && hdfs dfs -rm -R -f /group-project/model/*

# Generate SEQUENCEFILE based on the input dataset
mahout seqdirectory -i $INPUT_DIR -o $WORK_DIR/1-sequences -xm sequential

# Run TF-IDF
mahout seq2sparse -i $WORK_DIR/1-sequences -o $WORK_DIR/2-vectors -lnorm -nv -wt tfidf

# Perform train-test split (70% for training, 30% for testing)
mahout split -i $WORK_DIR/2-vectors/tfidf-vectors \
    --trainingOutput $WORK_DIR/3-vectors-train --testOutput $WORK_DIR/3-vectors-test \
    --randomSelectionPct 30 --overwrite --sequenceFiles -xm sequential

# Build Naive Bayes model
mahout trainnb -i $WORK_DIR/3-vectors-train -el -o $WORK_DIR/4-model -li $WORK_DIR/4-model-label -ow -c

# Test Naive Bayes model
mahout testnb -i $WORK_DIR/3-vectors-test -m $WORK_DIR/4-model -l $WORK_DIR/4-model-label -ow -o $WORK_DIR/5-test-result -c