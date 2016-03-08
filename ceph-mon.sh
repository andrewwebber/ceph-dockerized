#!/bin/bash
source /etc/profile.d/etcdctl.sh;
dc=$(fleetctl list-machines -l | grep ${DEFAULT_IPV4} | awk -F',' '$2 ~ /dc=/ {print $2}; $3 ~ /dc=/ {print $3}' | cut -c 4)
echo "Current data center = $dc"
etcd_endpoint=$(etcdctl get brainloop/ceph/cluster-ip/$dc); \
echo "Current data center etcd endpoint = $etcd_endpoint"

export ETCDCTL_PEERS=$etcd_endpoint:1974 && /usr/bin/docker run --name ceph-mon --net=host  -v /etc/ceph/:/etc/ceph/  -v /var/lib/ceph/:/var/lib/ceph/  -e MON_IP=${DEFAULT_IPV4}  -e MON_NAME=$(cat /etc/machine-id)  -e HOSTNAME=$(cat /etc/machine-id)  -e CEPH_PUBLIC_NETWORK=$(ETCDCTL_PEERS=$etcd_endpoint:1974 etcdctl get ceph-config/ceph/osd/public_network)  -e KV_TYPE=etcd  -e KV_IP=$etcd_endpoint -e KV_PORT=1974 brainloop/ceph mon
