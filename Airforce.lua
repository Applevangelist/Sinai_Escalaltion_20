-------------------------------------
-- CAP
-------------------------------------

local bluecap = EASYGCICAP:New("Blue CAP",AIRBASE.Sinai.Hatzor,"blue","Blue EWR")
bluecap:AddPatrolPointCAP(AIRBASE.Sinai.Hatzor,ZONE:New("Blue CAP Zone 1"):GetCoordinate(),Altitude,Speed,90,40)
bluecap:AddSquadron("CAP M2000C","Vendee",AIRBASE.Sinai.Hatzor,99,AI.Skill.EXCELLENT,102,Livery)
bluecap:AddSquadron("CAP F1M","US F1M",AIRBASE.Sinai.Hatzor,99,AI.Skill.EXCELLENT,102,Livery)
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

redcap:AddPatrolPointCAP(AIRBASE.Sinai.Ramon_Airbase,ZONE:New("RED CAP Point 1-1"):GetCoordinate(),Altitude,Speed,320,40)
redcap:AddSquadron("RCAP MIG29a","Domna",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],102,Livery)
redcap:AddSquadron("RCAP MIG21","Egypt21",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],202,Livery)
redcap:AddSquadron("RCAP MIG23","Egypt23",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],302,Livery)
redcap:AddSquadron("RCAP MIG25","Egypt25",AIRBASE.Sinai.Ramon_Airbase,99,Skills[math.random(1,10)],402,Livery)

redcap:AddAirwing(AIRBASE.Sinai.Ovda,"Ovda AFB")
redcap:AddPatrolPointCAP(AIRBASE.Sinai.Ovda,ZONE:New("RED CAP Point 1-2"):GetCoordinate(),Altitude,Speed,0,40)
redcap:AddSquadron("RCAP MIG31","GDR31",AIRBASE.Sinai.Ovda,99,Skills[math.random(1,10)],502,Livery)
redcap:AddSquadron("RCAP SU27","SU27",AIRBASE.Sinai.Ovda,99,Skills[math.random(1,10)],602,Livery)
redcap:AddSquadron("RCAP MIG25","Hotilovo",AIRBASE.Sinai.Ovda,99,Skills[math.random(1,10)],702,Livery)

-- ZONE 2

redcap:AddAirwing(AIRBASE.Sinai.Melez,"Melez AFB")
redcap:AddPatrolPointAwacs(AIRBASE.Sinai.Melez,ZONE:FindByName("Red Awacs Point"):GetCoordinate(),Altitude,Speed,180,80)
redcap:AddAWACSSquadron("RED AWACS","RED AWACS",AIRBASE.Sinai.Melez,99,AI.Skill.EXCELLENT,802,Livery,251,radio.modulation.AM)
redcap:SetTankerAndAWACSInvisible(true)

redcap:AddPatrolPointCAP(AIRBASE.Sinai.Melez,ZONE:New("RED CAP Point 2-2"):GetCoordinate(),Altitude,Speed,86,60)
redcap:AddSquadron("RCAP MIG29a","Domna Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],102,Livery)
redcap:AddSquadron("RCAP MIG21","Egypt21 Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],202,Livery)
redcap:AddSquadron("RCAP MIG23","Egypt23 Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],302,Livery)
redcap:AddSquadron("RCAP MIG25","Egypt25 Melez",AIRBASE.Sinai.Melez,99,Skills[math.random(1,10)],402,Livery)

redcap:AddAirwing(AIRBASE.Sinai.Bir_Hasanah,"Bir Hasanah AFB")
redcap:AddPatrolPointCAP(AIRBASE.Sinai.Bir_Hasanah,ZONE:New("RED CAP Point 2-1"):GetCoordinate(),Altitude,Speed,66,60)
redcap:AddSquadron("RCAP MIG31","GDR31 BH",AIRBASE.Sinai.Bir_Hasanah,99,Skills[math.random(1,10)],502,Livery)
redcap:AddSquadron("RCAP SU27","SU27 BH",AIRBASE.Sinai.Bir_Hasanah,99,Skills[math.random(1,10)],602,Livery)
redcap:AddSquadron("RCAP MIG25","Hotilovo BH",AIRBASE.Sinai.Bir_Hasanah,99,Skills[math.random(1,10)],702,Livery)

local Blueborder = ZONE:FindByName("Blue Border")
redcap:AddRejectZone(Blueborder)

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