ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/tab_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/hints_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)

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
    print("hello")

    PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

    if slot_data["berries_required"] ~= 0 then
        Tracker:FindObjectForCode("berriesrequired").AcquiredCount = tonumber(slot_data["berries_required"])
    end
    if slot_data["hearts_required"] ~= 0 then
        Tracker:FindObjectForCode("heartsrequired").AcquiredCount = tonumber(slot_data["hearts_required"])
    end
    if slot_data["cassettes_required"] ~= 0 then
        Tracker:FindObjectForCode("cassettesrequired").AcquiredCount = tonumber(slot_data["cassettes_required"])
    end
    if slot_data["levels_required"] ~= 0 then
        Tracker:FindObjectForCode("comprequired").AcquiredCount = tonumber(slot_data["levels_required"])
    end
    if slot_data["goal_level"] then
        Tracker:FindObjectForCode("goal").CurrentStage = tonumber(slot_data["goal_level"])
    end
    if slot_data["disable_heart_gates"] then
        Tracker:FindObjectForCode("gateshidden").CurrentStage = tonumber(slot_data["disable_heart_gates"])
    end

    if Archipelago.PlayerNumber > -1 then
    
        HINTS_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_ID
        print(string.format("hints table dump: %s", dump_table(HINTS_ID)))
    
        Archipelago:SetNotify({HINTS_ID})
        Archipelago:Get({HINTS_ID})
    end
end

function onItem(index, item_id, item_name, player_number)
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
    end
end

function onLocation(location_id, location_name)
    local location_array = LOCATION_MAPPING[location_id]
    if not location_array or not location_array[1] then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end

    for _, location in pairs(location_array) do
        local obj = Tracker:FindObjectForCode(location)
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

function onNotify(key, value, old_value)

    if value ~= old_value and key == HINTS_ID then
        for _, hint in ipairs(value) do
            if hint.finding_player == Archipelago.PlayerNumber then
                if not hint.found then
                    updateHints(hint.location)
                else if hint.found then
                    updateHintsClear(hint.location)
                    end
                end
            end
        end
    end
end

function onNotifyLaunch(key, value)
    if key == HINTS_ID then
        for _, hint in ipairs(value) do
            if hint.finding_player == Archipelago.PlayerNumber then
                if not hint.found then
                    updateHints(hint.location)
                elseif hint.found then
                    updateHintsClear(hint.location)
                    
                end
            end
        end
    end
end

function updateHints(locationID)
    local item_codes = HINTS_MAPPING[locationID]

    for _, item_code in ipairs(item_codes) do
        local obj = Tracker:FindObjectForCode(item_code)
        if obj then
            obj.Active = true
        else
            print(string.format("No object found for code: %s", item_code))
        end
    end
end
 
function updateHintsClear(locationID)
    local item_codes = HINTS_MAPPING[locationID]

    for _, item_code in ipairs(item_codes) do
        local obj = Tracker:FindObjectForCode(item_code)
        if obj then
            obj.Active = false
        else
            print(string.format("No object found for code: %s", item_code))
        end
    end
end

function onScout(location_id, location_name, item_id, item_name, item_player)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
            item_player))
    end
end

function onBounce(json)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onBounce: %s", dump_table(json)))
    end
end

function parseCelestePlayState(value)
    local is_overworld, level, side, room = string.format(value:match("^(%d);(%d+);(%d+);(.+)$"))
    is_overworld = tonumber(is_overworld)
    level = tonumber(level)
    side = tonumber(side)
    return is_overworld, level, side, room
end

function updateTabs(value)
    if value ~= nil then
        print("celeste_play_state isn't nil!!")
        print(string.format("Raw celeste_play_state: %s", value))
        local is_overworld, level, side, room = parseCelestePlayState(value)

        print(string.format("Parsed CelestePlayState - IsOverworld: %d, Level: %d, Side: %d, Room: %s", is_overworld, level, side, room))

        local tabswitch = Tracker:FindObjectForCode("tab_switch")
        Tracker:FindObjectForCode("cur_level_id").CurrentStage = level

        if tabswitch.Active then
            if celeste_play_state ~= lastRoomID then
                local key = string.format("%d;%d;%d;%s", is_overworld, level, side, room)
                if TAB_MAPPING[key] then
                    local roomTabs = {}
                    for str in string.gmatch(TAB_MAPPING[key], "([^/]+)") do
                        table.insert(roomTabs, str)
                    end
                    if #roomTabs > 0 then
                        for _, tab in ipairs(roomTabs) do
                            print(string.format("Updating ID %s to Tab %s", key, tab))
                            Tracker:UiHint("ActivateTab", tab)
                        end
                        lastRoomID = celeste_play_state
                    else
                        print(string.format("Failed to find tabs for ID %s", key))
                    end
                else
                    print(string.format("Failed to find Tab ID %s", key))
                end
            end
        end
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
