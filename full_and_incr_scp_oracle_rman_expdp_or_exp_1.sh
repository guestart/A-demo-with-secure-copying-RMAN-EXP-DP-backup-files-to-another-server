#!/bin/bash

# Automatically running this SHELL script by a planed task on every day 03:30.
# crontab -l
# 30 03 * * * ~/scp_scripts/full_and_incr_scp_oracle_rman_expdp_or_exp_1.sh

# +------------------------------------------------------------------------+
# |                              Quanwen Zhao                              |
# |                        quanwenzhao.wordpress.com                       |
# |------------------------------------------------------------------------|
# |       Copyright (c) 2021 -    Quanwen Zhao. All rights reserved.       |
# |------------------------------------------------------------------------|
# | DATABASE  : Oracle                                                     |
# | FILE      : full_and_incr_scp_oracle_rman_expdp_or_exp_1.sh            |
# | CLASS     : LINUX Bourne-Again Shell Scripts                           |
# | PURPOSE   : This bash script file used to copy RMAN backup files that  |
# |             is gerenated by oracle RECOVERY MANAGER and EXPDP/EXP files|
# |             from local to another linux server via scp which is        |
# |             a remote file copy program, and the premise is to configure|
# |             SSH mutual trust function between local and remote server, |
# |             because if it the two hosts configured SSH mutual trust    |
# |             function each other, you can directly use SSH command to   |
# |             connect to another host from this one. Other-wise, you will|
# |             need to enter current user's password from local host,     |
# |             which will produce interaction.And if using shell script,  |
# |             it's the most taboo to produce interaction.                |
# |                                                                        |
# |             For example, there're nine number of oracle db servers:    |
# |             such as, prodb1, prodb2, prodb3, ... prodb9.               |
# |                                                                        |
# | PARAMETER : None.                                                      |
# |                                                                        |
# | MODIFIED  : 01/04/2021 (dd/mm/yyyy)                                    |
# |                                                                        |
# | NOTE      : As with any code, ensure to test this script in a          |
# |             development environment before attempting to run it in     |
# |             production.                                                |
# +------------------------------------------------------------------------+

# +------------------------------------------------------------------------+
# | EXPORT ENVIRONMENT VARIABLE OF ORACLE USER                             |
# +------------------------------------------------------------------------+

source ~/.bash_profile

# +------------------------------------------------------------------------+
# | GLOBAL VARIABLES ABOUT THE ABSOLUTE PATH OF THE SHELL COMMAND          |
# +------------------------------------------------------------------------+

export AWK=`which awk`
export BASENAME=`which basename`
export CAT=`which cat`
export CUT=`which cut`
export DATE=`which date`
export DIFF=`which diff`
export DF=`which df`
export ECHO=`which echo`
export FIND=`which find`
export LS=`which ls`
export MKDIR=`which mkdir`
export GREP=`which grep`
export RM=`which rm`
export SCP=`which scp`
export SCRIPT=`which script`
export SSH=`which ssh`
export TEE=`which tee`
export SORT=`which sort`
export UNIQ=`which uniq`

# +------------------------------------------------------------------------+
# | GLOBAL VARIABLES ABOUT STRINGS AND ABSOLUTE PATH OF THE SHELL COMMAND  |
# +------------------------------------------------------------------------+

export REMOTE_HOSTNAME=
export REMOTE_DIR=
export LOCAL_DIR=
export LOCAL_SUB_DIR=

export DISK_USED_PERCENT=`$DF -h | $GREP "/DATA" | $AWK '{print $5}' | $CUT -d% -f1`

export SCP_LOG_PATH='/home/oracle/scp_log'
export SCP_LOG_FILE=$SCP_LOG_PATH/scp_`$DATE +%Y%m%d%H%M%S`.log

export TMP_LOCAL_LOG='/tmp/tmp_local.log'
export TMP_LOCAL_LOG_ALL="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_local_all.log"
export TMP_REMOTE_LOG='/tmp/tmp_remote.log'
export TMP_REMOTE_LOG_ALL="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_remote_all.log"
export TMP_COMPARE_LOG='/tmp/tmp_compare.log'
export TMP_COMPARE_LOG_ALL="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_compare_all.log"
export TMP_COMPARE_LOG_2='/tmp/tmp_compare_2.log'
export TMP_COMPARE_LOG_ALL_2="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_compare_all_2.log"

