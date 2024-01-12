-------------------------------------
-- Generals
-------------------------------------

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

local Howi = STRATEGO:New("Eisenhower",coalition.side.BLUE,100)
Howi:SetUsingBudget(true,250)
Howi:SetDebug(false,false,false)
Howi:__Start(1)

local BlueKeyTarget = nil -- Functional.Stratego#STRATEGO.Target
local runs = 0
local maxtries = 3
local BombSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local CASSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local HeloSquad = nil -- Ops.FlighGroup#FLIGHTGROUP
local TransportSquad = nil -- Ops.FlighGroup#FLIGHTGROUP

function BlueStrategyRun()
  -- decide what kind of run this is - 
  local rand = math.floor((math.random(1,10000)/100)+.5)
  
  if BlueKeyTarget and runs%5 == 0 then
    BlueKeyTarget = nil
  end
  
  if not BlueKeyTarget then
    local Ctarget = Howi:FindAffordableConsolidationTarget() -- Functional.Stratego#STRATEGO.Target
    local Starget = Howi:FindAffordableStrategicTarget() -- Functional.Stratego#STRATEGO.Target

    if rand <= 50 and Ctarget then
      -- Tactial
      BlueKeyTarget = Ctarget
      MESSAGE:New("Next Consolidation Target: "..Ctarget.name,15,"Eisenhower"):ToAll():ToLog()
    elseif Starget then
      -- Strategic
      BlueKeyTarget = Starget
      MESSAGE:New("Next Strategic Target: "..Starget.name,15,"Eisenhower"):ToAll():ToLog()
    end
    
  end
  
  if BlueKeyTarget then
    --UTILS.PrintTableToLog(BlueKeyTarget)
    local phase = (runs%4)+1
    MESSAGE:New("Attack phase "..phase.." for "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
    -- phases 1 - bomb runway 2 - CAS 3 - try to land troops 4 - set up airdefense
    if phase == 1 and not BombSquad then
      MESSAGE:New("Sending Bombers to "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
      local SpawnCoord = ZONE:FindByName("Bomber Spawns"):GetCoordinate()
      SpawnCoord:SetAltitude(UTILS.FeetToMeters(BomberHeight))
      local bomber = SPAWN:NewWithAlias(BomberTemplate, "Blue Bomber Squad-"..math.random(1,10000))   
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(AIRBASE.Sinai.Ben_Gurion))
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
              FG:AddMission(mission)
              BombSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(SpawnCoord)
    elseif phase == 2 and not CASSquad then
      MESSAGE:New("Sending CAS to "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
      local node, nearest, dist = Howi:FindNeighborNodes(BlueKeyTarget.name,false,true)
      if nearest then
        local startcoord = Howi.airbasetable[nearest].coord
        local CAS = SPAWN:NewWithAlias(CASTemplate, "Blue CAS Squad-"..math.random(1,10000))  
        :OnSpawnGroup(
          function(grp)
            local FG = FLIGHTGROUP:New(grp)
            FG:SetHomebase(AIRBASE:FindByName(AIRBASE.Sinai.Ben_Gurion))
            local coordinate = BlueKeyTarget.coordinate
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewCASENHANCED(Howi.airbasetable[BlueKeyTarget.name].zone,CASHeight,CASSpeed,150)
              mission:SetMissionAltitude(CASHeight)
              mission:SetTime(1,30*60)
              FG:AddMission(mission)
              CASSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
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
            FG:SetHomebase(AIRBASE:FindByName(AIRBASE.Sinai.Ben_Gurion))
            local coordinate = BlueKeyTarget.coordinate -- Core.Point#COORDINATE
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewLANDATCOORDINATE(coordinate,500,100,HeloLandTime,HeloSpeed,HeloHeight)
              mission:SetMissionAltitude(HeloHeight)
              FG:AddMission(mission)
              local function SpawnMarines()
                local coord = coordinate:GetRandomCoordinateInRadius(500,100)
                local marines = SPAWN:NewWithAlias("Infantry","Marines-"..math.random(1,10000))
                  :InitRandomizeUnits(true,200,100)
                  :SpawnFromCoordinate(coord)
              end
              function mission:OnAfterSuccess(From,Event,To)
                MESSAGE:New("Marines arrived at "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
                SpawnMarines()
              end
              function FG:OnAfterDead(From,Event,To)
                MESSAGE:New("Our helo crashed!",15,"Eisenhower"):ToAll():ToLog()
              end
              HeloSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
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
            FG:SetHomebase(AIRBASE:FindByName(AIRBASE.Sinai.Ben_Gurion))
            local coordinate = BlueKeyTarget.coordinate -- Core.Point#COORDINATE
            local point
            if coordinate then
              --point = coordinate:ToStringMGRS()
              local mission = AUFTRAG:NewLANDATCOORDINATE(coordinate,500,100,HeloLandTime,HeloSpeed,HeloHeight)
              mission:SetMissionAltitude(HeloHeight)
              FG:AddMission(mission)
              local function SpawnMarines()
                local coord = coordinate:GetRandomCoordinateInRadius(500,100)
                local marines = SPAWN:NewWithAlias("Stinger","ADStinger-"..math.random(1,10000))
                  :InitRandomizeUnits(true,200,100)
                  :SpawnFromCoordinate(coord)
              end
              function mission:OnAfterSuccess(From,Event,To)
                MESSAGE:New("Air Defense arrived at "..BlueKeyTarget.name,15,"Eisenhower"):ToAll():ToLog()
                SpawnMarines()
              end
              function FG:OnAfterDead(From,Event,To)
                MESSAGE:New("Our helo crashed!",15,"Eisenhower"):ToAll():ToLog()
              end
              TransportSquad = FG
            end
          end
        )
        :SpawnFromCoordinate(startcoord)
      end
      --BlueKeyTarget = nil
    end
  end
  
  -- TBD Bomb Strategic Targets deep inside land
  --local Bombing, Weight = Howi:GetHighestWeightNodes(coalition.side.BLUE)
  --local Bombing2, Weight2 = Howi:GetNextHighestWeightNodes(Weight,coalition.side.BLUE)

  runs=runs+1
end

local HowiTimer = TIMER:New(BlueStrategyRun)
HowiTimer:Start(40*60,20*60)
