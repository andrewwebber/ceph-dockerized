## Note: The 'while' loops below pause between pools to allow all
##       PGs to be created.  This is a safety mechanism to prevent
##       saturating the Monitor nodes.
## -------------------------------------------------------------------

ceph osd pool create .intent-log 64
ceph osd pool set .intent-log size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .log 64
ceph osd pool set .log size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .rgw 64
ceph osd pool set .rgw size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .rgw.buckets 16384
ceph osd pool set .rgw.buckets size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .rgw.buckets.extra 128
ceph osd pool set .rgw.buckets.extra size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .rgw.buckets.index 128
ceph osd pool set .rgw.buckets.index size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .rgw.control 64
ceph osd pool set .rgw.control size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .rgw.gc 64
ceph osd pool set .rgw.gc size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .rgw.root 64
ceph osd pool set .rgw.root size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .usage 64
ceph osd pool set .usage size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .users 64
ceph osd pool set .users size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done

ceph osd pool create .users.uid 64
ceph osd pool set .users.uid size 2
while [ $(ceph -s | grep creating -c) -gt 0 ]; do echo -n .;sleep 1; done
