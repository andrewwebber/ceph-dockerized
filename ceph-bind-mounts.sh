#!/bin/bash

ceph_root="/var/lib/ceph/osd"
bindMounts=""

for i in $(ls $ceph_root |  awk 'BEGIN { FS = "-" } ; { print $2 }')
do
  if [[ ! -n "$(find $ceph_root/ceph-$i -prune -empty)" && -e $(awk '{print $2}' /proc/mounts | grep "ceph-$i")  ]]
  then
    bindMounts+="-v $ceph_root/ceph-$i:$ceph_root/ceph-$i "

  fi
done

echo $bindMounts
