#!/bin/bash


rm -f /etc/freeswitch/sip_profiles/internal.xml
rm -f /etc/freeswitch/sip_profiles/internal-ipv6.xml

rm -f /etc/freeswitch/sip_profiles/external-ipv6.xml
rm -fR /etc/freeswitch/sip_profiles/external-ipv6/


envsubst '$$DOCKER_IP' < /etc/freeswitch/template/sip_profiles/internal.xml > /etc/freeswitch/sip_profiles/internal.xml
envsubst '$$DOCKER_EXT_IP' < /etc/freeswitch/template/sip_profiles/external.xml > /etc/freeswitch/sip_profiles/external.xml

envsubst '$$FS_PORT_INTERNAL $$FS_PORT_EXTERNAL $$FS_USR_PWD' < /etc/freeswitch/template/vars.xml > /etc/freeswitch/vars.xml
envsubst '$$FS_CLI_PWD' < /etc/freeswitch/template/autoload_configs/event_socket.conf.xml > /etc/freeswitch/autoload_configs/event_socket.conf.xml
envsubst '$$FS_PORT_INTERNAL $$FS_PORT_EXTERNAL' < /etc/freeswitch/template/autoload_configs/switch.conf.xml > /etc/freeswitch/autoload_configs/switch.conf.xml


cp -f /etc/freeswitch/template/autoload_configs/modules.conf.xml  /etc/freeswitch/autoload_configs/modules.conf.xml


if [ "${FS_START}" = "YES" ] ; then
  exec /usr/bin/freeswitch -rp
fi

while true
 do clear
  date
  sleep 30
done

