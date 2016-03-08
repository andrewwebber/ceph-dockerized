#!/bin/bash
source /etc/profile.d/etcdctl.sh;
dc=$(fleetctl list-machines -l | grep ${DEFAULT_IPV4} | awk -F',' '$2 ~ /dc=/ {print $2}; $3 ~ /dc=/ {print $3}' | cut -c 4)
echo "Current data center = $dc"
etcd_endpoint=$(etcdctl get brainloop/ceph/cluster-ip/$dc); \
echo "Current data center etcd endpoint = $etcd_endpoint"

docker run --name ceph-rgw --net=host  -v /var/lib/ceph/:/var/lib/ceph/  -v /etc/ceph:/etc/ceph  -e RGW_CIVETWEB_PORT=7070  -e RGW_NAME=$(cat /etc/machine-id)  -e KV_TYPE=etcd  -e KV_IP=$etcd_endpoint  -e KV_PORT=1974  brainloop/ceph rgw
