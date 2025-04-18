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
function C9()
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
    has ("compep")
end
function A10()
    return
    has ("compa8") or has ("compb8") or has ("compc8")
end

function SUMMIT()
    return A7() and ((GOAL() and has("summit")) or SUMMITBVIS())
end

function EPILOGUE()
    return A7() 
end

function SUMMITB()
    return has("cassette7") and ((has("summit_b") and GOAL()) or SUMMITCVIS())
end

function SUMMITC()
    return C7() and ((has("summit_c") and GOAL()) or COREAVIS())
end

function CORE()
    return A9() and ((has("core") and GOAL()) or COREBVIS()) and ((COREAGATE() and has("gates_vanilla")) or has("gates_disabled"))
end

function COREB()
    return
    has ("cassette8") and ((has("core_b") and GOAL()) or CORECVIS()) and ((COREBGATE() and has("gates_vanilla")) or has("gates_disabled"))
end

function COREC()
    return
    C9() and ((has("core_c") and GOAL()) or has("farewell")) and ((CORECGATE() and has("gates_vanilla")) or has("gates_disabled"))
end

function FAREWELL()
    return A10() and GOAL() and ((FAREWELLGATE() and has("gates_vanilla")) or has("gates_disabled"))
end

function SUMMITBVIS()
    return has("summit_b") or has("summit_c") or has("core") or has("core_b") or has("core_c") or has("farewell")
end

function SUMMITCVIS()
    return has("summit_c") or has("core") or has("core_b") or has("core_c") or has("farewell")
end

function  COREAVIS()
    return has("core") or has("core_b") or has("core_c") or has("farewell")
end

function  COREBVIS()
    return has("core_b") or has("core_c") or has("farewell")
end

function  CORECVIS()
    return has("core_c") or has("farewell")
end

function BERRYREQ()
    return checkRequirements("berriesrequired", "berrytotal")
end

function HEARTREQ()
    return checkRequirements("heartsrequired", "hearttotal")
end

function CASSETTESREQ()
    return checkRequirements("cassettesrequired", "cassettestotal")
end

function COMPREQ()
    return checkRequirements("comprequired", "comptotal")
end

function GOAL()
    return
    has ("$BERRYREQ") and has ("$HEARTREQ") and has ("$COMPREQ") and has ("$CASSETTESREQ")
end
