#!/bin/sh
set -e

cd /etc/rspamd/local.d
sed -i "s/REDIS_PORT/${REDIS_PORT}/" redis.conf
sed -i "s/REDIS_PASSWORD/${REDIS_PASSWORD}/" redis.conf
sed -i "s/RSPAM_REDIS_DB/${RSPAM_REDIS_DB}/" redis.conf
sed -i "s/CLAMAV_IP/${CLAMAV_IP}/" antivirus.conf
sed -i "s/REDIS_PORT/${REDIS_PORT}/" classifier-bayes.conf

printf "enable_password = \"${RSPAM_enable_password}\";\n\
password = \"${RSPAM_password}\";\n\
bind_socket = \"0.0.0.0:11334\";\n" > worker-controller.inc

sed -i "s/RSPAM_IP/${RSPAM_IP}/" worker-normal.inc

printf "neighbours {\n\
    ${RSPAM_NEIGHBOURS}\n\
}\
" >> options.inc

# ( freshclam -u ${RSPAM_USER} && \
# clamd && \
(rspamd -f -u ${RSPAM_USER} -g $RSPAM_GROUP ) || exec "$@"
