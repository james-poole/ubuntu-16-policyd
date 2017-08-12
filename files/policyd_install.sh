#!/bin/bash
set -eo pipefail
path="/tmp/policyd-cluebringer/cluebringer"
mkdir -p $path
wget http://download.policyd.org/v2.0.14/cluebringer-v2.0.14.tar.xz -O /tmp/policyd-cluebringer/cluebringer.tar.xz
unxz -c /tmp/policyd-cluebringer/cluebringer.tar.xz | tar xv --strip-components=1 -C /tmp/policyd-cluebringer/cluebringer
for d in /tmp/policyd-cluebringer/cluebringer/database
  do for i in core.tsql access_control.tsql amavis.tsql checkhelo.tsql checkspf.tsql greylisting.tsql quotas.tsql
    do $d/convert-tsql mysql55 $d/$i
  done > $d/policyd.mysql
done
# Install and file move.
if [ -e "/user/local/lib/cbpolicyd-2.1" ]; then
    echo "PolicyD found. Doing nothing."
    exit 0
fi

mv $path/cluebringer.conf /etc/cluebringer.conf
#can we populate cluebringer.conf database credentials from enviromental variables?
mkdir /usr/local/lib/cbpolicyd-2.1
cp -r $path/cbp /usr/local/lib/policyd-2.0/
#cp -r $path/awitpt/awitpt /usr/local/lib/cbpolicyd-2.1/
cp $path/cbpadmin /usr/local/bin/
cp $path/cbpolicyd /usr/local/sbin/
cp -r $path/webui/* /var/www/html/
mkdir /var/log/cbpolicyd
mkdir /var/run/cbpolicyd
chown cbpolicyd.cbpolicyd /var/log/cbpolicyd /var/run/cbpolicyd
