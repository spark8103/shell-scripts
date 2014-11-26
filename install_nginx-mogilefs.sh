#!/bin/bash

#
# Purpose: One-key operation install nginx normal
# Date:        2013-06-18
# Author:      xtso520ok@gmail.com
# Environment: OS Linux, gcc, gcc-c++, make, zlib
# Des:         ...
#

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

NAME="nginx normal"
echo ===============================================================================
echo Install $NAME if required...
echo ===============================================================================
NOTE_ID=$(date +%Y%m%d-%s)

# Source prepare
PREFIX=nginx-mogilefs
DIR=/usr/local/src
cd $DIR
S_NGINX=$DIR/nginx-1.2.9
U_NGINX=http://nginx.org/download/nginx-1.2.9.tar.gz
[ -e $S_NGINX.tar.gz ] || wget $U_NGINX -O $S_NGINX.tar.gz && tar xzf $S_NGINX.tar.gz
S_PCRE=$DIR/pcre-8.33
U_PCRE=http://ncu.dl.sourceforge.net/project/pcre/pcre/8.33/pcre-8.33.tar.gz
[ -e $S_PCRE.tar.gz ] || wget $U_PCRE -O $S_PCRE.tar.gz && tar xzf $S_PCRE.tar.gz
S_NGINXACCESSKEY=$DIR/nginx-accesskey-2.0.3
U_NGINXACCESSKEY=http://wiki.nginx.org/images/5/51/Nginx-accesskey-2.0.3.tar.gz 
[ -e $S_NGINXACCESSKEY.tar.gz ] || wget $U_NGINXACCESSKEY -O $S_NGINXACCESSKEY.tar.gz && tar xzf $S_NGINXACCESSKEY.tar.gz
S_NGINXMOGILEFS=$DIR/nginx_mogilefs_module-1.0.4
U_NGINXMOGILEFS=http://www.grid.net.ru/nginx/download/nginx_mogilefs_module-1.0.4.tar.gz
[ -e $S_NGINXMOGILEFS.tar.gz ] || wget $U_NGINXMOGILEFS -O $S_NGINXMOGILEFS.tar.gz && tar xzf $S_NGINXMOGILEFS.tar.gz


# Operate
id www 2>&1 1>/dev/null
[ $? -eq 0 ] || useradd -M -s /bin/sh --uid=515 www
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/html/200.jpg -O $S_NGINX/html/200.jpg
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/html/404.html -O $S_NGINX/html/404.html
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/html/404.jpg -O $S_NGINX/html/404.jpg
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/html/500.html -O $S_NGINX/html/500.html
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/html/500.jpg -O $S_NGINX/html/500.jpg
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/html/favicon.ico -O $S_NGINX/html/favicon.ico
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/html/index.html -O $S_NGINX/html/index.html
mkdir -p $S_NGINX/conf/vhost
mv $S_NGINX/conf/nginx.conf{,.$NOTE_ID}
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-mogilefs/nginx.conf -O $S_NGINX/conf/nginx.conf
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/nginx-init -O $S_NGINX/conf/nginx-init
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/nginx-sysconfig -O $S_NGINX/conf/nginx-sysconfig
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-normal/vhost/fs.i-david.org.conf -O $S_NGINX/conf/vhost/fs.i-david.org.conf
wget -q https://raw.github.com/xtso520ok/autoconf/master/nginx-mogilefs/ngx_http_mogilefs_module.c -O $S_NGINXMOGILEFS/ngx_http_mogilefs_module.c
sed -i 's/PREFIX/'$PREFIX'/'  $S_NGINX/conf/nginx-sysconfig
sed -i 's/"1.2.9"/"1.2.9_1.0"/' $S_NGINX/src/core/nginx.h
sed -i 's/"nginx\/"/"DS\/"/' $S_NGINX/src/core/nginx.h
sed -i 's/"NGINX"/"DS"/' $S_NGINX/src/core/nginx.h
sed -i 's/"Server: nginx"/"Server: DS"/' $S_NGINX/src/http/ngx_http_header_filter_module.c
sed -i 's/\$HTTP_ACCESSKEY_MODULE/ngx_http_accesskey_module/' $DIR/nginx-accesskey-2.0.3/config

# Install
cd $S_NGINX
./configure --prefix=/usr/local/$PREFIX --user=www --group=www --with-http_gzip_static_module --with-http_stub_status_module --with-pcre=$S_PCRE --add-module=$S_NGINXACCESSKEY --add-module=$S_NGINXMOGILEFS
make
make install

# Configure
mkdir -p /usr/local/$PREFIX/conf/vhost
/bin/cp -r $S_NGINX/conf/vhost/fs.i-david.org.conf /usr/local/$PREFIX/conf/vhost/fs.i-david.org.conf
[ -e /etc/sysconfig/nginx ] && /bin/mv /etc/sysconfig/nginx{,.$NOTE_ID}
/bin/cp $S_NGINX/conf/nginx-sysconfig /etc/sysconfig/nginx
[ -e /usr/sbin/nginx ] && /bin/mv /usr/sbin/nginx{,.$NOTE_ID}
rm -f /usr/sbin/nginx
ln -s /usr/local/$PREFIX/sbin/nginx /usr/sbin/nginx
[ -e /etc/init.d/nginx ] && /bin/mv /etc/init.d/nginx{,.$NOTE_ID}
/bin/cp $S_NGINX/conf/nginx-init /etc/init.d/nginx
chmod +x $S_NGINX/conf/nginx-init /etc/init.d/nginx
/usr/sbin/nginx -t 

