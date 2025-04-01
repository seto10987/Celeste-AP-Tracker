ENABLE_DEBUG_LOG = true

ScriptHost:LoadScript("scripts/items.lua")
ScriptHost:LoadScript("scripts/locations.lua")
ScriptHost:LoadScript("scripts/layouts.lua")
ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")

if not IS_ITEMS_ONLY then
    Tracker:AddMaps("maps/maps.json")
end