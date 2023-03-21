set -x

BASE_DIR=$(dirname $(readlink -f "${BASH_SOURCE:-$0}"))
LIBRARY_DIR=$BASE_DIR/Resource/Installer

# Install packages
sudo apt-get install -y maven \
    && sudo apt-get install -y subversion \
    && sudo apt-get install -y curl \

# (1) Hive JSON SerDe library
# Note: This script assumes that Hive is installed in /home/WQD7007
if [ ! -d ~/Hive-JSON-Serde-1.3.8 ]; then
    cd ~ \
        && rm -rf Hive* \
        && cp -rpf $LIBRARY_DIR/Hive-JSON-Serde-1.3.8.tar.gz . \
        && tar -zxf Hive-JSON-Serde-1.3.8.tar.gz \
        && cd Hive-JSON-Serde-1.3.8 \
        && mvn package \
        && cp -f json-serde/target/json-serde-1.3.8-jar-with-dependencies.jar /home/WQD7007/hive/lib/ \
        && cp -f json-serde/target/json-serde-1.3.8-jar-with-dependencies.jar /home/WQD7007/hive2/lib/
fi;


# (2) Pig 0.17.0
# Note: This script assumes that the home directory is /home/student
if [ ! -d ~/pig ]; then
    cd ~ \
        && rm -rf pig* \
        && cp -rpf $LIBRARY_DIR/pig-0.17.0.tar.gz . \
        && tar -zxf pig-0.17.0.tar.gz \
        && mv pig-0.17.0 pig \
        && sed -i 's/\/home\/WQD7007\/pig\/bin/\/home\/student\/pig\/bin/g' ~/.bashrc
fi;

# (3) Mahout 1.0-SNAPSHOT
# Note: This script assumes that the home directory is /home/student
# Note: This script assumes that Hadoop is installed in /home/WQD7007
if [ ! -d ~/mahout ]; then
    cd ~ \
        && rm -rf mahout* \
        && mkdir mahout \
        && cd mahout \
        && svn co http://svn.apache.org/repos/asf/mahout/trunk \
        && cd trunk \
        && mvn -DskipTests=true -Dhadoop2.version=2.7.7
    
    [ -z "$(cat ~/.bashrc | grep 'export PATH=$PATH:/home/student/mahout/trunk/bin')" ] && echo 'export PATH=$PATH:/home/student/mahout/trunk/bin' >> ~/.bashrc
    [ -z "$(cat ~/.bashrc | grep 'export HADOOP_CONF_DIR=/home/WQD7007/hadoop/etc/hadoop')" ] && echo 'export HADOOP_CONF_DIR=/home/WQD7007/hadoop/etc/hadoop' >> ~/.bashrc
fi;

# Restart the VM for the configurations to take effect