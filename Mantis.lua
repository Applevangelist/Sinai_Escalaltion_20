-------------------------------------
-- MANTIS
-------------------------------------

local RedZoneSet = SET_ZONE:New():FilterPrefixes("Phase . Border"):FilterOnce()

local redmantis = MANTIS:New("Red Mantis","RED SAM","RED EWR",hq,"red",dynamic,"RED_AWACS",true)
redmantis:AddZones(RedZoneSet.Set,{ZONE:New("Blue Border")})
redmantis:__Start(1)

local bluemantis = MANTIS:New("Blue Mantis","Blue SAM","Blue EWR",hq,"blue",dynamic,"BLUE AWACS",true)
bluemantis:AddZones({ZONE:New("Blue Border")},nil,RedZoneSet.Set)
bluemantis:__Start(2)