export LOCAL_SUBDIR='/tmp/tmp_local_subdir.log'
export LOCAL_SUBDIR_ALL="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_local_subdir_all.log"
export REMOTE_SUBDIR='/tmp/tmp_remote_subdir.log'
export REMOTE_SUBDIR_ALL="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_remote_subdir_all.log"
export TMP_SUBDIR='/tmp/tmp_subdir.log'
export TMP_SUBDIR_ALL="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_subdir_all.log"
export TMP_SUBDIR_2='/tmp/tmp_subdir_2.log'
export TMP_SUBDIR_ALL_2="/tmp/tmp_`$DATE +%Y%m%d%H%M%S`_subdir_all_2.log"

# +------------------------------------------------------------------------+
# | GLOBAL FUNCTIONS                                                       |
# +------------------------------------------------------------------------+

# The keyword of shell script only supports lowercase you don't use them to uppercase.

> $TMP_LOCAL_LOG
> $TMP_LOCAL_LOG_ALL
> $TMP_REMOTE_LOG
> $TMP_REMOTE_LOG_ALL
> $TMP_COMPARE_LOG
> $TMP_COMPARE_LOG_ALL
> $TMP_COMPARE_LOG_2
> $TMP_COMPARE_LOG_ALL_2

> $LOCAL_SUBDIR
> $LOCAL_SUBDIR_ALL
> $REMOTE_SUBDIR
> $REMOTE_SUBDIR_ALL
> $TMP_SUBDIR
> $TMP_SUBDIR_ALL
> $TMP_SUBDIR_2
> $TMP_SUBDIR_ALL_2

function scp_oracle () {
  REMOTE_HOSTNAME=$1
  REMOTE_DIR=$2
  LOCAL_DIR=$3
  LOCAL_SUB_DIR=$LOCAL_DIR/`$BASENAME $REMOTE_DIR`
  
  if [ ! -d "$LOCAL_SUB_DIR" ]; then
    $MKDIR -p $LOCAL_SUB_DIR
  fi

# $FIND $LOCAL_SUB_DIR -type f >> $TMP_LOCAL_LOG
# $SSH oracle@$REMOTE_HOSTNAME "$FIND $REMOTE_DIR -type f" >> $TMP_REMOTE_LOG
# $DIFF -r $TMP_LOCAL_LOG $TMP_REMOTE_LOG >> $TMP_COMPARE_LOG
# cat /tmp/tmp_1.txt | awk '{print substr($1, length("/DATA/prodb1/rman_backup")+2)}'
# cat /tmp/tmp_2.txt | awk '{print substr($1, length("/u01/app/oracle/rman_backup")+2)}'

# http://www.gnu.org/software/gawk/manual/gawk.html
# https://blog.csdn.net/hfismyangel/article/details/79506756

# $FIND $LOCAL_SUB_DIR -type f | $AWK '{print substr($1, length("$LOCAL_SUB_DIR")+2)}' > $TMP_LOCAL_LOG
# $SSH oracle@$REMOTE_HOSTNAME "$FIND $REMOTE_DIR -type f" | $AWK '{print substr($1, length("$REMOTE_DIR")+2)}' > $TMP_REMOTE_LOG

# As you can see the the content of previous two tmp files /tmp/tmp_local.log and /tmp/tmp_remote.log,
# although their some content is the same but they are not in the same line number,
# which causes difficulty for finding their differences.
# after reading this blog notes https://blog.csdn.net/SoaringLee_fighting/article/details/81710464
# So, I will add the pipe operation "sort -nr" after finding it and next ">" to "$TMP_LOCAL_LOG".
# The same operation for "$TMP_REMOTE_LOG".

# $FIND $LOCAL_SUB_DIR -type f | $SORT -nr | $AWK '{print substr($1, length("$LOCAL_SUB_DIR")+2)}' > $TMP_LOCAL_LOG
# $SSH oracle@$REMOTE_HOSTNAME "find $REMOTE_DIR -type f" | $SORT -nr | $AWK '{print substr($1, length("$REMOTE_DIR")+2)}' > $TMP_REMOTE_LOG

# About how to use the environment variable of SHELL in AWK, https://blog.51cto.com/junlee/545493
# Here's a quesion. Never read the vlaue of variable "LOCAL_DIR" and "REMOTE_DIR" in AWK,
# we can find out it by using "sh -x" to execute this SHELL script.

# $FIND $LOCAL_SUB_DIR -type f | $SORT -nr | $AWK '{print substr($1, length("$LOCAL_SUB_DIR")+2)}' > $TMP_LOCAL_LOG
# $SSH oracle@$REMOTE_HOSTNAME "find $REMOTE_DIR -type f" | $SORT -nr | $AWK '{print substr($1, length("$REMOTE_DIR")+2)}' > $TMP_REMOTE_LOG

$FIND $LOCAL_SUB_DIR -type f | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["LOCAL_SUB_DIR"])+2)}' > $TMP_LOCAL_LOG
$FIND $LOCAL_SUB_DIR -type f | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["LOCAL_SUB_DIR"])+2)}' >> $TMP_LOCAL_LOG_ALL

