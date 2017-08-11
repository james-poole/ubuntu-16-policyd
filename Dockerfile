FROM docker.io/1and1internet/ubuntu-16:latest
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
RUN \
  groupadd mysql && \
  useradd -g mysql mysql && \
  apt-get update && \
  apt-get -o Dpkg::Options::=--force-confdef -y install gettext-base postfix-cluebringer mysql-server mysql-client libconfig-inifiles-perl libcache-fastmmap-perl -y && \
  yes | /usr/bin/perl -MCPAN -e 'install Net::Server' && \
  /usr/bin/perl -MCPAN -e 'install Net::CIDR' && \
  /usr/bin/perl -MCPAN -e 'install Mail::SPF' && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* /var/lib/mysql /etc/mysql* && \
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld /etc/mysql && \
  chmod 0777 /docker-entrypoint-initdb.d && \
  chmod -R 0775 /etc/mysql && \
  chmod -R 0755 /hooks && \
  chmod -R 0777 /var/log/mysql
ENV MYSQL_ROOT_PASSWORD=ReplaceWithENVFromBuild \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_QUERY_CACHE_TYPE=1 \
    MYSQL_QUERY_CACHE_SIZE=16M \
    MYSQL_QUERY_CACHE_LIMIT=1M
EXPOSE 10031
