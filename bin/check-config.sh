#!/usr/bin/env zsh
source "${0:A:h}/lib.sh"

trap "exit" INT TERM
trap "kill 0" EXIT

tail -f -n0 ${0:A:h:h}/home-assistant.log &
ha service call homeassistant.check_config | jq '.[]'
sleep 1
