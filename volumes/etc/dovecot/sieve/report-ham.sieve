require ["vnd.dovecot.pipe", "copy", "imapsieve", "environment", "variables"];


if string "${mailbox}" "Trash" {
  stop;
}

pipe :copy "sa-learn-ham.sh" ;
