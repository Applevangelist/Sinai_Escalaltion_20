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

-------------------------------------
-- Support Flights
-------------------------------------



local CAPMission = nil -- Ops.Auftrag#AUFTRAG
local CASMission = nil -- Ops.Auftrag#AUFTRAG
local SEADMission = nil -- Ops.Auftrag#AUFTRAG
local MissionHome = AIRBASE.Sinai.Tel_Nof
local ToT = 30*60 -- 30 minutes
local Flights = {}

AIRBASE:FindByName(MissionHome):SetParkingSpotWhitelist({73,74,75,76,77,78,79,80,81,82,83})

local airsupport = MARKEROPS_BASE:New("Air",{"cas","cap","sead","tot"},false)

local function GetFlightGroup(TemplateName,mission,IsCAP,IsCAS,IsSEAD)
  local FG -- Ops.FlightGroup#FLIGHTGROUP
  local plane = SPAWN:NewWithAlias(TemplateName,TemplateName.."-"..math.random(1,100000))
    :InitAirbase(MissionHome)
    :OnSpawnGroup(
      function(grp)
        FG = FLIGHTGROUP:New(grp)
        FG:SetDespawnAfterLanding()
        FG:SetHomebase(AIRBASE:FindByName(MissionHome))
        FG:SetDetection(true)
        FG:SetEngageDetectedOn()
        FG:SetFuelLowRTB(true)
        if IsCAP then
          FG:SetOutOfAAMRTB(true)
        elseif IsCAS or IsSEAD then
          FG:SetOutOfAGMRTB(true)
        end
        FG:AddMission(mission)
        table.insert(Flights,FG)
      end
    )
    :Spawn()
   return FG
end

---
-- @param #table Keywords
-- @param Core.Point#COORDINATE Coord
-- @param #string Text
local function AirHandler(Keywords,Coord,Text)
  local IsCAP, IsCAS, IsSEAD, HasTOT, TOT
  local found = false
  local mtype = "none"
  local templates = {
    ["CAP"] = "CAP Support",
    ["CAS"] = "CAS Support",
    ["SEAD"] = "SEAD Support",
  }
  local mission = nil -- Ops.Auftrag#AUFTRAG
  for _,_word in pairs (Keywords) do
    if string.lower(_word) == "cap" and (CAPMission == nil or (CAPMission and CAPMission:IsOver())) then
      IsCAP = true
      found = true
      mtype = "CAP"
      local ZoneCAP = ZONE_RADIUS:New("CAP Zone-"..math.random(1,10000),Coord:GetVec2(),UTILS.NMToMeters(12.5))
      mission = AUFTRAG:NewCAP(ZoneCAP,20000,350,Coord,0,12)
      CAPMission = mission
    elseif string.lower(_word) == "cas" and (CASMission == nil or (CASMission and CASMission:IsOver())) then
      IsCAS = true
      found = true
      mtype = "CAS"
      local ZoneCAS = ZONE_RADIUS:New("CAS Zone-"..math.random(1,10000),Coord:GetVec2(),UTILS.NMToMeters(7.5))
      mission = AUFTRAG:NewCASENHANCED(ZoneCAS,5000,300,10)
      CASMission = mission
    elseif string.lower(_word) == "sead" and (SEADMission == nil or (SEADMission and SEADMission:IsOver())) then
      IsSEAD = true
      found = true
      mtype = "SEAD"
      local ZoneCAS = ZONE_RADIUS:New("CAS Zone-"..math.random(1,10000),Coord:GetVec2(),UTILS.NMToMeters(7.5))
      mission = AUFTRAG:NewCASENHANCED(ZoneCAS,20000,300,10,nil,{"SAM","AAA"})
      SEADMission = mission
    end
    if string.lower(_word) == "tot" then
      HasTOT = true
      TOT = string.match(Text,"(%d+)")
      BASE:I("ToT = "..tostring(TOT))
      if TOT then ToT = tonumber(TOT)*60 end
    end
  end
  if found and mission then
    if HasTOT then
      mission:SetTime(5,ToT)
    end
    local FG = GetFlightGroup(templates[mtype],mission,IsCAP,IsCAS,IsSEAD) -- Ops.FlightGroup#FLIGHTGROUP
  end
  return found, mtype
end

function airsupport:OnAfterMarkChanged(From,Event,To,Text,Keywords,Coord,idx)
  local text = string.format("Copy, Pilot, checking flight availability!")
  MESSAGE:New(text,10,"ANVL"):ToLog():ToSRSBlue(frequency,modulation,gender,culture,MSRS.Voices.Google.Standard.en_AU_Standard_C)
  local okay, type = AirHandler(Keywords,Coord,Text)
  if okay then
    MESSAGE:New("Roger, Pilot, a "..type.." flight is on the way!",10,"ANVL"):ToLog():ToBlue():ToSRSBlue(frequency,modulation,gender,culture,MSRS.Voices.Google.Standard.en_AU_Standard_C)
  else
    MESSAGE:New("Negative, Pilot, all flights are booked!",10,"ANVL"):ToLog():ToBlue():ToSRSBlue(frequency,modulation,gender,culture,MSRS.Voices.Google.Standard.en_AU_Standard_C)
  end
end

