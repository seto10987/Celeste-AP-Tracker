function has(item, amount)
  local count = Tracker:ProviderCountForCode(item)
  amount = tonumber(amount)
  if not amount then
    return count > 0
  else
    return count == amount
  end
end
 
function C1()
    return
    has ("hearta1") and has ("heartb1")
end
function C2()
    return
    has ("hearta2") and has ("heartb2")
end
function C3()
    return
    has ("hearta3") and has ("heartb3")
end
function C4()
    return
    has ("hearta4") and has ("heartb4")
end
function C5()
    return
    has ("hearta5") and has ("heartb5")
end
function C6()
    return
    has ("hearta6") and has ("heartb6")
end
function C7()
    return
    has ("hearta7") and has ("heartb7")
end
function C8()
    return
    has ("hearta8") and has ("heartb8")
end
function A2()
    return
    has ("compa1") or has ("compb1") or has ("compc1")
end
function A3()
    return
    has ("compa2") or has ("compb2") or has ("compc2")
end
function A4()
    return
    has ("compa3") or has ("compb3") or has ("compc3")
end
function A5()
    return
    has ("compa4") or has ("compb4") or has ("compc4")
end
function A6()
    return
    has ("compa5") or has ("compb5") or has ("compc5")
end
function A7()
    return
    has ("compa6") or has ("compb6") or has ("compc6")
end
function A8()
    return
    has ("compa7") or has ("compb7") or has ("compc7")
end
function A9()
    return
    has ("compa8") or has ("compb8") or has ("compc8")
end
function SUMMIT()
    return
    has ("core") or has ("farewell")
end
function CORE()
    return
    has ("summit") or has ("farewell")
end
function FAREWELL()
    return
    has ("summit") or has ("core")
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
function BERRYREQ()
    return checkRequirements("berryreq", "berryttl")
end
function HEARTREQ()
    return checkRequirements("heartreq", "heartttl")
end
function CASSETTESREQ()
    return checkRequirements("cassettesreq", "cassettesttl")
end
function COMPREQ()
    return checkRequirements("compreq", "compttl")
end
function GOAL()
    return
    has ("$BERRYREQ") and has ("$HEARTREQ") and has ("$COMPREQ") and has ("$CASSETTESREQ")
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
function HEART(gemheart, count)
    if Tracker:FindObjectForCode(gemheart).AcquiredCount >= tonumber(count) then
        return true
    else
        return false
    end
end