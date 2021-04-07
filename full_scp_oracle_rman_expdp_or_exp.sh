#!/bin/bash

# Automatically running this SHELL script by a planed task on each Friday 03:30.
# crontab -l
# 30 03 * * 5 ~/scp_scripts/full_scp_oracle_rman_expdp_or_exp.sh

# +------------------------------------------------------------------------+
# |                              Quanwen Zhao                              |
# |                        quanwenzhao.wordpress.com                       |
# |------------------------------------------------------------------------|
# |       Copyright (c) 2021 -    Quanwen Zhao. All rights reserved.       |
# |------------------------------------------------------------------------|
# | DATABASE  : Oracle                                                     |
# | FILE      : full_scp_oracle_rman_expdp_or_exp.sh                       |
# | CLASS     : LINUX Bourne-Again Shell Scripts                           |
# | PURPOSE   : This bash script file used to copy RMAN backup files that  |
# |             is gerenated by oracle RECOVERY MANAGER and EXPDP files    |
# |             or EXP backup files from local to another linux server     |
# |             (all from ysyk oracle servers) via scp which is a remote   |
# |             file copy program, and the premise is to configure SSH     |
# |             mutual trust function between local and remote server,     |
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
# | MODIFIED  : 07/04/2021 (dd/mm/yyyy)                                    |
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

export DATE=`which date`
export ECHO=`which echo`
export SCP=`which scp`
export SCRIPT=`which script`
export TEE=`which tee`

# +------------------------------------------------------------------------+
# | GLOBAL VARIABLES ABOUT STRINGS AND ABSOLUTE PATH OF THE SHELL COMMAND  |
# +------------------------------------------------------------------------+

export DISK_ARRAY=
export SCP_LOG_PATH='/home/oracle/scp_log'
export SCP_LOG_FILE=$SCP_LOG_PATH/scp_`$DATE +%Y%m%d%H%M%S`.log

# +------------------------------------------------------------------------+
# | GLOBAL FUNCTIONS                                                       |
# +------------------------------------------------------------------------+

function full_scp_oracle_rman_prodb1 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb1:$DISK_ARRAY/* /DATA/prodb1/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_rman_expdp_prodb2 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb2:$DISK_ARRAY/* /DATA/prodb2/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
  DISK_ARRAY='/u01/oradata/expdp'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p oracle@prodb2:$DISK_ARRAY/* /DATA/prodb2/expdp/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of EXPDP files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_rman_expdp_prodb3 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb3:$DISK_ARRAY/* /DATA/prodb3/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
  DISK_ARRAY='/u01/oradata/expdp'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p oracle@prodb3:$DISK_ARRAY/* /DATA/prodb3/expdp/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of EXPDP files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_rman_exp_prodb4 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb4:$DISK_ARRAY/* /DATA/prodb4/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
  DISK_ARRAY='/u01/oradata/exp'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p oracle@prodb4:$DISK_ARRAY/* /DATA/prodb4/exp/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of EXP files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_rman_exp_prodb5 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb5:$DISK_ARRAY/* /DATA/prodb5/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
  DISK_ARRAY='/u01/oradata/exp'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p oracle@prodb5:$DISK_ARRAY/* /DATA/prodb5/exp/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of EXP files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_rman_exp_prodb6 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb6:$DISK_ARRAY/* /DATA/prodb6/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
  DISK_ARRAY='/u01/oradata/exp'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p oracle@prodb6:$DISK_ARRAY/* /DATA/prodb6/exp/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of EXP files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_rman_prodb7 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb7:$DISK_ARRAY/* /DATA/prodb7/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_rman_prodb8 () {
  DISK_ARRAY='/u01/app/oracle/rman_backup'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p -r oracle@prodb8:$DISK_ARRAY/* /DATA/prodb8/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of RMAN backup files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

function full_scp_oracle_exp_prodb9 () {
  DISK_ARRAY='/u01/oradata/exp'
  $SCRIPT -a $SCP_LOG_FILE -c "$SCP -p oracle@prodb9:$DISK_ARRAY/* /DATA/prodb9/exp/"
  if [ `$ECHO $?` -ne 0 ]; then
    $ECHO -e "\nRemote copy all of EXP files that are generated today failed. Please check error information from log file.\n" | $TEE -a $SCP_LOG_FILE
  fi
}

# +------------------------------------------------------------------------+
# | CALL FUNCTIONS                                                         |
# +------------------------------------------------------------------------+

full_scp_oracle_rman_prodb1
full_scp_oracle_rman_expdp_prodb2
full_scp_oracle_rman_expdp_prodb3
full_scp_oracle_rman_exp_prodb4
full_scp_oracle_rman_exp_prodb5
full_scp_oracle_rman_exp_prodb6
full_scp_oracle_rman_prodb7
full_scp_oracle_rman_prodb8
full_scp_oracle_exp_prodb9
