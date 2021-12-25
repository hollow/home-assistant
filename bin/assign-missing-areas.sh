#!/usr/bin/env zsh

source "${0:A:h}/lib.sh"

if [[ $# -eq 0 ]]; then
    set -- ${(@o)$(ha-area-ids)}
fi

for area_id ($@); do
    echo ">>> checking entities in area '${area_id}'"
    for entity_id ($(ha-orphan-ids "\.${area_id}")); do
        ha-entity-assign ${entity_id} ${area_id} | \
        ha-entity-or-error
    done
done

echo ">>> checking remaining orphans"
ha-orphan-ids ".*"
