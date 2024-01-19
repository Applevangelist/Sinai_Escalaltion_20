-------------------------------------
-- Autolase
-------------------------------------

local PlayerSet = SET_CLIENT:New():FilterActive(true):FilterCategories("plane"):FilterStart()

local RecceSet = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes("Pointer"):FilterStart()
local autolase = AUTOLASE:New(RecceSet,"blue","Pointer",PlayerSet)
autolase:SetMinThreatLevel(3)
autolase:SetMaxLasingTargets(1)
autolase:SetLaserCodes( { 1688, 1130, 4785, 6547, 1465, 4578 })
UTILS.GenerateLaserCodes()
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

MESSAGE.SetMSRS(mySRSPath,mySRSPort,mySRSGKey,{30,135,255},{radio.modulation.FM, radio.modulation.AM, radio.modulation.AM},Gender,Culture,MSRS.Voices.Google.Standard.en_AU_Standard_B,coalition.side.BLUE,1,"PNTR")
local lasttxt = timer.getAbsTime()
-- Event function
function operations:OnAfterMarkChanged(From,Event,To,Text,Keywords,Coord)
  Handler(Keywords,Coord)
  local accuracy = {}
  accuracy.MGRS_Accuracy = 3
  local coordtext = Coord:ToStringMGRS(accuracy)
  local text = string.format("Roger, pointer moving to %s!",coordtext)
  if timer.getAbsTime()-lasttxt > 10 then
    MESSAGE:New(text,15,"Pointer"):ToBlue():ToLog()--:ToSRSBlue()
    coordtext = string.gsub(coordtext,"MGRS.","")
    coordtext = string.gsub(coordtext,"%s",";")
    coordtext = string.gsub(coordtext,"(%a)","%1;")
    coordtext = string.gsub(coordtext,"(%d)","%1;")
    coordtext = string.gsub(coordtext,";;",";")
    text = string.format("Roger, pointer moving to MGRS %s!",coordtext)
    MESSAGE:New(text,15,"PNTR"):ToSRSBlue()
    lasttxt = timer.getAbsTime()
  end
end