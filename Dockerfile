FROM ubuntu:22.04

USER root
WORKDIR /root


RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    iproute2 \
    iputils-ping \
    mininet \
    net-tools \
    openvswitch-switch \
    openvswitch-testcontroller \
    tcpdump \
    vim \
    x11-xserver-utils \
    xterm \
    openssh-server \
    python-pip \
    git \
    wget \
    iperf \
 && rm -rf /var/lib/apt/lists/* 

COPY ENTRYPOINT.sh /
RUN chmod +x /ENTRYPOINT.sh

RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN echo 'root:root' | chpasswd
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


EXPOSE 22 9999 7777
EXPOSE 6633 6653 6640

ENTRYPOINT ["/ENTRYPOINT.sh"]
CMD bash
