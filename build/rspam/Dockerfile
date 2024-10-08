FROM alpine:edge

ARG RSPAM_gid
ARG RSPAM_GROUP
ARG RSPAM_USER
ARG RSPAM_uid
ARG RSPAM_PASSWORD

ENV RSPAM_REDIS_DB=7


RUN set -eux && \
        addgroup -S -g ${RSPAM_gid} $RSPAM_GROUP || export RSPAM_GROUP=root  && \
        adduser -S -D -H -u $RSPAM_uid -G $RSPAM_GROUP -g "RSPAM user" ${RSPAM_USER} && \
        apk add --no-cache --virtual \
            tzdata \
            rspamd \
            rspamd-controller \
            rspamd-client \
            rspamd-utils \
            rspamd-proxy \
            rspamd-libs


COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ADD etc/rspamd /etc/rspamd

ARG ACCESS_FIX="/var/log/rspamd /run/rspamd /var/lib/rspamd /etc/rspamd "
RUN for d in ${ACCESS_FIX} ; do mkdir -p $d ; done ; \
    chown -R ${RSPAM_USER}:${RSPAM_GROUP} ${ACCESS_FIX} && \
    find ${ACCESS_FIX} -type d -exec chmod g+wx {} \;

EXPOSE 11334
RUN chmod +x /usr/local/bin/entrypoint.sh
USER ${RSPAM_USER}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
