-------------------------------------
-- PLAYERTASKCONTROLLER
-------------------------------------
-- assert(loadfile("C:\\Users\\post\\Saved Games\\DCS\\Missions\\Sinai\\Escalation\\TaskManager.lua"))()


local debug = true 

local anvil = PLAYERTASKCONTROLLER:New("Anvil",coalition.side.BLUE,PLAYERTASKCONTROLLER.Type.A2GS)
anvil:SetMenuName("Anvil")
anvil:SetMenuOptions(true)
anvil:SetSRS({30,135,255},{radio.modulation.FM, radio.modulation.AM, radio.modulation.AM},mySRSPath,nil,nil,mySRSPort,MSRS.Voices.Google.Standard.en_GB_Standard_D,1,mySRSGKey,nil,AIRBASE:FindByName(AIRBASE.Sinai.Tel_Nof):GetCoordinate())
anvil:SetSRSBroadcast(243,radio.modulation.AM)
anvil:SetCallSignOptions(true,true)
anvil:SetEnableIlluminateTask()
anvil:SetTransmitOnlyWithPlayers(true)
anvil:SetEnableUseTypeNames()
anvil:SetAllowFlashDirection(true)
anvil:EnableTaskInfoMenu()

-- Add a lasing drone for precision bombing tasks
local drone = SPAWN:New("Reaper")
:OnSpawnGroup(
  function(grp)
    grp:CommandSetUnlimitedFuel(true)
    grp:SetCommandImmortal(true)
    grp:SetCommandInvisible(true)
    local FlightGroup = FLIGHTGROUP:New(grp)
    FlightGroup:SetDefaultImmortal(true)
    FlightGroup:SetDefaultInvisible(true)
    --local mission = AUFTRAG:NewORBIT(ZONE:New("Rahat"):GetCoordinate(),10000,150,306,10)
    --FlightGroup:AddMission(mission)
    anvil:EnablePrecisionBombing(FlightGroup,1688,ZONE:New("Rahat"):GetCoordinate())
  end
)
:SpawnFromCoordinate(ZONE:New("Rahat"):GetCoordinate(UTILS.FeetToMeters(12000)))


-- General Zone Target

local zonetarget = PhaseBorderZones[CurrentPhase]
local zoneset = SET_GROUP:New():FilterZones({zonetarget}):FilterCategoryGround():FilterCoalitions("red"):FilterOnce()
local ztarget = TARGET:New(zoneset)
local zonetask = PLAYERTASK:New(AUFTRAG.Type.BAI,ztarget,true,99,"Neutralize all REDFOR units in "..PhaseBorderNames[CurrentPhase].." Zone!")
zonetask:SetMenuName("Phase Objective")
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

function zonetask:OnAfterSuccess(From,Event,To)
  if CurrentPhase and CurrentPhase < 4 then
    MESSAGE:New("Well done! We have won this phase!",30,"Eisenhower",true):ToAll():ToLog()
    CurrentPhase = CurrentPhase + 1
  else
    MESSAGE:New("Well done! We have won the war!",30,"Eisenhower",true):ToAll():ToLog()
  end
end

-- Airbase targets

for _,_name in pairs(PhaseAirbases[CurrentPhase]) do
  local AB = AIRBASE:FindByName(_name)
  if AB:GetCoalition() ~= coalition.side.BLUE then
    local target = TARGET:New(AB)
    local task = PLAYERTASK:New(AUFTRAG.Type.CAS,target,true,99,"Conquer airbase ".._name.."!")
    task:SetMenuName("Conquer ".._name)
    task:AddFreetext("Conquer airbase ".._name..".")
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

