#sur evode

export EDITOR=vi
alias log='cd /var/adm/atria/log'
alias ct='/usr/atria/bin/cleartool'
alias rm='rm -i'
alias ll='ls -la'
alias l='ls -la'


#XTERM_DISPLAY=$(echo $(who -m | awk '{print $6}') | cut -c2-$(($(expr $(who -m | awk '{print $6}') : '.*')-1)))
XTERM_DISPLAY=$(echo $(who -m | awk '{print $6}') | tr -d '()')

alias setDisplay='export DISPLAY=$XTERM_DISPLAY'

alias setEnvMaint='. $APP_HOME/bin/setEnv.sh BIP_MAINTENANCE'
alias setEnvRec='. $APP_HOME/bin/setEnv.sh BIP_RECETTE'
alias setEnvRe7Wl='. $APP_HOME/bin/setEnv.sh BIP_RE7WL'
alias setEnvDevWl='. $APP_HOME/bin/setEnv.sh BIP_DEVWL'
alias setEnvDev10='. $APP_HOME/bin/setEnv.sh BIP_DEV10'
#alias setEnvProd='. $APP_HOME/bin/setEnv.sh BIP_PRODUCTION'

export hote=${hote:-`hostname`}
CLEARCASE_ROOT=${CLEARCASE_ROOT:-** NONE **}

PS1='$hote:[$BIP_ENV]	[${CLEARCASE_ROOT##/view/}]	*$DISPLAY*
$PWD>'
export PS1
