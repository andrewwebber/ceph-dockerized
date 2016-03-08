#!/bin/bash
#populate the KV store with ceph.conf parameters
set -x

CLUSTER="ceph"
KV="etcd"
IP=$1
PORT="1974"
CLUSTER_PATH=ceph-config/${CLUSTER}

# auth
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/auth/cephx true
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/auth/cephx_require_signatures true
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/auth/cephx_cluster_require_signatures true
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/auth/cephx_service_require_signatures true

# auth
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/global/max_open_files 131072
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/global/osd_pool_default_pg_num 128
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/global/osd_pool_default_pgp_num 128
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/global/osd_pool_default_size 2
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/global/osd_pool_default_min_size 1

ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/global/mon_osd_full_ratio .80
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/global/mon_osd_nearfull_ratio .70

#mon
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/mon/mon_osd_down_out_interval 600
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/mon/mon_osd_min_down_reporters 4
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/mon/mon_clock_drift_allowed .15
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/mon/mon_clock_drift_warn_backoff 30
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/mon/mon_osd_report_timeout 300

#osd
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_journal_size 100
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/cluster_network 10.10.2.0/16
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/public_network 10.10.2.0/16
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_mkfs_type xfs
curl http://${IP}:${PORT}/v2/keys/${CLUSTER_PATH}/osd/osd_mkfs_options_xfs -XPUT -d value="-f -i size=2048"
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_mon_heartbeat_interval 30

#crush
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/pool_default_crush_rule 0
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_crush_update_on_start true

#backend
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_objectstore filestore

#performance tuning
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/filestore_merge_threshold 40
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/filestore_split_multiple 8
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_op_threads 8
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/filestore_op_threads 8
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/filestore_max_sync_interval 5
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_max_scrubs 1

#recovery tuning
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_recovery_max_active 5
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_max_backfills 2
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_recovery_op_priority 2
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_client_op_priority 63
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_recovery_max_chunk 1048576
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/osd_recovery_threads 1

#ports
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/ms_bind_port_min 6800
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/osd/ms_bind_port_max 7100

#client
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/client/rbd_cache_enabled true
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/client/rbd_cache_writethrough_until_flush true

#mds
ETCDCTL_PEERS=http://${IP}:${PORT} etcdctl set ${CLUSTER_PATH}/mds/mds_cache_size 100000
