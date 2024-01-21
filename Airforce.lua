-------------------------------------
-- CAP
-------------------------------------

-- TODO Seamless changes of Phases

local BluePhase1Airbase = AIRBASE.Sinai.Hatzor

local alt = math.floor(math.random(18000,30000)/1000)*1000
local bluecap = EASYGCICAP:New("Blue CAP",BluePhase1Airbase,"blue","Blue EWR")
bluecap:AddPatrolPointCAP(BluePhase1Airbase,ZONE:New("Blue CAP Zone 1"):GetCoordinate(),alt,300,90,40)
bluecap:AddSquadron("CAP M2000C","Vendee",BluePhase1Airbase,99,AI.Skill.EXCELLENT,102,"Cambresis")
bluecap:AddSquadron("CAP F1M","US F1M",BluePhase1Airbase,99,AI.Skill.EXCELLENT,202,"USA Company Skin 2 (M-EE)")
bluecap:AddSquadron("CAP F4E","US F4E",BluePhase1Airbase,99,AI.Skill.EXCELLENT,302,"VMFA-212 AC01 by Urbi")

bluecap:SetDefaultNumberAlter5Standby(0)
bluecap:SetDefaultEngageRange(50) --  50NM
bluecap:SetMaxAliveMissions(3)
bluecap:SetDefaultMissionRange(200)
bluecap.overhead = 0.5

local Blueborder = ZONE:FindByName("Blue Border")
bluecap:AddAcceptZone(Blueborder)

for i=1,4 do
  if i < CurrentPhase then
    bluecap:AddAcceptZone(PhaseBorderZones[i])
  else
    bluecap:AddRejectZone(PhaseBorderZones[i])
  end
end


local Zone11Airbase = AIRBASE.Sinai.Melez
local Zone12Airbase = AIRBASE.Sinai.Bir_Hasanah
local Zone21Airbase = AIRBASE.Sinai.Kibrit_Air_Base
local Zone22Airbase = AIRBASE.Sinai.As_Salihiyah
local AwacsAirbase = AIRBASE.Sinai.Cairo_International_Airport

local redcap = EASYGCICAP:New("Red CAP",Zone11Airbase,"red","RED EW")
redcap.overhead = 0.5
redcap:SetDefaultNumberAlter5Standby(0)
redcap:SetDefaultEngageRange(50) --  50NM
redcap:SetDefaultCAPGrouping(1)
redcap:SetMaxAliveMissions(6)
redcap:SetDefaultMissionRange(200)
redcap:SetCapStartTimeVariation(300,900) -- 5 to 15 min

local Skills = {
  [1] = AI.Skill.HIGH,
  [2] = AI.Skill.AVERAGE,
  [3] = AI.Skill.EXCELLENT,
  [5] = AI.Skill.EXCELLENT,
  [6] = AI.Skill.HIGH,
  [7] = AI.Skill.GOOD,
  [8] = AI.Skill.GOOD,
  [9] = AI.Skill.GOOD,
  [10] = AI.Skill.AVERAGE,
}

-- ZONE 1

local alt = math.floor(math.random(18000,30000)/1000)*1000
redcap:AddPatrolPointCAP(Zone11Airbase,ZONE:New("RED CAP Point 1-1"):GetCoordinate(),alt,300,320,40)
redcap:AddSquadron("RCAP MIG29a","Domna",Zone11Airbase,99,Skills[math.random(1,10)],102,"Domna 120th AR")
redcap:AddSquadron("RCAP MIG21","Egypt21",Zone11Airbase,99,Skills[math.random(1,10)],202,"Egypt - Tan 1982")
redcap:AddSquadron("RCAP MIG23","Egypt23",Zone11Airbase,99,Skills[math.random(1,10)],302,"af standard-2")
redcap:AddSquadron("RCAP MIG25","Egypt25",Zone11Airbase,99,Skills[math.random(1,10)],402,"af standard")

redcap:AddAirwing(Zone12Airbase,"Bir Hasanah AFB")
redcap:AddPatrolPointCAP(Zone12Airbase,ZONE:New("RED CAP Point 1-2"):GetCoordinate(),Altitude,300,0,40)
redcap:AddSquadron("RCAP MIG31","GDR31",Zone12Airbase,99,Skills[math.random(1,10)],502,"174 GvIAP_Boris Safonov")
redcap:AddSquadron("RCAP SU27","SU27",Zone12Airbase,99,Skills[math.random(1,10)],602,Livery)
redcap:AddSquadron("RCAP MIG25","Hotilovo",Zone12Airbase,99,Skills[math.random(1,10)],702,"af standard")
redcap:AddSquadron("RCAP F14A","Iran",Zone12Airbase,99,Skills[math.random(1,10)],112)

-- ZONE 2

redcap:AddAirwing(AwacsAirbase,"Cairo International")
redcap:AddPatrolPointAwacs(AwacsAirbase,ZONE:FindByName("Red Awacs Point"):GetCoordinate(),25000,300,180,80)
redcap:AddAWACSSquadron("RED AWACS","RED AWACS",AwacsAirbase,99,AI.Skill.EXCELLENT,802,Livery,251,radio.modulation.AM)
redcap:SetTankerAndAWACSInvisible(true)

local alt = math.floor(math.random(18000,30000)/1000)*1000
redcap:AddAirwing(Zone21Airbase,"Kibrit AFB")
redcap:AddPatrolPointCAP(Zone21Airbase,ZONE:New("RED CAP Point 2-2"):GetCoordinate(),alt,300,86,60)
redcap:AddSquadron("RCAP MIG29s","Domna Melez",Zone21Airbase,99,Skills[math.random(1,10)],122,"Belarusian Air Force")
redcap:AddSquadron("RCAP MIG21","Egypt21 Melez",Zone21Airbase,99,Skills[math.random(1,10)],222,"Iraq - 9th Sqn")
redcap:AddSquadron("RCAP MIG23","Egypt23 Melez",Zone21Airbase,99,Skills[math.random(1,10)],322,"af standard-1")
redcap:AddSquadron("RCAP MIG25","Egypt25 Melez",Zone21Airbase,99,Skills[math.random(1,10)],422,"Algerian Air Force")

local alt = math.floor(math.random(18000,30000)/1000)*1000
redcap:AddAirwing(Zone22Airbase,"As Salihiyah AFB")
redcap:AddPatrolPointCAP(Zone22Airbase,ZONE:New("RED CAP Point 2-1"):GetCoordinate(),alt,300,66,60)
redcap:AddSquadron("RCAP MIG31","GDR31 BH",Zone22Airbase,99,Skills[math.random(1,10)],542,"903_White")
redcap:AddSquadron("RCAP SU27","SU27 BH",Zone22Airbase,99,Skills[math.random(1,10)],642,"Kazakhstan Air Defense Forces")
redcap:AddSquadron("RCAP MIG25","Hotilovo BH",Zone22Airbase,99,Skills[math.random(1,10)],742,"Algerian Air Force")
redcap:AddSquadron("RCAP SU30","Desert",Zone22Airbase,99,Skills[math.random(1,10)],842,"`desert` test paint scheme")

local Blueborder = ZONE:FindByName("Blue Border")
redcap:AddRejectZone(Blueborder)

for i=1,4 do
    redcap:AddAcceptZone(PhaseBorderZones[i])
end

-- Leichte Gegner:
-- RCAP MIG21
-- RCAP MIG23
-- RCAP MIG25

--Mittlere Gegner:
-- RCAP MIG31
-- RCAP MIG29a

-- Schwere Gegner:
-- RCAP MIG29s
-- RCAP SU27
-- RCAP SU30