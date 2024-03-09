# =============================================================================
#
# phpMyAdmin for OKD Dockerfile
#
# =============================================================================
FROM quay.io/centos/centos:stream9

LABEL co.uk.globaldyne.component="OKD"  description="phpMyAdmin container image"  summary="phpMyAdmin container image"  version="CLOUD"  io.k8s.description="Init Container for phpMyAdmin"  io.k8s.display-name="phpMyAdmin Container"  io.openshift.tags="phpMyAdmin,openshift"  name="globaldyne/phpMyAdmin"  maintainer="John Belekios"

ARG uid=100001
ARG gid=100001

RUN dnf -y update

RUN dnf --setopt=tsflags=nodocs -y install \
	php \
	php-mysqlnd \
	php-mbstring \
	php-fpm \
	phpMyAdmin \
	mysql \
	nginx



RUN dnf clean all && rm -rf /var/cache/yum/*

RUN sed -i \
	-e 's~^;date.timezone =$~date.timezone = UTC~g' \
	-e 's~^upload_max_filesize.*$~upload_max_filesize = 400M~g' \
	-e 's~^post_max_size.*$~post_max_size = 400M~g' \
	-e 's~^session.auto_start.*$~session.auto_start = 1~g' \
	/etc/php.ini

ENV LANG en_GB.UTF-8
ADD html /html
RUN sed -i "s/ 'localhost'/ getenv(\"DB_HOST\")/g" /etc/phpMyAdmin/config.inc.php
RUN echo "\$cfg['TempDir'] = '/tmp/';" >> /etc/phpMyAdmin/config.inc.php
RUN chown -R root.root /etc/phpMyAdmin/

RUN ln -s /usr/share/phpMyAdmin/ /html/phpMyAdmin
ADD scripts/php-fpm/www.conf /etc/php-fpm.d/www.conf
ADD scripts/php-fpm/php-fpm.conf /etc/php-fpm.conf
ADD scripts/entrypoint.sh /usr/bin/entrypoint.sh
ADD scripts/nginx/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /usr/bin/entrypoint.sh


STOPSIGNAL SIGQUIT
USER ${uid}
EXPOSE 8000
ENTRYPOINT ["entrypoint.sh"]
