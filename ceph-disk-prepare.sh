#!/bin/bash
source /etc/profile.d/etcdctl.sh;
source /etc/network-environment;
dc=$(fleetctl list-machines -l | grep ${DEFAULT_IPV4} | awk -F',' '$2 ~ /dc=/ {print $2}; $3 ~ /dc=/ {print $3}' | cut -c 4)
echo "Current data center = $dc"
etcd_endpoint=$(etcdctl get brainloop/ceph/cluster-ip/$dc); \
echo "Current data center etcd endpoint = $etcd_endpoint"

for i in $(ETCDCTL_PEERS=http://$etcd_endpoint:1974 etcdctl ls brainloop-ceph/osd/$(cat /etc/machine-id)/dev/$1); do
  echo $i;
  if [[ $(ETCDCTL_PEERS=http://$etcd_endpoint:1974 etcdctl get $i) != "done" ]]; then
    DEVICE=$(ETCDCTL_PEERS=http://$etcd_endpoint:1974 etcdctl get $i)
    (docker run  --name=ceph-disk-$DEVICE --net=host \
    --privileged=true \
    -v /etc/ceph:/etc/ceph \
    -v /var/lib/ceph/:/var/lib/ceph/ \
    -v /dev/:/dev/ \
    -e OSD_DEVICE=/dev/$DEVICE \
    -e OSD_FORCE_ZAP=1 \
    -e HOSTNAME=$(cat /etc/machine-id) \
    -e KV_TYPE=etcd \
    -e KV_IP=$etcd_endpoint \
    -e KV_PORT=1974 \
    brainloop/ceph osd_ceph_disk &) ;
    sleep 30 ;
    ETCDCTL_PEERS=http://$etcd_endpoint:1974 etcdctl set $i 'done';
    docker kill ceph-disk-$DEVICE ;
  fi;
done
