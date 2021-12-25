#!/usr/bin/env zsh
source "${0:A:h}/lib.sh"

trap "exit" INT TERM
trap "kill 0" EXIT

tail -F -n0 ${0:A:h:h}/home-assistant.log &
${0:A:h:h:h}/docker/bin/stack restart home-assistant

wait