for _,_name in pairs(PhaseAirbases[CurrentPhase]) do
  local AB = AIRBASE:FindByName(_name) -- Wrapper.Airbase#AIRBASE
  if AB:GetCoalition() ~= coalition.side.BLUE then
    local target = AB:GetZone()
    local task = PLAYERTASK:New(AUFTRAG.Type.CTLD,target,true,99,"Fortify airbase ".._name.."!")
    task:SetMenuName("Fortify ".._name)
    task:AddFreetext("Fortify airbase ".._name..". Transport and build a Linebacker in the airbase zone!")
    task:AddConditionSuccess(
      function(ab)
        local afb = ab -- Wrapper.Airbase#AIRBASE
        if afb:GetCoalition() == coalition.side.BLUE then
          local zone = afb:GetZone()
          local linebacker = SET_GROUP:New():FilterCoalitions("blue"):FilterCategoryGround():FilterPrefixes("Linebacker"):FilterZones({zone}):FilterOnce():CountAlive()
          if linebacker > 0 then
            return true
          else
            return false
          end
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

--[[
-- Special tasks
if CurrentPhase == 1 then
  local TgtSetOne = SET_ZONE:New():FilterPrefixes("army_fuel_tank"):FilterOnce()
  local scensetone = SET_SCENERY:New(TgtSetOne)
  local ScenTask = PLAYERTASK:New(AUFTRAG.Type.PRECISIONBOMBING,TARGET:New(scensetone),true,99,"Destroy the fuel tanks at Nevatim Airbase!")
  ScenTask:SetMenuName("Bomb Fuel Tanks")
  ScenTask:AddFreetext("Destroy the fuel tanks at Nevatim Airbase!")
  ScenTask:AddFreetextTTS(("Destroy the fuel tanks at Nevatim Airbase!"))
  ScenTask:AddConditionSuccess(
    function(Set)
      local set = Set -- Core.Set#SET_SCENERY
      local points = set:GetRelativeLife()
      if points <= 25 then
        return true
      else
        return false
      end
    end,
    scensetone
  )
  anvil:AddPlayerTaskToQueue(ScenTask)
  
  local TgtSettwo = SET_ZONE:New():FilterPrefixes("gaza"):FilterOnce()
  local scensettwo = SET_SCENERY:New(TgtSettwo)
  local ScenTask2 = PLAYERTASK:New(AUFTRAG.Type.PRECISIONBOMBING,TARGET:New(scensettwo),true,99,"Destroy the weapon factory in Gaza!")
  ScenTask2:SetMenuName("Bomb Factory")
  ScenTask2:AddFreetext("Destroy the weapon factory in Gaza!")
  ScenTask2:AddFreetextTTS(("Destroy the weapon factory in Gaza!"))
  ScenTask2:AddConditionSuccess(
    function(Set)
      local set = Set -- Core.Set#SET_SCENERY
      local points = set:GetRelativeLife()
      if points <= 25 then
        return true
      else
        return false
      end
    end,
    scensettwo
  )
  anvil:AddPlayerTaskToQueue(ScenTask2) 
  
  local TgtSet3 = SET_ZONE:New():FilterPrefixes("ovda"):FilterOnce()
  local scenset3 = SET_SCENERY:New(TgtSet3)
  local ScenTask3 = PLAYERTASK:New(AUFTRAG.Type.PRECISIONBOMBING,TARGET:New(scenset3),true,99,"Destroy the weapon storages in Eilat!")
  ScenTask3:SetMenuName("Bomb Storage")
  ScenTask3:AddFreetext("Destroy the weapon storages in Eilat!")
  ScenTask3:AddFreetextTTS(("Destroy the weapon storages in Eilat!"))
  ScenTask3:AddConditionSuccess(
    function(Set)
      local set = Set -- Core.Set#SET_SCENERY
      local points = set:GetRelativeLife()
      if points <= 25 then
        return true
      else
        return false
      end
    end,
    scenset3
  )
  anvil:AddPlayerTaskToQueue(ScenTask3)
  
  ----------------------------------------------------
  -- Gaza Scenery Task is a PITB
  ----------------------------------------------------
  
  --if debug then
    local flag = 100
    local flagt = {}
    for i=100,106 do
      flagt[i] = USERFLAG:New(string.format("%d",i)):Set(1)
    end
    
    local roleset = {}
    scensettwo:ForEachScenery(
      function(scen)
        local name = scen:GetName()
        local role = scen:GetProperty("ROLE") or "0"
        roleset[tostring(name)] = role
      end
    )
    
    function scensettwo:OnEventHit(data)
      --BASE:I("Event "..data.id)
      local event = data -- Core.Event#EVENTDATA
      if event.id == EVENTS.Hit then
        --BASE:I("Event Hit:")
        --BASE:I("Unit Name is "..tostring(event.TgtUnitName))
        --BASE:I("Category is "..tostring(event.TgtCategory))
        --BASE:I("Object Category is "..tostring(event.TgtObjectCategory))
        --BASE:I("Type Name is "..tostring(event.TgtTypeName))
        local zone = ZONE:FindByName("Gaza Factory Zone")
        local scenhit = SCENERY:FindByNameInZone(event.TgtUnitName,zone,125)
        if scenhit then
          --BASE:I("Hit in Scenery Gaza Zone!")
          if scensettwo:IsInSet(scenhit) then
            --BASE:I("Target Object Hit!")
            local role = roleset[tostring(event.TgtUnitName)]
            --BASE:I("Role = " .. (role or 0))
            if role and role ~= "0" then
              flagt[tonumber(role)]:Set(99,1)
              local coord = scenhit:GetCoordinate()
              if coord then
                coord:Explosion(1000,1)
              end
            end
          end
        end
      end
    end
    
    scensettwo:HandleEvent(EVENTS.Hit)
  --end
  
end
--]]

function anvil:OnAfterTaskSuccess(From,Event,To,Task)
  local points = 100
  local task = Task.PlayerTaskNr or 1
  local ttype = Task.Type or "CAS"
  local text = string.format("Well done pilots! You have completed %s task %03d! Adding %d resource points.",ttype, task, points)
  MESSAGE:New(text,15,"ANVIL"):ToBlue()
  HowiAddBudget(points)
end

-------------------------------------
-- PlayerRecce
-------------------------------------

local HeloPrefixes = { "UH", "SA342", "Mi.8", "Mi.24", "AH.64"}
local PlayerSet = SET_CLIENT:New():FilterCoalitions("blue"):FilterPrefixes(HeloPrefixes):FilterStart()
local HeloRecce = PLAYERRECCE:New("Blue HeloRecce",coalition.side.BLUE,PlayerSet)
HeloRecce:SetCallSignOptions(true,false)
HeloRecce:SetMenuName("Scouting")
HeloRecce:SetTransmitOnlyWithPlayers(true)
HeloRecce:SetSRS({140,240},{radio.modulation.AM,radio.modulation.AM},mySRSPath,"male","en-IR",mySRSPort,MSRS.Voices.Google.Standard.en_GB_Standard_F,1)
--HeloRecce.SRS:SetProvider(MSRS.Provider.WINDOWS)
--HeloRecce.SRS:SetVoice("Sean")
HeloRecce:SetPlayerTaskController(anvil)
anvil:EnableBuddyLasing(HeloRecce)


