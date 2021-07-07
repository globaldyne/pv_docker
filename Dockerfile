# =============================================================================
#
# JB's Vault
# 
# =============================================================================
FROM quay.io/centos/centos:centos8
MAINTAINER JB <john@globaldyne.co.uk>

ARG git_repo=master

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
	&& dnf clean all

RUN python3 -m pip install --upgrade pip \
	&& python3 -m pip install --no-warn-script-location --upgrade brother_ql

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
RUN git clone -b ${git_repo} https://github.com/globaldyne/parfumvault.git /var/www/html

ADD start.sh /start.sh

USER 10001
EXPOSE 8000
VOLUME ["/var/www/html/uploads", "/config"]
CMD ["/bin/bash", "/start.sh"]