$SSH oracle@$REMOTE_HOSTNAME "find $REMOTE_DIR -type f" | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["REMOTE_DIR"])+2)}' > $TMP_REMOTE_LOG
$SSH oracle@$REMOTE_HOSTNAME "find $REMOTE_DIR -type f" | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["REMOTE_DIR"])+2)}' >> $TMP_REMOTE_LOG_ALL

# $DIFF -r $TMP_LOCAL_LOG $TMP_REMOTE_LOG > $TMP_COMPARE_LOG
# $CAT $TMP_COMPARE_LOG | $GREP ">" | $AWK '{print $2}' > $TMP_COMPARE_LOG_2

$DIFF -r $TMP_LOCAL_LOG $TMP_REMOTE_LOG > $TMP_COMPARE_LOG
$DIFF -r $TMP_LOCAL_LOG $TMP_REMOTE_LOG >> $TMP_COMPARE_LOG_ALL

$DIFF -r $TMP_LOCAL_LOG $TMP_REMOTE_LOG | $GREP ">" | $AWK '{print $2}' > $TMP_COMPARE_LOG_2
$DIFF -r $TMP_LOCAL_LOG $TMP_REMOTE_LOG | $GREP ">" | $AWK '{print $2}' >> $TMP_COMPARE_LOG_ALL_2

# for tll in `$CAT $TMP_LOCAL_LOG`
# do
#   for trl in `$CAT $TMP_REMOTE_LOG`
#   do
#     if [ $tll = $trl ]; then # https://www.runoob.com/linux/linux-shell-basic-operators.html
#       break
#     else
#       $ECHO $trl >> $TMP_COMPARE_LOG
#     fi
#   done
# done
# 
# $CAT $TMP_COMPARE_LOG >> $TMP_COMPARE_LOG_ALL

# acquiring the subdir of backup_dir on the locate or remote server.

# [oracle@sync_back ~]$ find /DATA/prodb1/rman_backup -type f | awk '{print substr($1, length("/DATA/prodb1/rman_backup")+2)}' | awk -F'/' '{print $1}' | grep -v ".sh" | uniq | sort -nr
# 2021-03-21
# 2021-03-20
# 2021-03-19
# log
# expdp
# controlfile

# [oracle@sync_back ~]$ ssh oracle@prodb1 "find /u01/app/oracle/rman_backup -type f" | awk '{print substr($1, length("/u01/app/oracle/rman_backup")+2)}' | awk -F'/' '{print $1}' | grep -v ".sh" | uniq | sort -nr
# 2021-03-26
# log
# expdp
# controlfile

# find /DATA/prodb1/rman_backup -type d | sort -nr | awk '{print substr($1, length("/DATA/prodb1/rman_backup")+2)}'
$FIND $LOCAL_SUB_DIR -type d | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["LOCAL_SUB_DIR"])+2)}' > $LOCAL_SUBDIR
$FIND $LOCAL_SUB_DIR -type d | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["LOCAL_SUB_DIR"])+2)}' >> $LOCAL_SUBDIR_ALL

# ssh oracle@prodb1 "find /u01/app/oracle/rman_backup -type d" | sort -nr | awk '{print substr($1, length("/u01/app/oracle/rman_backup")+2)}'
$SSH oracle@$REMOTE_HOSTNAME "find $REMOTE_DIR -type d" | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["REMOTE_DIR"])+2)}' > $REMOTE_SUBDIR
$SSH oracle@$REMOTE_HOSTNAME "find $REMOTE_DIR -type d" | $SORT -nr | $AWK '{print substr($1, length(ENVIRON["REMOTE_DIR"])+2)}' >> $REMOTE_SUBDIR_ALL

$DIFF -r $LOCAL_SUBDIR $REMOTE_SUBDIR > $TMP_SUBDIR
$DIFF -r $LOCAL_SUBDIR $REMOTE_SUBDIR >> $TMP_SUBDIR_ALL

$DIFF -r $LOCAL_SUBDIR $REMOTE_SUBDIR | $GREP ">" | $AWK '{print $2}' > $TMP_SUBDIR_2
$DIFF -r $LOCAL_SUBDIR $REMOTE_SUBDIR | $GREP ">" | $AWK '{print $2}' >> $TMP_SUBDIR_ALL_2

# the value of variable TMP_SUBDIR must be a file with absolute path, otherwise SHELL will report this error: ambiguous redirect.

