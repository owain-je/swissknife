FROM centos:7 
ENV HELM_VERSION=v2.8.1
ENV KUBECTL_VERSION=1.8.1
RUN yum update -y
RUN yum install -y epel-release 
RUN yum update -y && \
    yum install -y libyaml-devel readline-devel zlib-devel libffi-devel openssl-devel telnet vim git curl wget which nmap bind-utils net-tools python-pip python-devel gpg htop grep procps-ng unzip

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    mv /kubectl /usr/local/bin/kubectl && \
    wget https://github.com/kubernetes/kops/releases/download/$KUBECTL_VERSION/kops-linux-amd64 && \
    chmod +x kops-linux-amd64 && \
    chmod 755 /usr/local/bin/kubectl && \
    mv kops-linux-amd64 /usr/local/bin/kops

RUN yum install -y bash-completion 

RUN wget https://kubernetes-helm.storage.googleapis.com/helm-$HELM_VERSION-linux-amd64.tar.gz && \
    tar -zxvf helm-$HELM_VERSION-linux-amd64.tar.gz && \
    mv  linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 && \
    rm -f helm-$HELM_VERSION-linux-amd64.tar.gz

RUN pip install --upgrade pip && \
    pip install awscli --upgrade && \
    ln -s  /root/.local/bin/aws /usr/local/bin && \
    complete -C '/usr/bin/aws_completer' aws

RUN wget https://releases.hashicorp.com/vault/0.10.0/vault_0.10.0_linux_amd64.zip && \
    unzip vault_0.10.0_linux_amd64.zip && \
    mv vault /usr/local/bin && \
    chmod +x /usr/local/bin/vault && \
    rm vault_0.10.0_linux_amd64.zip

COPY entrypoint.sh /entrypoint.sh 
RUN chmod 755 /entrypoint.sh 
ENTRYPOINT /entrypoint.sh

