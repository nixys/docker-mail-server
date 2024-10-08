FROM postfixadmin

RUN apt-get -y update \
    && apt-get install -y dovecot-core \
    && apt-get purge -y --auto-remove \
    && apt-get clean
