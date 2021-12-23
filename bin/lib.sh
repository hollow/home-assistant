#!/usr/bin/env zsh

jq() {
    command jq -r "$@"
}

ha() {
    hass-cli -o json "$@"
}

ha-area-ids() {
    ha area list | jq '.[] | .area_id'
}

ha-entities() {
    ha entity list "$@" | jq '.[] | select(.disabled_by == null)'
}

ha-entity-ids() {
    ha-entities "$@" | jq '.entity_id'
}

ha-entity-assign() {
    ha raw ws config/entity_registry/update --json="$(
        jq -c -n \
        --arg entity_id $1 \
        --arg area_id $2 \
        '{entity_id: $entity_id, area_id: $area_id}'
    )"
}

ha-entity-or-error() {
    jq '.error? // (.result.entity_entry | {area_id, entity_id, original_name})'
}

ha-entity-rename() {
    ha entity rename $1 $2 ${3:+--name=${(qqq)3}} | jq '.[]'
}

ha-orphans() {
    ha-entities "$@" | jq 'select(.area_id == null and .device_id == null)'
}

ha-orphan-ids() {
    ha-orphans "$@" | jq '.entity_id'
}
