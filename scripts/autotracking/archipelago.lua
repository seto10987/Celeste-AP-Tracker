-- this is an example/ default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via thier ids
-- it will also load the AP slot data in the global SLOT_DATA, keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, location_array in pairs(LOCATION_MAPPING) do
        for _, location in pairs(location_array) do
            if location then
                local obj = Tracker:FindObjectForCode(location)
                if obj then
                    if location:sub(1, 1) == "@" then
                        obj.AvailableChestCount = obj.ChestCount
                    else
                        obj.Active = false
                    end
                end
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        for _, innertable in pairs(v) do
            if innertable[1] and innertable[2] then
                if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: clearing item %s of type %s", innertable[1], innertable[2]))
                end
                local obj = Tracker:FindObjectForCode(innertable[1])
                if obj then
                    if innertable[2] == "toggle" then
                        obj.Active = false
                    elseif innertable[2] == "progressive" then
                        obj.CurrentStage = 0
                        obj.Active = false
                    elseif innertable[2] == "consumable" then
                        obj.AcquiredCount = 0
                    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                        print(string.format("onClear: unknown item type %s for code %s", innertable[2], innertable[1]))
                    end
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: could not find object for code %s", innertable[1]))
                end
            end
        end
    end
    print(dump_table(SLOT_DATA))

    if slot_data["berries_required"] ~= 0 then
        Tracker:FindObjectForCode("berriesrequired").AcquiredCount = tonumber(slot_data["berries_required"])
    end
    if slot_data["hearts_required"] ~= 0 then
        Tracker:FindObjectForCode("heartsrequired").AcquiredCount = tonumber(slot_data["hearts_required"])
    end
    if slot_data["berries_required"] ~= 0 then
        Tracker:FindObjectForCode("cassettesrequired").AcquiredCount = tonumber(slot_data["cassettes_required"])
    end
    if slot_data["levels_required"] ~= 0 then
        Tracker:FindObjectForCode("comprequired").AcquiredCount = tonumber(slot_data["levels_required"])
    end
    if slot_data["victory_condition"] then
        Tracker:FindObjectForCode("goal").CurrentStage = tonumber(slot_data["victory_condition"])
    end
end
-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
        return
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber

    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    for _, innertable in pairs(v) do
    if not innertable then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", innertable[1], innertable[2]))
    end
    if not innertable[1] then
        return
    end
        local obj = Tracker:FindObjectForCode(innertable[1])
        if obj then
            if innertable[2] == "toggle" then
                obj.Active = true
            elseif innertable[2] == "progressive" then
                if obj.Active then
                    obj.CurrentStage = obj.CurrentStage + 1
                else
                    obj.Active = true
                end
            elseif innertable[2] == "consumable" then
                obj.AcquiredCount = obj.AcquiredCount + obj.Increment
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onItem: unknown item type %s for code %s", innertable[2], innertable[1]))
            end
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find object for code %s", innertable[1]))
        end
        -- track local items via snes interface
        if is_local then
            if LOCAL_ITEMS[innertable[1]] then
                LOCAL_ITEMS[innertable[1]] = LOCAL_ITEMS[innertable[1]] + 1
            else
                LOCAL_ITEMS[innertable[1]] = 1
            end
        else
            if GLOBAL_ITEMS[innertable[1]] then
                GLOBAL_ITEMS[innertable[1]] = GLOBAL_ITEMS[innertable[1]] + 1
            else
                GLOBAL_ITEMS[innertable[1]] = 1
            end
        end
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
            print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
        end
    end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
    local location_array = LOCATION_MAPPING[location_id]
    if not location_array or not location_array[1] then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end
    
    for _, location in pairs(location_array) do
        local obj = Tracker:FindObjectForCode(location)
        -- print(location, obj)
        if obj then

            if location:sub(1, 1) == "@" then
                obj.AvailableChestCount = obj.AvailableChestCount - 1
            else
                obj.Active = true
            end
        else
            print(string.format("onLocation: could not find object for code %s", location))
        end
    end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
    -- not implemented yet :(
end

-- called when a bounce message is received 
function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
    -- your code goes here
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
    Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
    Archipelago:AddLocationHandler("location handler", onLocation)
end
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
