#/bin/sh
export INOTI_HOME=`pwd`;
inoticoming --logfile $INOTI_HOME/log/inoti.log --foreground --initialsearch  $INOTI_HOME/incoming --chdir $INOTI_HOME/incoming --suffix png $INOTI_HOME/process.sh {} \;
