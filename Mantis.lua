-------------------------------------
-- MANTIS
-------------------------------------

local RedZoneSet = SET_ZONE:New():FilterPrefixes("Phase . Border"):FilterOnce()

local ScootZones = SET_ZONE:New():FilterPrefixes("Scoot"):FilterOnce()
local redmantis = MANTIS:New("Red Mantis","RED SAM","RED EW",hq,"red",dynamic,"RED AWACS",true)
redmantis:AddZones(PhaseBorderZones,{ZONE:New("Blue Border")},PhaseBorderZones)
redmantis:AddScootZones(ScootZones,4,true)
--redmantis:Debug(true)
redmantis:__Start(1)

local bluemantis = MANTIS:New("Blue Mantis","Blue SAM","Blue EWR",hq,"blue",dynamic,"BLUE AWACS",true)
bluemantis:AddZones({ZONE:New("Blue Border")})
bluemantis:SetMaxActiveSAMs(2,2,2,6)
bluemantis:__Start(2)
