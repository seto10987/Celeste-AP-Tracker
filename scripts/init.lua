-- entry point for all lua code of the pack
-- more info on the lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
ENABLE_DEBUG_LOG = true
-- get current variant
local variant = Tracker.ActiveVariantUID
-- check variant info
IS_ITEMS_ONLY = variant:find("itemsonly")

print("-- Example Tracker --")
print("Loaded variant: ", variant)
if ENABLE_DEBUG_LOG then
    print("Debug logging is enabled!")
end

-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")

-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Custom Items
ScriptHost:LoadScript("scripts/custom_items/class.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlus.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlusWrapper.lua")
ScriptHost:LoadScript("scripts/logic.lua")

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/labels.json")
Tracker:AddItems("items/settings.json")

if not IS_ITEMS_ONLY then -- <--- use variant info to optimize loading
    -- Maps
    Tracker:AddMaps("maps/maps.json")
    -- Locations
    Tracker:AddLocations("locations/city/city.json")
    Tracker:AddLocations("locations/old_site/old_site.json")
    Tracker:AddLocations("locations/hotel/hotel.json")
    Tracker:AddLocations("locations/ridge/ridge.json")
    Tracker:AddLocations("locations/mirror_temple/mirror_temple.json")
    Tracker:AddLocations("locations/reflection/reflection.json")
    Tracker:AddLocations("locations/summit/summit.json")
    Tracker:AddLocations("locations/epilogue/epilogue.json")
    Tracker:AddLocations("locations/core/core.json")
    Tracker:AddLocations("locations/farewell/farewell.json")
    Tracker:AddLocations("locations/city/city_start.json")
    Tracker:AddLocations("locations/city/city_crossing.json")
    Tracker:AddLocations("locations/city/city_chasm.json")
    Tracker:AddLocations("locations/old_site/old_site_start.json")
    Tracker:AddLocations("locations/old_site/old_site_intervention.json")
    Tracker:AddLocations("locations/old_site/old_site_awake.json")
    Tracker:AddLocations("locations/hotel/hotel_start.json")
    Tracker:AddLocations("locations/hotel/hotel_huge_mess.json")
    Tracker:AddLocations("locations/hotel/hotel_elevator_shaft.json")
    Tracker:AddLocations("locations/hotel/hotel_presidential_suite.json")
    Tracker:AddLocations("locations/ridge/ridge_start.json")
    Tracker:AddLocations("locations/ridge/ridge_shrine.json")
    Tracker:AddLocations("locations/ridge/ridge_old_trail.json")
    Tracker:AddLocations("locations/ridge/ridge_cliff_face.json")
    Tracker:AddLocations("locations/mirror_temple/mirror_temple_start.json")
    Tracker:AddLocations("locations/mirror_temple/mirror_temple_depths.json")
    Tracker:AddLocations("locations/mirror_temple/mirror_temple_unravelling.json")
    Tracker:AddLocations("locations/mirror_temple/mirror_temple_search.json")
    Tracker:AddLocations("locations/reflection/reflection_hollows.json")
    Tracker:AddLocations("locations/summit/summit_start.json")
    Tracker:AddLocations("locations/summit/summit_500_m.json")
    Tracker:AddLocations("locations/summit/summit_1000_m.json")
    Tracker:AddLocations("locations/summit/summit_1500_m.json")
    Tracker:AddLocations("locations/summit/summit_2000_m.json")
    Tracker:AddLocations("locations/summit/summit_2500_m.json")
    Tracker:AddLocations("locations/summit/summit_3000_m.json")
    Tracker:AddLocations("locations/core/core_into_the_core.json")
    Tracker:AddLocations("locations/core/core_hot_and_cold.json")
    Tracker:AddLocations("locations/core/core_heart_of_the_mountain.json")
end

-- Layout
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/settings.json")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end
