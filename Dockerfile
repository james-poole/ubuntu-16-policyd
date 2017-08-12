FROM docker.io/1and1internet/ubuntu-16:latest
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
  rm -rf /var/lib/apt/lists/* /var/lib/mysql /etc/mysql* && \
  mkdir --mode=0777 /var/lib/mysql /var/run/mysqld /etc/mysql && \
  cp /usr/share/doc/postfix-cluebringer/database/policyd-db.mysql.gz /tmp/ && \
  gunzip /tmp/policyd-db.mysql.gz && \
  sed -i -e 's/TYPE=InnoDB/ENGINE=InnoDB/g' /tmp/policyd-db.mysql && \
  chmod 0777 /docker-entrypoint-initdb.d && \
  chmod -R 0775 /etc/mysql && \
  chmod -R 0755 /hooks && \
  chmod -R 0777 /var/log/mysql
ENV MYSQL_ROOT_PASSWORD=ReplaceWithENVFromBuild \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_QUERY_CACHE_TYPE=1 \
    MYSQL_QUERY_CACHE_SIZE=16M \
    MYSQL_QUERY_CACHE_LIMIT=1M \
    CLUEBRINGER_DB_PASSWORD=ReplaceWithENVFromBuild
EXPOSE 10031
