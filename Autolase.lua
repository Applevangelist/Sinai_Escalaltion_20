-------------------------------------
-- Autolase
-------------------------------------

local PlayerSet = SET_CLIENT:New():FilterActive(true):FilterCategories("plane"):FilterStart()

local RecceSet = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes("Pointer"):FilterStart()
local autolase = AUTOLASE:New(RecceSet,"blue","Pointer",PlayerSet)
autolase:SetMinThreatLevel(3)
autolase:SetMaxLasingTargets(1)
autolase:SetLaserCodes( { 1688, 1130, 4785, 6547, 1465, 4578 })

local FlightGroup -- Ops.FlightGroup#FLIGHTGROUP

-- Add a lasing drone 
local drone = SPAWN:NewWithAlias("Reaper","Pointer")
:OnSpawnGroup(
  function(grp)
    grp:CommandSetUnlimitedFuel(true)
    grp:SetCommandImmortal(true)
    grp:SetCommandInvisible(true)
    FlightGroup = FLIGHTGROUP:New(grp)
    FlightGroup:SetDefaultImmortal(true)
    FlightGroup:SetDefaultInvisible(true)
    local uname = grp:GetUnit(1):GetName()
    autolase:SetRecceLaserCode(uname,1688)
    local orbit = AUFTRAG:NewORBIT_CIRCLE(ZONE:New("XV96"):GetCoordinate(),15000,150)
  end
)
:SpawnFromCoordinate(ZONE:New("XV96"):GetCoordinate(UTILS.FeetToMeters(12000)))

local operations = MARKEROPS_BASE:New("Pointer",{"orbit"},false)

local OrbitAuftrag

-- Handler function
local function Handler(Keywords,Coord)

  local NewOrbit = false
  for _,_word in pairs (Keywords) do
    if string.lower(_word) == "orbit" then
      NewOrbit = true
    end
  end
  
  if NewOrbit == true then
    if FlightGroup then
      FlightGroup:CancelAllMissions()
      local orbit = AUFTRAG:NewORBIT_CIRCLE(Coord,15000,150)
      orbit:SetMissionRange(400)
      FlightGroup:AddMission(orbit)
      NewOrbit = false
    end
  end
end

-- Event function
function operations:OnAfterMarkChanged(From,Event,To,Text,Keywords,Coord)
  Handler(Keywords,Coord)
end