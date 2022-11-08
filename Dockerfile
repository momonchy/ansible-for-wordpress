FROM amazonlinux:2

RUN amazon-linux-extras enable ansible2
RUN yum clean metadata \
    && yum update -y \
    && yum install systemd-sysv ansible git -y

CMD ["/sbin/init"]
