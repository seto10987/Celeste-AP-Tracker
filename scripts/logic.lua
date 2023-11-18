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
    has ("compa1") and has ("compb1")
end
function C2()
    return
    has ("compa2") and has ("compb2")
end
function C3()
    return
    has ("compa3") and has ("compb3")
end
function C4()
    return
    has ("compa4") and has ("compb4")
end
function C5()
    return
    has ("compa5") and has ("compb5")
end
function C6()
    return
    has ("compa6") and has ("compb6")
end
function C7()
    return
    has ("compa7") and has ("compb7")
end
function C8()
    return
    has ("compa8") and has ("compb8")
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
function GOAL()
    return
    has ("berryreq") and has ("heartreq") and has ("compreq") and has ("cassettesreq")
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

function beforeGoal(level)
    return victoryCondition > toNumber(level)
  end