# for lsd in `$CAT $LOCAL_SUBDIR`
# do
#   for rsd in `$CAT $REMOTE_SUBDIR`
#   do
#     if [ $lsd = $rsd ]; then
#       break
#     else
#       $ECHO $rsd >> $TMP_SUBDIR
#     fi
#   done
# done
# 
# $CAT $TMP_SUBDIR >> $TMP_SUBDIR_ALL

# >>==  [oracle@sync_back ~]$ cp ./a/a/b.sh ./b/a/b.sh                          <<==
# >>==  cp: cannot create regular file ‘./b/a/b.sh’: No such file or directory  <<==
# [oracle@sync_back ~]$ mkdir -p ./b/a
# [oracle@sync_back ~]$ 
# [oracle@sync_back ~]$ cp ./a/a/b.sh ./b/a/b.sh

for tsd in `$CAT $TMP_SUBDIR_2`
do
  if [ ! -d "$LOCAL_SUB_DIR/$tsd" ]; then
    $MKDIR -p $LOCAL_SUB_DIR/$tsd
  fi
done

if [ $DISK_USED_PERCENT -le 95 ]; then
  for entry in `$CAT $TMP_COMPARE_LOG_2`
  do
    $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p oracle@$REMOTE_HOSTNAME:$REMOTE_DIR/$entry $LOCAL_SUB_DIR/$entry"
    if [ `$ECHO $?` -ne 0 ]; then
      $ECHO -e "\nRemote copy these files to local has failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
    fi
  done
else
  $ECHO -e "\nDisk available free space is not enough! Please removing some expired files first and try to run this SHELL script.\n" | $TEE -a $SCP_LOG_FILE
fi

> $TMP_LOCAL_LOG
> $TMP_REMOTE_LOG
> $TMP_COMPARE_LOG
> $TMP_COMPARE_LOG_2

> $LOCAL_SUBDIR
> $REMOTE_SUBDIR
> $TMP_SUBDIR
> $TMP_SUBDIR_2
}

# +------------------------------------------------------------------------+
# | CALL FUNCTIONS                                                         |
# +------------------------------------------------------------------------+

# RMAN backup files has located in DB Server prodb1.

scp_oracle prodb1 /u01/app/oracle/rman_backup /DATA/prodb1

# RMAN and EXPDP backup files has located the two independent places in DB Server prodb2.

scp_oracle prodb2 /u01/app/oracle/rman_backup /DATA/prodb2
scp_oracle prodb2 /u01/oradata/expdp /DATA/prodb2

# RMAN and EXPDP backup files has located the two independent places in DB Server prodb3.

scp_oracle prodb3 /u01/app/oracle/rman_backup /DATA/prodb3
scp_oracle prodb3 /u01/oradata/expdp /DATA/prodb3

# RMAN and EXP backup files has located the two independent places in DB Server prodb4.

scp_oracle prodb4 /u01/app/oracle/rman_backup /DATA/prodb4
scp_oracle prodb4 /u01/oradata/exp /DATA/prodb4

# RMAN and EXP backup files has located the two independent places in DB Server prodb5.

scp_oracle prodb5 /u01/app/oracle/rman_backup /DATA/prodb5
scp_oracle prodb5 /u01/oradata/exp /DATA/prodb5

# RMAN and EXP backup files has located the two independent places in DB Server prodb6.

scp_oracle prodb6 /u01/app/oracle/rman_backup /DATA/prodb6
scp_oracle prodb6 /u01/oradata/exp /DATA/prodb6

# Only RMAN (neithor EXPDP nor EXP) backup files has located in DB Server prodb7.

scp_oracle prodb7 /u01/app/oracle/rman_backup /DATA/prodb7

# Only RMAN (neithor EXPDP nor EXP) backup files has located in DB Server prodb8.

scp_oracle prodb8 /u01/app/oracle/rman_backup /DATA/prodb8

# Only EXP (neithor RMAN nor EXPDP) backup files has located in DB Server prodb9.

scp_oracle prodb9 /u01/oradata/exp /DATA/prodb9

# +------------------------------------------------------------------------+
# | REMOVE TEMPORARY LOG FILES,                                            |
# | AND ONLY RETAIN THOSE TEMPORARY LOG FILES INCLUDING THE KEYWORD "ALL". |
# +------------------------------------------------------------------------+

$RM -f $TMP_LOCAL_LOG
$RM -f $TMP_REMOTE_LOG
$RM -f $TMP_COMPARE_LOG
$RM -f $TMP_COMPARE_LOG_2

$RM -f $LOCAL_SUBDIR
$RM -f $REMOTE_SUBDIR
$RM -f $TMP_SUBDIR
$RM -f $TMP_SUBDIR_2
