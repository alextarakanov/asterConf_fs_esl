# asterConf_fs_esl

FreeSwitch ESL example
Подготовка к AsterConf2020

# show reg users:

sofia status profile internal reg

#set console log
console loglevel console|alert|crit|err|warning|notice|info|debug
0 - CONSOLE
1 - ALERT
2 - CRIT
3 - ERR
4 - WARNING
5 - NOTICE
6 - INFO
7 - DEBUG

#show dialplan
fs_cli -x 'xml_locate dialplan context name public' |grep -v '^\$' |grep -A 10 asterConf2020_01
