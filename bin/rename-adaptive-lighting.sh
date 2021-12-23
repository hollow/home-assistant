#!/usr/bin/env zsh

source "${0:A:h}/lib.sh"

ha-friendly-name() {
    ha state get $1 | jq -r '.[] | .attributes.friendly_name' | sed 's/.*: //'
}

for entity_id ($(ha-entity-ids "switch.adaptive_lighting_sleep_mode")); do
    local id=${entity_id/switch.adaptive_lighting_sleep_mode_}
    local name=$(ha-friendly-name ${entity_id})

    ha entity rename \
        switch.adaptive_lighting_${id} \
        switch.${id}_light_adapt \
        --name "${name} Light Adapt" | \
    jq -r '.[] | .result.entity_entry.name'

    ha entity rename \
        switch.adaptive_lighting_adapt_brightness_${id} \
        switch.${id}_light_adapt_brightness \
        --name "${name} Light Adapt Brightness" | \
    jq -r '.[] | .result.entity_entry.name'

    ha entity rename \
        switch.adaptive_lighting_adapt_color_${id} \
        switch.${id}_light_adapt_color \
        --name "${name} Light Adapt Color" | \
    jq -r '.[] | .result.entity_entry.name'

    ha entity rename \
        switch.adaptive_lighting_sleep_mode_${id} \
        switch.${id}_sleep_mode \
        --name "${name} Sleep Mode" | \
    jq -r '.[] | .result.entity_entry.name'
done
