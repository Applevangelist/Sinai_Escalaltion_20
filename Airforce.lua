-------------------------------------
-- CAP
-------------------------------------

local alt = math.floor(math.random(18000,30000)/1000)*1000
local bluecap = EASYGCICAP:New("Blue CAP",AIRBASE.Sinai.Hatzor,"blue","Blue EWR")
bluecap:AddPatrolPointCAP(AIRBASE.Sinai.Hatzor,ZONE:New("Blue CAP Zone 1"):GetCoordinate(),alt,300,90,40)
bluecap:AddSquadron("CAP M2000C","Vendee",AIRBASE.Sinai.Hatzor,99,AI.Skill.EXCELLENT,102,"Cambresis")
bluecap:AddSquadron("CAP F1M","US F1M",AIRBASE.Sinai.Hatzor,99,AI.Skill.EXCELLENT,102,"USA Company Skin 2 (M-EE)")
bluecap:SetDefaultNumberAlter5Standby(0)
bluecap:SetDefaultEngageRange(50) --  50NM
bluecap:SetMaxAliveMissions(3)
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


local redcap = EASYGCICAP:New("Red CAP",AIRBASE.Sinai.Ramon_Airbase,"red","RED EW")
redcap.overhead = 0.5
redcap:SetDefaultNumberAlter5Standby(0)
redcap:SetDefaultEngageRange(50) --  50NM
redcap:SetMaxAliveMissions(6)

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
redcap:AddPatrolPointCAP(AIRBASE.Sinai.Ramon_Airbase,ZONE:New("RED CAP Point 1-1"):GetCoordinate(),alt,300,320,40)
redcap:AddSquadron("RCAP MIG29a","Domna",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],102,"Domna 120th AR")
redcap:AddSquadron("RCAP MIG21","Egypt21",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],202,"Egypt - Tan 1982")
redcap:AddSquadron("RCAP MIG23","Egypt23",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],302,"af standard-2")
redcap:AddSquadron("RCAP MIG25","Egypt25",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],402,"af standard")

redcap:AddAirwing(AIRBASE.Sinai.Ovda,"Ovda AFB")
redcap:AddPatrolPointCAP(AIRBASE.Sinai.Ovda,ZONE:New("RED CAP Point 1-2"):GetCoordinate(),Altitude,300,0,40)
redcap:AddSquadron("RCAP MIG31","GDR31",AIRBASE.Sinai.Ovda,99,Skills[math.random(1,10)],502,"174 GvIAP_Boris Safonov")
redcap:AddSquadron("RCAP SU27","SU27",AIRBASE.Sinai.Ovda,99,Skills[math.random(1,10)],602,Livery)
redcap:AddSquadron("RCAP MIG25","Hotilovo",AIRBASE.Sinai.Ovda,99,Skills[math.random(1,10)],702,"af standard")

-- ZONE 2

redcap:AddAirwing(AIRBASE.Sinai.Melez,"Melez AFB")
redcap:AddPatrolPointAwacs(AIRBASE.Sinai.Melez,ZONE:FindByName("Red Awacs Point"):GetCoordinate(),25000,300,180,80)
redcap:AddAWACSSquadron("RED AWACS","RED AWACS",AIRBASE.Sinai.Melez,99,AI.Skill.EXCELLENT,802,Livery,251,radio.modulation.AM)
redcap:SetTankerAndAWACSInvisible(true)

local alt = math.floor(math.random(18000,30000)/1000)*1000
redcap:AddPatrolPointCAP(AIRBASE.Sinai.Melez,ZONE:New("RED CAP Point 2-2"):GetCoordinate(),alt,300,86,60)
redcap:AddSquadron("RCAP MIG29s","Domna Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],102,"Belarusian Air Force")
redcap:AddSquadron("RCAP MIG21","Egypt21 Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],202,"Iraq - 9th Sqn")
redcap:AddSquadron("RCAP MIG23","Egypt23 Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],302,"af standard-1")
redcap:AddSquadron("RCAP MIG25","Egypt25 Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],402,"Algerian Air Force")

local alt = math.floor(math.random(18000,30000)/1000)*1000
redcap:AddAirwing(AIRBASE.Sinai.Bir_Hasanah,"Bir Hasanah AFB")
redcap:AddPatrolPointCAP(AIRBASE.Sinai.Bir_Hasanah,ZONE:New("RED CAP Point 2-1"):GetCoordinate(),alt,300,66,60)
redcap:AddSquadron("RCAP MIG31","GDR31 BH",AIRBASE.Sinai.Bir_Hasanah,99,Skills[math.random(1,10)],502,"903_White")
redcap:AddSquadron("RCAP SU27","SU27 BH",AIRBASE.Sinai.Bir_Hasanah,99,Skills[math.random(1,10)],602,"Kazakhstan Air Defense Forces")
redcap:AddSquadron("RCAP MIG25","Hotilovo BH",AIRBASE.Sinai.Bir_Hasanah,99,Skills[math.random(1,10)],702,"Algerian Air Force")

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