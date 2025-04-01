-- from https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- dumps a table in a readable string
function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

function has_more_then_n_consumable(n)
    local count = Tracker:ProviderCountForCode('consumable')
    local val = (count > tonumber(n))
    if ENABLE_DEBUG_LOG then
        print(string.format("called has_more_then_n_consumable: count: %s, n: %s, val: %s", count, n, val))
    end
    if val then
        return 1
    end
    return 0
end


function COREAGATE()
    local HeartTotal = Tracker:FindObjectForCode("hearttotal").AcquiredCount
    return HeartTotal >= 4
end

function COREBGATE()
    local HeartTotal = Tracker:FindObjectForCode("hearttotal").AcquiredCount
    return HeartTotal >= 15
end

function CORECGATE()
    local HeartTotal = Tracker:FindObjectForCode("hearttotal").AcquiredCount
    return HeartTotal >= 23
end

function FAREWELLGATE()
    local HeartTotal = Tracker:FindObjectForCode("hearttotal").AcquiredCount
    return HeartTotal >= 15
end

function checkRequirements(reference, check_count)
    local reqCount = Tracker:ProviderCountForCode(reference)
    local count = Tracker:ProviderCountForCode(check_count)

    if count >= reqCount then
        return 1
    else
        return 0
    end
end

function has(item, amount)
    local count = Tracker:ProviderCountForCode(item)
    if not amount then
        return count > 0
    else
        amount = tonumber(amount)
        return count >= amount
    end
end

function HEART(hearttotal, count)
    if Tracker:FindObjectForCode(hearttotal).AcquiredCount >= tonumber(count) then
        return true
    else
        return false
    end
end

function GATESWITCH()
    if Tracker:FindObjectForCode("gateshidden").CurrentStage == 1 then 
        print("hi")
        Tracker:FindObjectForCode("gates").CurrentStage = 0
    elseif Tracker:FindObjectForCode("gateshidden").CurrentStage == 0 then 
        print("bye")
        Tracker:FindObjectForCode("gates").CurrentStage = 1
    end
end


ScriptHost:AddWatchForCode("gates handler", "gateshidden", GATESWITCH)