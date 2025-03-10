-------------------------------------
-- Generals
-------------------------------------

-------------------------------------
-- BLUE
-------------------------------------

local debug = false

local BlueKeyBases = {
  [1] = AIRBASE.Sinai.Ben_Gurion,
  [2] = AIRBASE.Sinai.Nevatim,
  [3] = AIRBASE.Sinai.Melez,
  [4] = AIRBASE.Sinai.Melez,
}

local BlueBomberSpawnZone = "Bomber Spawns"
local BlueKeyAirbase = BlueKeyBases[CurrentPhase]

local BomberTemplate = "Blue Bomber Squad"
local BomberHeight = 30000
local BomberSpeed = 400

local CASTemplate = "Blue CAS Squad"
local CASHeight = 15000
local CASSpeed = 250

local HeloTemplate = "Blue Helo Squad"
local HeloHeight = 3000
local HeloSpeed = 200
local HeloLandTime = 120

local TansportTemplate = "Blue Transport Squad"
local TansportHeight = 3000
local TansportSpeed = 200
local TransportLandTime = 120

if debug then
  BASE:TraceOn()
  BASE:TraceClass("STRATEGO")
end

local PlayerSet = SET_CLIENT:New():FilterActive(true):FilterStart()

local Howi = STRATEGO:New("Eisenhower",coalition.side.BLUE,125)
--Howi:SetDebug(true,true,true)
Howi:SetUsingBudget(true,500)
Howi:SetDebug(false,false,false)
Howi:__Start(1)

function Howi:OnAfterNodeEvent(From,Event,To,OpsZone,Coalition)
  local name = OpsZone:GetName() or "Unknown"
  if Coalition == self.coalition and OpsZone:GetPreviousOwner() ~= self.coalition  then
    MESSAGE:New(string.format("We won %s! Well done!",name),20,"Eisenhower"):ToAll()
    local points = self:GetNodeWeight(name) or 0
    self:AddBudget(points)
  else
    MESSAGE:New(string.format("We lost %s!",name),20,"Eisenhower"):ToAll()
  end
end

local BlueKeyTarget = nil -- Functional.Stratego#STRATEGO.Target
local runs = 0
local maxtries = 3
local BombSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local CASSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local HeloSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local TransportSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local BlueCurrMission = nil -- Ops.Auftrag#AUFTRAG

