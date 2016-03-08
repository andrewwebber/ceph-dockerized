gpg --verify --trusted-key 1FA7BD0D14938422 /opt/packageserver/ceph-s3.container.tar.gz.sig
docker load -i /opt/packageserver/ceph-s3.container.tar.gz
docker run --rm -it --add-host s3.amazonaws.com:10.10.2.102 brainloop/ceph-s3
docker run --rm -it --add-host s3.amazonaws.com:10.10.2.107 brainloop/ceph-s3
