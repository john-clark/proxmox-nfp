#!/bin/bash
FILENAME=/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
FIND="let res = response.result;"
REPLACE="let res = 'active';"

#backup oem
if [ -f $FILENAME-oem ]; then
  echo "Found OEM backup - already patched"
else
  #make backup
  cp $FILENAME $FILENAME-oem

  #look for one result
  mapfile -t results < <( grep -wi "${FIND}" $FILENAME )
  num=${#results[@]}

  if ((num == 1)); then
    sed -i "s|$FIND|$REPLACE|g" $FILENAME
    echo "Patched"
  else
    echo "Error"
  fi
fi