function BlueStrategyRun()

  -- decide what kind of run this is - 
  BASE:I("***** Blue Strategy Run *****")

  if BlueCurrMission and BlueCurrMission:IsNotOver() then
    return
  end
  
  Howi:UpdateNodeCoalitions()

  --local rand = math.floor((math.random(1,10000)/100)+.5)
  
  --BASE:I("**** Random number = "..rand)
  
  if BlueKeyTarget == nil then
    local Ctarget = Howi:FindAffordableConsolidationTarget() -- Functional.Stratego#STRATEGO.Target
    local Starget = Howi:FindAffordableStrategicTarget() -- Functional.Stratego#STRATEGO.Target

    if type(Ctarget) == "table" and Ctarget.name then
      -- Tactial
      BlueKeyTarget = Ctarget
      MESSAGE:New("Next Consolidation Target: "..Ctarget.name,15,"Eisenhower"):ToAll():ToLog()
    elseif type(Starget)=="table"and Starget.name then
      -- Strategic
      BlueKeyTarget = Starget
      MESSAGE:New("Next Strategic Target: "..Starget.name,15,"Eisenhower"):ToAll():ToLog()
    end
    
  end
  
  if debug == false then
    if PlayerSet:CountAlive() == 0 then return end
  end
  
  if BlueKeyTarget then
    --UTILS.PrintTableToLog(BlueKeyTarget)
    local phase = (runs%4)+1
    MESSAGE:New("Attack phase "..phase.." for "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
    -- phases 1 - bomb runway 2 - CAS 3 - try to land troops 4 - set up airdefense
    if phase == 1 and not BombSquad then
      MESSAGE:New("Sending Bombers to "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
      local SpawnCoord = ZONE:FindByName(BlueBomberSpawnZone):GetCoordinate()
      SpawnCoord:SetAltitude(UTILS.FeetToMeters(BomberHeight))
      local bomber = SPAWN:NewWithAlias(BomberTemplate, "Blue Bomber Squad-"..math.random(1,10000))   
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(BlueKeyAirbase))
            local coordinate = BlueKeyTarget.coordinate
            local point
            if coordinate then
              point = coordinate:ToStringMGRS()
              MESSAGE:New("Bomb runway "..point,15,"Eisenhower"):ToAll():ToLog()
              local mission
              if Howi:IsAirbase(BlueKeyTarget.name) then
                local ab = AIRBASE:FindByName(BlueKeyTarget.name)
                mission = AUFTRAG:NewBOMBRUNWAY(ab,BomberHeight)
              else
                mission = AUFTRAG:NewBOMBING(coordinate,BomberHeight)
              end
              mission:SetMissionRange(BomberSpeed)
              mission:SetMissionSpeed(BomberSpeed)
              mission:SetMissionAltitude(BomberHeight)
              function mission:OnAfterSuccess(From,Event,To)
                Howi:AddBudget(100)
              end
              FG:AddMission(mission)
              BombSquad = FG
              BlueCurrMission = mission
            end
          end
        )
        :SpawnFromCoordinate(SpawnCoord)
        Howi:SubtractBudget(100)
    elseif phase == 2 and not CASSquad then
      MESSAGE:New("Sending CAS to "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
      local node, nearest, dist = Howi:FindNeighborNodes(BlueKeyTarget.name,false,true)
      if nearest then
        local startcoord = Howi.airbasetable[nearest].coord
        local CAS = SPAWN:NewWithAlias(CASTemplate, "Blue CAS Squad-"..math.random(1,10000))  
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(BlueKeyAirbase))
            local coordinate = BlueKeyTarget.coordinate
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewCASENHANCED(Howi.airbasetable[BlueKeyTarget.name].zone,CASHeight,CASSpeed,150)
              mission:SetMissionAltitude(CASHeight)
              mission:SetTime(1,30*60)
              function mission:OnAfterSuccess(From,Event,To)
                Howi:AddBudget(100)
              end
              FG:AddMission(mission)
              CASSquad = FG
              BlueCurrMission = mission
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
        Howi:SubtractBudget(100)
      end
    elseif phase == 3 and not HeloSquad then
      MESSAGE:New("Sending Marines Helo to "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
      local node, nearest, dist = Howi:FindNeighborNodes(BlueKeyTarget.name,false,true)
      if nearest then
        local startcoord = Howi.airbasetable[nearest].coord
        local CAS = SPAWN:NewWithAlias(HeloTemplate, "Blue Helo Squad-"..math.random(1,10000))  
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(nearest))
            local coordinate = BlueKeyTarget.coordinate -- Core.Point#COORDINATE
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewLANDATCOORDINATE(coordinate,500,100,HeloLandTime,HeloSpeed,HeloHeight)
              mission:SetMissionAltitude(HeloHeight)
              FG:AddMission(mission)
              BlueCurrMission = mission
              local function SpawnMarines()
                local coord = coordinate:GetRandomCoordinateInRadius(500,100)
                local marines = SPAWN:NewWithAlias("Infantry","Marines-"..math.random(1,10000))
                  :InitRandomizeUnits(true,200,100)
                  :SpawnFromCoordinate(coord)
              end
              function mission:OnAfterSuccess(From,Event,To)
                MESSAGE:New("Marines arrived at "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
                SpawnMarines()
                Howi:AddBudget(100)
              end
              function FG:OnAfterDead(From,Event,To)
                MESSAGE:New("Our helo crashed!",15,"Eisenhower"):ToAll():ToLog()
              end
              HeloSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
        Howi:SubtractBudget(100)
      end
    elseif phase == 4 then
      MESSAGE:New("Set up Air Defense at "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
      local node, nearest, dist = Howi:FindNeighborNodes(BlueKeyTarget.name,false,true)
      if nearest then
        local startcoord = Howi.airbasetable[nearest].coord
        local CAS = SPAWN:NewWithAlias(HeloTemplate, "Blue Helo Squad-"..math.random(1,10000))  
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(nearest))
            local coordinate = BlueKeyTarget.coordinate -- Core.Point#COORDINATE
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewLANDATCOORDINATE(coordinate,500,100,HeloLandTime,HeloSpeed,HeloHeight)
              mission:SetMissionAltitude(HeloHeight)
              FG:AddMission(mission)
              BlueCurrMission = mission
              local function SpawnMarines()
                local coord = coordinate:GetRandomCoordinateInRadius(500,100)
                local marines = SPAWN:NewWithAlias("ADStinger","ADStinger-"..math.random(1,10000))
                  :InitRandomizeUnits(true,200,100)
                  :SpawnFromCoordinate(coord)
              end
              function mission:OnAfterSuccess(From,Event,To)
                MESSAGE:New("Air Defense arrived at "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
                SpawnMarines()
                Howi:AddBudget(100)
              end
              function FG:OnAfterDead(From,Event,To)
                MESSAGE:New("Our helo crashed!",15,"Eisenhower"):ToAll():ToLog()
              end
              TransportSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
        Howi:SubtractBudget(100)
      elseif runs%5 == 0 then
        BlueKeyTarget = nil
        BombSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
        CASSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
        HeloSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
        TransportSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
      end
    end
  end
  
  -- TBD Bomb Strategic Targets deep inside land
  --local Bombing, Weight = Howi:GetHighestWeightNodes(coalition.side.BLUE)
  --local Bombing2, Weight2 = Howi:GetNextHighestWeightNodes(Weight,coalition.side.BLUE)
  
  runs=runs+1
end

local HowiTimer = TIMER:New(BlueStrategyRun)
if debug == true then
  HowiTimer:Start(300,20)
else
  HowiTimer:Start(300,20*60)
end

function HowiAddBudget(Points)
  Howi:AddBudget(Points)
end

function ShowObjective()
  local report = REPORT:New("Syria Insurgency")
  report:Add("==================================")
  if BlueKeyTarget then
    report:Add("The current key objective is to conquer and fortify "..BlueKeyTarget.name..".")
    report:Add("Whilst the Marine Corps hasn't taken it, make yourself")
    report:Add("useful and neutralize enemy forces on the target and ")
    report:Add("in the surround area.")
    report:Add("Anvil task manager at 135 and 255 AM will help you locate and define suitable targets.")
  else
    report:Add("The General has not yet decided. In the meantime\nmake yourself useful!")
    report:Add("Anvil task manager at 135 and 255 AM will help you locate and define suitable targets.")  
  end
    report:Add("Currently available resource budget is: "..Howi:GetBudget())
    report:Add("An attack on airbase costs: 400 points.")
    report:Add("==================================")
  MESSAGE:New(report:Text(),30,"Eisenhower"):ToCoalition(coalition.side.BLUE)
end

local keytargetmenu = MENU_COALITION_COMMAND:New(coalition.side.BLUE,"Key Target Objective",nil,ShowObjective)

-------------------------------------
-- Red
-------------------------------------

local RedKeyBases = {
  [1] = AIRBASE.Sinai.Bilbeis_Air_Base,
  [2] = AIRBASE.Sinai.Bilbeis_Air_Base,
  [3] = AIRBASE.Sinai.Cairo_West,
  [4] = AIRBASE.Sinai.Cairo_West,
}

local RedBomberSpawnZone = "Red Bomber Spawns"
local RedKeyBase = RedKeyBases[CurrentPhase]
local RedBomberBase = AIRBASE.Sinai.Cairo_International_Airport

local RedBomberTemplate = "Red Bomber Squad"
local RedBomberHeight = 30000
local RedBomberSpeed = 400

local RedCASTemplate = "Red CAS Squad"
local RedCASHeight = 15000
local RedCASSpeed = 250

local RedHeloTemplate = "Red Helo Squad"
local RedHeloHeight = 3000
local RedHeloSpeed = 200
local RedHeloLandTime = 120

local RedTansportTemplate = "Red Transport Squad"
local RedTansportHeight = 3000
local RedTansportSpeed = 200
local RedTransportLandTime = 120

local RedMarines = "Spetznatz"
local RedStinger = "Grouse"

local Alsisi = STRATEGO:New("Al-Sisi",coalition.side.RED,100)
Alsisi:SetUsingBudget(true,1000)
Alsisi:SetDebug(false,false,false)
Alsisi:__Start(1)

function Alsisi:OnAfterNodeEvent(From,Event,To,OpsZone,Coalition)
  local name = OpsZone:GetName() or "Unknown"
  if Coalition == self.coalition then
    MESSAGE:New(string.format("We won %s! Well done!",name),20,"Al-Sisi"):ToAllIf(debug)
    local points = self:GetNodeWeight(name) or 0
    self:AddBudget(points)
  else
    MESSAGE:New(string.format("We lost %s!",name),20,"Al-Sisi"):ToAllIf(debug)
  end
end

local RedKeyTarget = nil -- Functional.Stratego#STRATEGO.Target
local redruns = 0
local maxtries = 3
local RedBombSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local RedCASSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local RedHeloSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local RedTransportSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local RedCurrMission = nil -- Ops.Auftrag#AUFTRAG

function RedStrategyRun()
  -- decide what kind of run this is - 
  BASE:I("***** Red Strategy Run *****")
  
  if RedCurrMission and RedCurrMission:IsNotOver() then
    return
  end
  
  Alsisi:UpdateNodeCoalitions()
  
  --local rand = math.floor((math.random(1,10000)/100)+.5)
  
  if not RedKeyTarget then
    local Ctarget = Alsisi:FindAffordableConsolidationTarget() -- Functional.Stratego#STRATEGO.Target
    local Starget = Alsisi:FindAffordableStrategicTarget() -- Functional.Stratego#STRATEGO.Target

    if Ctarget then
      -- Tactial
      RedKeyTarget = Ctarget
      MESSAGE:New("Next Consolidation Target: "..Ctarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
    elseif Starget then
      -- Strategic
      RedKeyTarget = Starget
      MESSAGE:New("Next Strategic Target: "..Starget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
    end
    
  end
  
  if PlayerSet:CountAlive() == 0 and debug==false then return end
  
  if RedKeyTarget then
    --UTILS.PrintTableToLog(RedKeyTarget)
    MESSAGE:New("General Al-Sisi is activating airplanes!"):ToBlue()
    local phase = (redruns%4)+1
    MESSAGE:New("Attack phase "..phase.." for "..RedKeyTarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
    -- phases 1 - bomb runway 2 - CAS 3 - try to land troops 4 - set up airdefense
    if phase == 1 and not RedBombSquad then
      MESSAGE:New("Sending Bombers to "..RedKeyTarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
      local SpawnCoord = ZONE:FindByName(RedBomberSpawnZone):GetCoordinate()
      SpawnCoord:SetAltitude(UTILS.FeetToMeters(RedBomberHeight))
      local bomber = SPAWN:NewWithAlias(RedBomberTemplate, "Red Bomber Squad-"..math.random(1,10000))   
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(RedBomberBase))
            local coordinate = RedKeyTarget.coordinate
            local point
            if coordinate then
              point = coordinate:ToStringMGRS()
              MESSAGE:New("Bomb runway "..point,15,"Al-Sisi"):ToAllIf(debug):ToLog()
              local mission
              if Alsisi:IsAirbase(RedKeyTarget.name) then
                local ab = AIRBASE:FindByName(RedKeyTarget.name)
                mission = AUFTRAG:NewBOMBRUNWAY(ab,RedBomberHeight)
              else
                mission = AUFTRAG:NewBOMBING(coordinate,RedBomberHeight)
              end
              mission:SetMissionRange(RedBomberSpeed)
              mission:SetMissionSpeed(RedBomberSpeed)
              mission:SetMissionAltitude(RedBomberHeight)
              function mission:OnAfterSuccess(From,Event,To)
                Alsisi:AddBudget(100)
              end
              FG:AddMission(mission)
              RedCurrMission = mission
              RedBombSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(SpawnCoord)
        Alsisi:SubtractBudget(100)
    elseif phase == 2 and not RedCASSquad then
      MESSAGE:New("Sending CAS to "..RedKeyTarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
      local node, nearest, dist = Alsisi:FindNeighborNodes(RedKeyTarget.name,false,true)
      if nearest then
        local startcoord = Alsisi.airbasetable[nearest].coord
        local CAS = SPAWN:NewWithAlias(RedCASTemplate, "Red CAS Squad-"..math.random(1,10000))  
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(RedKeyBase))
            local coordinate = RedKeyTarget.coordinate
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewCASENHANCED(Alsisi.airbasetable[RedKeyTarget.name].zone,RedCASHeight,RedCASSpeed,150)
              mission:SetMissionAltitude(RedCASHeight)
              mission:SetTime(1,30*60)
              function mission:OnAfterSuccess(From,Event,To)
                Alsisi:AddBudget(100)
              end
              FG:AddMission(mission)
              RedCurrMission = mission
              RedCASSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
        Alsisi:SubtractBudget(100)
      end
    elseif phase == 3 and not RedHeloSquad then
      MESSAGE:New("Sending Spetznatz Helo to "..RedKeyTarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
      local node, nearest, dist = Alsisi:FindNeighborNodes(RedKeyTarget.name,false,true)
      if nearest then
        local startcoord = Alsisi.airbasetable[nearest].coord
        local CAS = SPAWN:NewWithAlias(RedHeloTemplate, "Red Helo Squad-"..math.random(1,10000))  
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(nearest))
            local coordinate = RedKeyTarget.coordinate -- Core.Point#COORDINATE
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewLANDATCOORDINATE(coordinate,500,100,RedHeloLandTime,RedHeloSpeed,RedHeloHeight)
              mission:SetMissionAltitude(RedHeloHeight)
              FG:AddMission(mission)
              RedCurrMission = mission
              local function SpawnMarines()
                local coord = coordinate:GetRandomCoordinateInRadius(500,100)
                local marines = SPAWN:NewWithAlias(RedMarines,"Spetznatz-"..math.random(1,10000))
                  :InitRandomizeUnits(true,200,100)
                  :SpawnFromCoordinate(coord)
              end
              function mission:OnAfterSuccess(From,Event,To)
                MESSAGE:New("Spetznatz arrived at "..RedKeyTarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
                SpawnMarines()
                Alsisi:AddBudget(100)
              end
              function FG:OnAfterDead(From,Event,To)
                MESSAGE:New("Our helo crashed!",15,"Al-Sisi"):ToAllIf(debug):ToLog()
              end
              RedHeloSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
        Alsisi:SubtractBudget(100)
      end
    elseif phase == 4 then
      MESSAGE:New("Set up Air Defense at "..RedKeyTarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
      local node, nearest, dist = Alsisi:FindNeighborNodes(RedKeyTarget.name,false,true)
      if nearest then
        local startcoord = Alsisi.airbasetable[nearest].coord
        local CAS = SPAWN:NewWithAlias(RedHeloTemplate, "Red Helo Squad-"..math.random(1,10000))  
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(nearest))
            local coordinate = RedKeyTarget.coordinate -- Core.Point#COORDINATE
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewLANDATCOORDINATE(coordinate,500,100,RedHeloLandTime,RedHeloSpeed,RedHeloHeight)
              mission:SetMissionAltitude(RedHeloHeight)
              FG:AddMission(mission)
              RedCurrMission = mission
              local function SpawnMarines()
                local coord = coordinate:GetRandomCoordinateInRadius(500,100)
                local marines = SPAWN:NewWithAlias(RedStinger,"Grouse-"..math.random(1,10000))
                  :InitRandomizeUnits(true,200,100)
                  :SpawnFromCoordinate(coord)
              end
              function mission:OnAfterSuccess(From,Event,To)
                MESSAGE:New("Air Defense arrived at "..RedKeyTarget.name,15,"Al-Sisi"):ToAllIf(debug):ToLog()
                SpawnMarines()
                Alsisi:AddBudget(100)
              end
              function FG:OnAfterDead(From,Event,To)
                MESSAGE:New("Our helo crashed!",15,"Al-Sisi"):ToAllIf(debug):ToLog()
              end
              RedTransportSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
        Alsisi:SubtractBudget(100)
      elseif redruns%5 == 0 then
        RedKeyTarget = nil
        RedBombSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
        RedCASSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
        RedHeloSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
        RedTransportSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
      end
    end
  end
  
  -- TBD Bomb Strategic Targets deep inside land
  --local Bombing, Weight = Alsisi:GetHighestWeightNodes(coalition.side.BLUE)
  --local Bombing2, Weight2 = Alsisi:GetNextHighestWeightNodes(Weight,coalition.side.BLUE)

  redruns=redruns+1
  Alsisi:AddBudget(100)
end

function AlsisiAddBudget(Points)
  Alsisi:AddBudget(Points)
end

-- Earn some points
local RedEventManager = EVENTHANDLER:New()
local eventdebug = false

function RedEventManager:_EventHandler(EventData)
  local data = EventData -- Core.Event#EVENTDATA
  if data.IniCoalition == coalition.side.BLUE then
    if data.id == EVENTS.UnitLost or data.id == EVENTS.Dead then
      local text = "***** Blue Unit lost: "..data.IniUnitName or "unknown"
      text = text .. "! Earning 50 points!"
      MESSAGE:New(text,10,"Red General"):ToAllIf(eventdebug):ToLog()
      AlsisiAddBudget(50)
    elseif data.id == EVENTS.Crash then
      local text = "***** Blue plane or helo lost: "..data.IniUnitName or "unknown"
      text = text .. "! Earning 100 points!"
      MESSAGE:New(text,10,"Red General"):ToAllIf(eventdebug):ToLog()
      AlsisiAddBudget(100)
    end
  end
end

RedEventManager:HandleEvent(EVENTS.UnitLost,RedEventManager._EventHandler)
RedEventManager:HandleEvent(EVENTS.Dead,RedEventManager._EventHandler)
RedEventManager:HandleEvent(EVENTS.Crash,RedEventManager._EventHandler)

local AlsisiTimer = TIMER:New(RedStrategyRun)

if debug == true then
  AlsisiTimer:Start(450,20,4*20)
else
  AlsisiTimer:Start(450,20*60)
end