FROM docker.io/1and1internet/ubuntu-16-apache-php-7.1:latest
ARG DEBIAN_FRONTEND=noninteractive
COPY files /
RUN \
  groupadd mysql && \
  useradd -g mysql mysql && \
  groupadd cbpolicyd && \
  useradd -g cbpolicyd cbpolicyd && \
  apt-get update && \
  apt-get -o Dpkg::Options::=--force-confdef -y install gettext-base postfix-cluebringer mysql-server mysql-client postfix-cluebringer postfix-cluebringer-mysql postfix-cluebringer-webui -y && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* /var/lib/mysql /etc/mysql* /etc/cluebringer && \
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld /etc/mysql /etc/cluebringer && \
  cp /usr/share/doc/postfix-cluebringer/database/policyd-db.mysql.gz /tmp/ && \
  cp -r /usr/share/postfix-cluebringer-webui/webui/* /var/www/html/ && \
  gunzip /tmp/policyd-db.mysql.gz && \
  sed -i -e 's/TYPE=InnoDB/ENGINE=InnoDB/g' /tmp/policyd-db.mysql && \
  chmod 0777 /docker-entrypoint-initdb.d && \
  chmod -R 0775 /etc/mysql /etc/cluebringer && \
  chmod -R 0755 /hooks && \
  chmod -R 0777 /var/log/mysql && \
  chmod 0666 /var/log/cbpolicyd.log
ENV MYSQL_ROOT_PASSWORD=ReplaceWithENVFromBuild \
    MYSQL_DATABASE=cluebringer \
    MYSQL_USER=cluebringer \
    MYSQL_PASSWORD=ReplaceWithENVFromBuild \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_QUERY_CACHE_TYPE=1 \
    MYSQL_QUERY_CACHE_SIZE=16M \
    MYSQL_QUERY_CACHE_LIMIT=1M \
    CLUEBRINGER_DB_BACKEND=mysql \
    CLUEBRINGER_DB_PORT=3306 \
    CLUEBRINGER_DB_HOST=localhost
EXPOSE 10031
