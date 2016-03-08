#!/bin/bash
source /etc/profile.d/etcdctl.sh;
dc=$(fleetctl list-machines -l | grep ${DEFAULT_IPV4} | awk -F',' '$2 ~ /dc=/ {print $2}; $3 ~ /dc=/ {print $3}' | cut -c 4)
echo "Current data center = $dc"
etcd_endpoint=$(etcdctl get brainloop/ceph/cluster-ip/$dc); \
echo "Current data center etcd endpoint = $etcd_endpoint"

docker run --name ceph-osd --net=host  --privileged=true --ulimit nofile=40960:40960 --ulimit core=100000000:100000000 --ulimit memlock=200000000:200000000 -v /etc/ceph:/etc/ceph  -v /var/lib/ceph/:/var/lib/ceph/  -v /dev/:/dev/  $(/home/core/ceph/ceph-bind-mounts.sh)  -e HOSTNAME=$(cat /etc/machine-id)  -e CEPH_PUBLIC_NETWORK=$(ETCDCTL_PEERS=http://$etcd_endpoint:1974 etcdctl get ceph-config/ceph/osd/public_network)  -e KV_TYPE=etcd  -e KV_IP=$etcd_endpoint  -e KV_PORT=1974  brainloop/ceph osd
