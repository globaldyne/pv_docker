# =============================================================================
#
# JB's Vault
# 
# =============================================================================
FROM quay.io/centos/centos:stream9

LABEL co.uk.globaldyne.component="perfumers-vault-container"  description="Perfumers Vault container image"  summary="Perfumers Vault container image Version v6.0-okd"  version="v6.0-okd"  io.k8s.description="Init Container for JBs Perfumers Vault v6.0-okd"  io.k8s.display-name="Perfumers Vault v6.0-okd Init Container"  io.openshift.tags="pvault,jb,perfumer,vault,jbpvault,v6.0-okd"  name="globaldyne/pvault"  maintainer="John Belekios"

ARG git_repo=master
ARG uid=100001
ArG gid=100001

RUN dnf install -y epel-release
RUN dnf -y update 

RUN dnf --setopt=tsflags=nodocs -y install \
	httpd \
	php \
	php-cli \
	php-xml \
	php-mysqlnd \
	php-gd \
	mariadb-server \
	php-mbstring \
	git \
	python3-pip \
	procps \
	openssl \
	bc \
	&& dnf clean all

RUN dnf install make php-devel php-pear ImageMagick ImageMagick-devel pcre-devel -y
RUN pecl channel-update pecl.php.net
RUN printf "\n" | pecl install imagick
RUN dnf remove ImageMagick-devel php-devel make -y
RUN dnf clean packages -y
RUN echo "extension=imagick.so" > /etc/php.d/40-ImageMagick.ini

RUN python3 -m pip install --upgrade pip \
	&& python3 -m pip install --no-warn-script-location --upgrade brother_ql

RUN dnf update && dnf clean all && rm -rf /var/cache/yum/*

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime \
	&& echo "NETWORKING=yes" > /etc/sysconfig/network

RUN sed -i \
	-e 's~^;date.timezone =$~date.timezone = UTC~g' \
	-e 's~^upload_max_filesize.*$~upload_max_filesize = 80M~g' \
	-e 's~^post_max_size.*$~post_max_size = 120M~g' \
	-e 's~^session.auto_start.*$~session.auto_start = 1~g' \
	/etc/php.ini

ENV LANG en_GB.UTF-8

ADD https://api.github.com/repos/globaldyne/parfumvault/git/refs/heads/${git_repo} version.json
RUN git clone -b ${git_repo} https://github.com/globaldyne/parfumvault.git /html
RUN mkdir /html/tmp
RUN chown -R ${uid}.${gid} /html
ADD start.sh /start.sh
ADD pvdb.sh /usr/bin/pvdb.sh

WORKDIR /html

USER ${uid}
EXPOSE 8000
VOLUME ["/html/uploads", "/config"]
CMD ["/bin/bash", "/start.sh"]
