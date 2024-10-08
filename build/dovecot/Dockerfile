FROM alpine:3.17 as build

ARG vmail_gid
ARG VMAIL_GROUP
ARG VMAIL_USER
ARG vmail_uid
ARG dovecot_tag
ARG dovecot_branch=main
ARG pigeonhole_branch
ARG DOVECOT_PREFIX=/usr/local/dovecot

#
#  ARG ACCESS_FIX="/run/dovecot /var/run/dovecot"
#

# build options
ARG dovecot_config="--without-pam \
          --without-cdb \
          --with-zlib \
          --with-bzlib \
          --with-storages=maildir \
          --without-ldap \
          --with-ssl=openssl \
          --sysconfdir=/etc \
          --prefix=${DOVECOT_PREFIX}  \
          --with-sql=yes \
          --without-sqlite \
          --without-apparmor \
          --without-mysql \
          --with-pgsql \
          --without-docs \
          --without-libcap \
          --without-sql-drivers \
          --without-mysql \
          --without-sodium \
          --without-systemd \
          --localstatedir=/var/lib/dovecot \
          --enable-dependency-tracking"

ARG pigeonhole_config="--with-dovecot=../dovecot --sysconfdir=/etc --prefix=${DOVECOT_PREFIX} --localstatedir=/var/lib/dovecot \
    --with-managesieve=yes \
        --with-ldap=no"

RUN addgroup -S -g ${vmail_gid} vmail || export VMAIL_GROUP=root  && adduser -S -D -H -u $vmail_uid -G $VMAIL_GROUP -g "Dovecot Vmail" ${VMAIL_USER} && \
    set -x && \
    apk update && \
    apk add --no-cache --virtual .build-deps \
        bzip2-dev lz4-dev xz-dev zlib-dev \
        runc \
        postgresql-dev mariadb-dev sqlite-dev \
        openldap-dev \
        heimdal-dev \
        gnu-libiconv \
        linux-headers git automake cmake \
            gawk \
            g++ \
            make \
            openldap-dev zlib-dev bzip2-dev autoconf libtool libc-dev gettext gcc bison flex gnutls-dev gettext-dev rpcgen openssl-dev file && \
    mkdir -p /opt/dovecot && cd /opt/dovecot && \
    git init . && \
    git remote add -t ${dovecot_branch} origin https://github.com/dovecot/core && \
    git fetch --depth 1 && git checkout ${dovecot_tag} && \
    ./autogen.sh && \
    mkdir -p ${DOVECOT_PREFIX} && \
    PANDOC=false  ./configure ${dovecot_config} ### &&  \
RUN set -x && \
    cd /opt/dovecot && \
    make -s -j$(nproc)
RUN set -x && \
    cd /opt/dovecot && \
    make install && \
    mkdir /opt/pigeonhole/ && \
    cd /opt/pigeonhole && \
    git init . && git remote add -t ${pigeonhole_branch} origin https://github.com/dovecot/pigeonhole.git && \
    git fetch --depth=1 && git checkout ${pigeonhole_branch} && ./autogen.sh && \
    ./configure ${pigeonhole_config} && \
    make -s -j$(nproc) && make install && \
### Setup Container for Dovecot
    rm -rf /etc/dovecot/* && \
    mkdir -p /var/lib/dovecot && \
    chown -R ${VMAIL_USER}:${VMAIL_GROUP} /var/mail && \
    chown -R ${VMAIL_USER}:${VMAIL_GROUP} /var/lib/dovecot/  ${DOVECOT_PREFIX}

### Networking Configuration
EXPOSE 1143 2525 1024 1587 1993 4190


FROM alpine:3.17

ARG vmail_gid
ARG VMAIL_GROUP
ARG VMAIL_USER
ARG vmail_uid

COPY --from=build /usr/local/dovecot /usr/local/dovecot

RUN apk update && \
    apk add zlib wget \
    bzip2 \
    lz4 \
    rspamd-client \
    bzip2-dev lz4-dev xz-dev zlib-dev libpq-dev && \
    addgroup -S -g ${vmail_gid} vmail || export VMAIL_GROUP=root  && adduser -S -D -H -u $vmail_uid -G $VMAIL_GROUP -g "Dovecot Vmail" ${VMAIL_USER} && \
    mkdir -p /var/lib/dovecot && \
    mkdir -p /etc/dovecot && \
    mkdir -p /var/run/dovecot && \
    chown -R ${VMAIL_USER}:${VMAIL_GROUP} /var/lib/dovecot/ /var/run/dovecot/ ${DOVECOT_PREFIX} && \
    chown -R ${VMAIL_USER}:${VMAIL_GROUP} /etc/dovecot && \
    chmod u+x /usr/local/dovecot/libexec/dovecot/dovecot-lda && \
    adduser vmail mem

USER ${VMAIL_USER}

CMD ["/usr/local/dovecot/sbin/dovecot", "-F"]
# CMD ["/bin/sh"]