FROM fedora:latest

RUN yum install unzip wget python-dateutil -y
RUN wget -N -P /tmp https://github.com/s3tools/s3cmd/archive/master.zip
RUN unzip /tmp/master.zip -d /tmp/s3cmd
RUN mkdir -p /opt/s3cmd
ADD config.txt /opt/s3cmd/config.txt
RUN chmod +x /tmp/s3cmd/s3cmd-master/s3cmd

CMD ["/tmp/s3cmd/s3cmd-master/s3cmd", "-c", "/opt/s3cmd/config.txt", "mb", "s3://DEFAULT"]
