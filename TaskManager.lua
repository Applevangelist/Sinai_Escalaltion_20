-------------------------------------
-- GCI
-------------------------------------


local anvil = PLAYERTASKCONTROLLER:New("Anvil",coalition.side.BLUE,PLAYERTASKCONTROLLER.Type.A2GS)
anvil:SetMenuName("Anvil")
anvil:SetMenuOptions(true)
anvil:SetSRS({135,255},{radio.modulation.AM, radio.modulation.AM},mySRSPath,nil,nil,mySRSPort,MSRS.Voices.Google.Standard.en_GB_Standard_D,1,mySRSGKey,nil,AIRBASE:FindByName(AIRBASE.Sinai.Tel_Nof):GetCoordinate())
anvil:SetSRSBroadcast(243,radio.modulation.AM)
anvil:SetCallSignOptions(true,false)
anvil:SetEnableIlluminateTask()
anvil:SetTransmitOnlyWithPlayers(true)
anvil:SetEnableUseTypeNames()
anvil:EnableTaskInfoMenu()

-- General Zone Target

local zonetarget = PhaseBorderZones[CurrentPhase]
local zoneset = SET_GROUP:New():FilterZones({zonetarget}):FilterCategoryGround():FilterCoalitions("red"):FilterOnce()
local ztarget = TARGET:New(zoneset)
local zonetask = PLAYERTASK:New(AUFTRAG.Type.BAI,ztarget,true,99,"Neutralize all REDFOR units in "..PhaseBorderNames[CurrentPhase].." Zone!")
zonetask:SetMenuName("Conquer zone")
zonetask:AddFreetext("Neutralize all REDFOR units in "..PhaseBorderNames[CurrentPhase].." Zone!")
zonetask:AddConditionSuccess(
  function(set)
    local Set = set -- Core.Set#SET_GROUP
    if Set:CountAlive() == 0 then
      return true
    else
      return false
    end
  end,
  zoneset
  )
anvil:AddPlayerTaskToQueue(zonetask)

-- Airbase targets

for _,_name in pairs(PhaseAirbases[CurrentPhase]) do
  local AB = AIRBASE:FindByName(_name)
  if AB:GetCoalition() ~= coalition.side.BLUE then
    local target = TARGET:New(AB)
    local task = PLAYERTASK:New(AUFTRAG.Type.CAS,target,true,99,"Conquer airbase ".._name.."!")
    task:SetMenuName("Conquer ".._name)
    task:AddFreetext("Conquer and fortify airbase ".._name..".")
    task:AddConditionSuccess(
      function(ab)
        local afb = ab -- Wrapper.Airbase#AIRBASE
        if afb:GetCoalition() == coalition.side.BLUE then
          return true
        else
          return false
        end
      end, AB
    )
    anvil:AddPlayerTaskToQueue(task)
  end
end

-- Single Ground Targets, groups, ships and statics

zoneset:ForEachGroup(
  function(grp)
    if grp and grp:IsAlive() then
      BASE:I("***** Adding target "..grp:GetName().." *****")
      anvil:AddTarget(grp)
    end
  end
)

local shipset = SET_GROUP:New():FilterCategoryShip():FilterCoalitions("red"):FilterZones({zonetarget}):FilterOnce()
shipset:ForEach(
  function(grp)
    if grp and grp:IsAlive() then
      BASE:I("***** Adding target "..grp:GetName().." *****")
      anvil:AddTarget(grp)
    end
  end
)


local StatSet = SET_STATIC:New():FilterCoalitions("red"):FilterZones({zonetarget}):FilterOnce()
StatSet:ForEach(
  function(grp)
    if grp and grp:IsAlive() then
      BASE:I("***** Adding target "..grp:GetName().." *****")
      anvil:AddTarget(grp)
    end
  end
)

-- Special tasks
if CurrentPhase == 1 then
  local TgtSetOne = SET_ZONE:New():FilterPrefixes("army_fuel_tank"):FilterOnce()
  local scensetone = SET_SCENERY:New(TgtSetOne)
  local ScenTask = PLAYERTASK:New(AUFTRAG.Type.PRECISIONBOMBING,TARGET:New(scensetone),true,99,"Destroy the fuel tanks at Nevatim Airbase!")
  ScenTask:SetMenuName("Bomb Fuel Tanks")
  ScenTask:AddFreetext("Destroy the fuel tanks at Nevatim Airbase!")
  ScenTask:AddFreetextTTS(("Destroy the fuel tanks at Nevatim Airbase!"))
  anvil:AddPlayerTaskToQueue(ScenTask)
  
  local TgtSettwo = SET_ZONE:New():FilterPrefixes("gaza"):FilterOnce()
  local scensettwo = SET_SCENERY:New(TgtSettwo)
  local ScenTask2 = PLAYERTASK:New(AUFTRAG.Type.PRECISIONBOMBING,TARGET:New(scensettwo),true,99,"Destroy the weapon factory in Gaza!")
  ScenTask2:SetMenuName("Bomb Factory")
  ScenTask2:AddFreetext("Destroy the weapon factory in Gaza!")
  ScenTask2:AddFreetextTTS(("Destroy the weapon factory in Gaza!"))
  anvil:AddPlayerTaskToQueue(ScenTask2)
end
