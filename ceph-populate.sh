#!/bin/bash
#populate the KV store with ceph.conf parameters
set -x

etcdctl set brainloop/ceph/cluster-ip/1 10.10.2.102
etcdctl set brainloop/ceph/cluster-ip/2 10.10.2.107

./ceph-populate-etcd.sh 10.10.2.102
./ceph-populate-etcd.sh 10.10.2.107
