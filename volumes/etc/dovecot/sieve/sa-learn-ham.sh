#!/bin/sh
exec /usr/bin/rspamc  -h rspam -P /run/secrets/RSPAM_Clear_password learn_ham
