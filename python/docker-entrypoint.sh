#!/bin/bash

if [ "${PYTHON_START}" = "YES" ] ; then
  exec python eslListenPlainAll.py
fi

while true
 do clear
  date
  sleep 30
done

