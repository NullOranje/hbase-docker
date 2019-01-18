#!/bin/bash

# Set some sensible defaults
export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/_/g; s/_/./g'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $HBASE_PREFIX/conf/$module-site.xml $name "$value"
    done
}

echo "Configuring modules in ${HBASE_HOME}"
configure $HBASE_PREFIX/conf/hbase-site.xml hbase HBASE_CONF

exec $@

# prop_replace 'hbase.rootdir'                               '${HBASE_ROOT_DIR:-hdfs://localhost:8020/hbase}'
# prop_replace 'hbase.unsafe.stream.capability.enforce'      '${HBASE_UNSAFE_STREAM:-false}'
# prop_replace 'hbase.cluster.distributed'                   '${HBASE_DISTRIBUTED:-true}'
# prop_replace 'hbase.local.dir'                             '${HBASE_DATA_DIR:-/opt/hbase/data}'
# prop_replace 'hbase.master.port'                           '${HBASE_MASTER_PORT}:-16000}'
# prop_replace 'hbase.zookeeper.quorum'                      '${HBASE_ZK_QUORUM:-localhost}'
