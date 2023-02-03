# =============================================================================
#
# JB's Vault
# 
# =============================================================================
FROM --platform=linux/x86_64 quay.io/centos/centos:stream8

##LABELS

ARG git_repo=master
ARG uid=100001
ArG gid=100001

RUN dnf -y install epel-release
RUN dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm

RUN  dnf -y update 

RUN dnf -y module enable php:remi-7.4 
RUN dnf --setopt=tsflags=nodocs -y install \
	php \
	php-cli \
	php-xml \
	php-mysql \
	php-gd \
	php-mbstring \
	git \
	python3-pip \
	mysql 

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

WORKDIR /html

USER ${uid}
EXPOSE 8000
VOLUME ["/html/uploads", "/config"]
CMD ["/bin/bash", "/start.sh"]
