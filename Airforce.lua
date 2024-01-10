-------------------------------------
-- CAP
-------------------------------------

local bluecap = EASYGCICAP:New("Blue CAP",AIRBASE.Sinai.Hatzor,"blue","Blue EWR")
bluecap:AddPatrolPointCAP(AIRBASE.Sinai.Hatzor,ZONE:New("Blue CAP Zone 1"):GetCoordinate(),Altitude,Speed,90,40)
bluecap:AddSquadron("CAP M2000C","Vendee",AIRBASE.Sinai.Hatzor,99,AI.Skill.EXCELLENT,102,Livery)
bluecap:AddSquadron("CAP F1M","US F1M",AIRBASE.Sinai.Hatzor,99,AI.Skill.EXCELLENT,102,Livery)
bluecap:SetDefaultNumberAlter5Standby(5)

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

redcap:SetDefaultNumberAlter5Standby(6)

redcap:AddPatrolPointCAP(AIRBASE.Sinai.Ramon_Airbase,ZONE:New("RED CAP Point 1"):GetCoordinate(),Altitude,Speed,320,50)
redcap:AddSquadron("RCAP MIG29","Domna",AIRBASE.Sinai.Ramon_Airbase,99,AI.Skill.EXCELLENT,102,Livery)
redcap:AddSquadron("RCAP JF17","Besovets",AIRBASE.Sinai.Ramon_Airbase,99,AI.Skill.EXCELLENT,202,Livery)

redcap:AddAirwing(AIRBASE.Sinai.Melez,"Melez AFB")
redcap:AddPatrolPointCAP(AIRBASE.Sinai.Melez,ZONE:New("RED CAP Point 2"):GetCoordinate(),Altitude,Speed,0,60)
redcap:AddSquadron("RCAP MIG29a","GDR",AIRBASE.Sinai.Melez,99,AI.Skill.EXCELLENT,302,Livery)
redcap:AddSquadron("RCAP SU27a","Hotilovo",AIRBASE.Sinai.Melez,99,AI.Skill.EXCELLENT,402,Livery)

redcap:AddPatrolPointAwacs(AIRBASE.Sinai.Melez,ZONE:FindByName("Red Awacs Point"):GetCoordinate(),Altitude,Speed,180,80)
redcap:AddAWACSSquadron("RED AWACS","RED AWACS",AIRBASE.Sinai.Melez,99,AI.Skill.EXCELLENT,402,Livery,251,radio.modulation.AM)
redcap:SetTankerAndAWACSInvisible(true)

local Blueborder = ZONE:FindByName("Blue Border")
redcap:AddRejectZone(Blueborder)
  