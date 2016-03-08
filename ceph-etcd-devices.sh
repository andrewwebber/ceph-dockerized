#!/bin/bash
# Devices with the value 'done' are skipped during disk creation in ceph-osd-batch-disk.service

# Fill devices array with the device names you want to add to ceph, e.g. sdb
source /etc/profile.d/etcdctl.sh;
source /etc/network-environment;
dc=$(fleetctl list-machines -l | grep ${DEFAULT_IPV4} | awk -F',' '$2 ~ /dc=/ {print $2}; $3 ~ /dc=/ {print $3}' | cut -c 4)
echo "Current data center = $dc"
etcd_endpoint=$(etcdctl get brainloop/ceph/cluster-ip/$dc); \
echo "Current data center etcd endpoint = $etcd_endpoint"

devices=$(ETCDCTL_PEERS=$etcd_endpoint:1974 etcdctl get brainloop-ceph/osd/devices)
echo "Will configure the following devices [$devices]"

echo -e "Writing devices into etcd: \n"
if [[ `ETCDCTL_PEERS=$etcd_endpoint:1974 etcdctl get brainloop-ceph/osd/init/$(cat /etc/machine-id)` == "done" ]]; then
  echo "Skipping, already done init"
  exit 0;
fi

for i in ${devices[@]}; do
  ETCDCTL_PEERS=$etcd_endpoint:1974 etcdctl set brainloop-ceph/osd/$(cat /etc/machine-id)/dev/$i $i
done

ETCDCTL_PEERS=$etcd_endpoint:1974 etcdctl set brainloop-ceph/osd/init/$(cat /etc/machine-id) "done"
