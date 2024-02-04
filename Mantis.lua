-------------------------------------
-- MANTIS
-------------------------------------
local MantisDebug = false

local RedZoneSet = SET_ZONE:New():FilterPrefixes("Phase . Border"):FilterOnce()

local ScootZones = SET_ZONE:New():FilterPrefixes("Scoot"):FilterOnce()
local redmantis = MANTIS:New("Red Mantis","RED SAM","RED EW",hq,"red",dynamic,"RED AWACS",true)
redmantis:AddZones(PhaseBorderZones,{ZONE:New("Blue Border")},PhaseBorderZones)
redmantis:AddScootZones(ScootZones,4,true)
--redmantis:Debug(true)
redmantis:__Start(1)

local bluemantis = MANTIS:New("Blue Mantis","Blue SAM","Blue EWR",hq,"blue",dynamic,"Blue AWACS",true)
local conflictzones = {}
for i=1,CurrentPhase do
  table.insert(conflictzones,PhaseBorderZones[i])
end
bluemantis:AddZones({ZONE:New("Blue Border")},nil,conflictzones)
bluemantis:SetMaxActiveSAMs(2,2,1,6)
--bluemantis:SetSAMRange(100)
--bluemantis:Debug(MantisDebug)
bluemantis:__Start(2)

if MantisDebug then
  local test = SPAWN:New("Aerial-1"):Spawn()
end