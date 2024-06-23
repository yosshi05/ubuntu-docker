FROM ubuntu

# RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

# package
RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

RUN for iter in 1 2 3 4 5 6 7 8 9 10; do \
      apt-get update && \
      exit_code=0 && break || \
        exit_code=$? && echo "apt-get error: retry $iter in 10s" && sleep 10; \
    done; \
    exit $exit_code

RUN apt-get install -y \
        # ansible \
        curl \
        dnsutils \
        iputils-ping \
        less \
        net-tools \
        # openjdk-11-jdk \
        openssh-server \
        software-properties-common \
        sshpass \
        sudo \
        tree \
        vim \
        zip

# RUN add-apt-repository -y ppa:ethereum/ethereum
# RUN apt-get install -y ethereum

RUN apt-get clean all

# ssh
RUN mkdir /var/run/sshd
RUN echo 'root:pass' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]