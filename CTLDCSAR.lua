
local PerTroopMass = 80
local NoTroops = 6
local NoTroopsSmall = 4
local PerCrateMass = 400
local Stock = nil -- endless
local CratesBig = 8
local CratesMed = 4
local CratesSmall = 2
local CratesRep = 1
local FarpFileName = "Escalation_FARPS.csv"
local CTLD_Filename = "CTLD_save.csv"
local CSAR_Filename = "CSAR.csv"
local HeloPrefixes = { "UH", "SA342", "Mi.8", "Mi.24", "AH.64"}


-------------------------------------
-- CSAR
-------------------------------------

local mycsar = CSAR:New("blue","Downed Pilot","81st MedEvac")

mycsar.allowDownedPilotCAcontrol = false -- Set to false if you don\'t want to allow control by Combined Arms.
mycsar.allowFARPRescue = true -- allows pilots to be rescued by landing at a FARP or Airbase. Else MASH only!
mycsar.FARPRescueDistance = 1000 -- you need to be this close to a FARP or Airport for the pilot to be rescued.
mycsar.autosmoke = false -- automatically smoke a downed pilot\'s location when a heli is near.
mycsar.autosmokedistance = 1000 -- distance for autosmoke
mycsar.coordtype = 2 -- Use Lat/Long DDM (0), Lat/Long DMS (1), MGRS (2), Bullseye imperial (3) or Bullseye metric (4) for coordinates.
mycsar.csarOncrash = false -- (WIP) If set to true, will generate a downed pilot when a plane crashes as well.
mycsar.enableForAI = false -- set to false to disable AI pilots from being rescued.
mycsar.pilotRuntoExtractPoint = true -- Downed pilot will run to the rescue helicopter up tomycsar.extractDistance in meters. 
mycsar.extractDistance = 500 -- Distance the downed pilot will start to run to the rescue helicopter.
mycsar.immortalcrew = true -- Set to true to make wounded crew immortal.
mycsar.invisiblecrew = false -- Set to true to make wounded crew insvisible.
mycsar.loadDistance = 75 -- configure distance for pilots to get into helicopter in meters.
mycsar.mashprefix = {"MASH"} -- prefixes of #GROUP objects used as MASHes.
mycsar.max_units = 6 -- max number of pilots that can be carried if #CSAR.AircraftType is undefined.
mycsar.messageTime = 15 -- Time to show messages for in seconds. Doubled for long messages.
mycsar.radioSound = "beacon.ogg" -- the name of the sound file to use for the pilots\' radio beacons. 
mycsar.smokecolor = 4 -- Color of smokemarker, 0 is green, 1 is red, 2 is white, 3 is orange and 4 is blue.
mycsar.useprefix = true  -- Requires CSAR helicopter #GROUP names to have the prefix(es) defined below.
mycsar.csarPrefix = HeloPrefixes -- #GROUP name prefixes used for useprefix=true - DO NOT use # in helicopter names in the Mission Editor! 
mycsar.verbose = 0 -- set to > 1 for stats output for debugging.
-- limit amount of downed pilots spawned by **ejection** events
mycsar.limitmaxdownedpilots = true
mycsar.maxdownedpilots = 10 
-- allow to set far/near distance for approach and optionally pilot must open doors
mycsar.approachdist_far = 5000 -- switch do 10 sec interval approach mode, meters
mycsar.approachdist_near = 3000 -- switch to 5 sec interval approach mode, meters
mycsar.pilotmustopendoors = true -- switch to true to enable check of open doors
mycsar.suppressmessages = false -- switch off all messaging if you want to do your own
mycsar.rescuehoverheight = 20 -- max height for a hovering rescue in meters
mycsar.rescuehoverdistance = 10 -- max distance for a hovering rescue in meters
-- Country codes for spawned pilots
mycsar.countryblue= country.id.USA
mycsar.countryred = country.id.RUSSIA
mycsar.countryneutral = country.id.UN_PEACEKEEPERS
mycsar.topmenuname = "CSAR" -- set the menu entry name
mycsar.ADFRadioPwr = 1000 -- ADF Beacons sending with 1KW as default
mycsar.PilotWeight = PerTroopMass --  Loaded pilots weigh 80kgs each

mycsar.enableLoadSave = true -- allow auto-saving and loading of files
mycsar.saveinterval = 600 -- save every 10 minutes
mycsar.filename = CSAR_Filename -- example filename
mycsar.filepath = SavePath
 
mycsar:__Start(1)
mycsar:__Load(4)
 
 -------------------------------------
-- CTLD
-------------------------------------

local my_ctld = CTLD:New(coalition.side.BLUE,HeloPrefixes,"81st Airborne")

my_ctld.useprefix = true -- (DO NOT SWITCH THIS OFF UNLESS YOU KNOW WHAT YOU ARE DOING!) Adjust **before** starting CTLD. If set to false, *all* choppers of the coalition side will be enabled for CTLD.
my_ctld.CrateDistance = 35 -- List and Load crates in this radius only.
my_ctld.PackDistance = 35 -- Pack crates in this radius only
my_ctld.dropcratesanywhere = true -- Option to allow crates to be dropped anywhere.
my_ctld.dropAsCargoCrate = false -- Parachuted herc cargo is not unpacked automatically but placed as crate to be unpacked. Needs a cargo with the same name defined like the cargo that was dropped.
my_ctld.maximumHoverHeight = 15 -- Hover max this high to load.
my_ctld.minimumHoverHeight = 4 -- Hover min this low to load.
my_ctld.forcehoverload = false -- Crates (not: troops) can **only** be loaded while hovering.
my_ctld.hoverautoloading = true -- Crates in CrateDistance in a LOAD zone will be loaded automatically if space allows.
my_ctld.smokedistance = 2000 -- Smoke or flares can be request for zones this far away (in meters).
my_ctld.movetroopstowpzone = true -- Troops and vehicles will move to the nearest MOVE zone...
my_ctld.movetroopsdistance = 5000 -- .. but only if this far away (in meters)
my_ctld.smokedistance = 2000 -- Only smoke or flare zones if requesting player unit is this far away (in meters)
my_ctld.suppressmessages = false -- Set to true if you want to script your own messages.
my_ctld.repairtime = 300 -- Number of seconds it takes to repair a unit.
my_ctld.buildtime = 300 -- Number of seconds it takes to build a unit. Set to zero or nil to build instantly.
my_ctld.cratecountry = country.id.GERMANY -- ID of crates. Will default to country.id.RUSSIA for RED coalition setups.
my_ctld.allowcratepickupagain = true  -- allow re-pickup crates that were dropped.
my_ctld.enableslingload = false -- allow cargos to be slingloaded - might not work for all cargo types
my_ctld.pilotmustopendoors = false -- force opening of doors
my_ctld.SmokeColor = SMOKECOLOR.Red -- default color to use when dropping smoke from heli 
my_ctld.FlareColor = FLARECOLOR.Red -- color to use when flaring from heli
my_ctld.basetype = "container_cargo" -- default shape of the cargo container
my_ctld.droppedbeacontimeout = 1200 -- dropped beacon lasts 20 minutes
my_ctld.usesubcats = true -- use sub-category names for crates, adds an extra menu layer in "Get Crates", useful if you have > 10 crate types.
my_ctld.placeCratesAhead = true -- place crates straight ahead of the helicopter, in a random way. If true, crates are more neatly sorted.
my_ctld.nobuildinloadzones = false -- forbid players to build stuff in LOAD zones if set to `true`
my_ctld.movecratesbeforebuild = true -- crates must be moved once before they can be build. Set to false for direct builds.
my_ctld.surfacetypes = {land.SurfaceType.LAND,land.SurfaceType.ROAD,land.SurfaceType.SHALLOW_WATER} -- surfaces for loading back objects.
my_ctld.nobuildmenu = false -- if set to true effectively enforces to have engineers build/repair stuff for you.
my_ctld.RadioSound = "beacon.ogg" -- -- this sound will be hearable if you tune in the beacon frequency. Add the sound file to your miz.
my_ctld.RadioSoundFC3 = "beacon.ogg" -- this sound will be hearable by FC3 users (actually all UHF radios); change to something like "beaconsilent.ogg" and add the sound file to your miz if you don't want to annoy FC3 pilots
 
my_ctld.enableLoadSave = true -- allow auto-saving and loading of files
my_ctld.saveinterval = 600 -- save every 10 minutes
my_ctld.filename =  CTLD_Filename -- example filename
my_ctld.filepath = SavePath -- example path
my_ctld.eventoninject = true -- fire OnAfterCratesBuild and OnAfterTroopsDeployed events when loading (uses Inject functions)
my_ctld.useprecisecoordloads = true -- Instead if slightly varyiing the group position, try to maintain it as is

my_ctld:SetUnitCapabilities("SA342L",false,true,0,4,12,400)
my_ctld:SetUnitCapabilities("SA342M",false,true,0,4,12,400)

---
-- CARGO
--- 

-- Infantry
my_ctld:AddTroopsCargo("Infantry Squad (6)",{"Infantry"},CTLD_CARGO.Enum.TROOPS,NoTroops,PerTroopMass,Stock,"Infantry")
my_ctld:AddTroopsCargo("Stinger Squad (4)",{"Stinger"},CTLD_CARGO.Enum.TROOPS,NoTroopsSmall,PerTroopMass,Stock,"Infantry")
my_ctld:AddTroopsCargo("ATGM Squad (4)",{"ATGM"},CTLD_CARGO.Enum.TROOPS,NoTroopsSmall,PerTroopMass,Stock,"Infantry")
my_ctld:AddTroopsCargo("Engineers (4)",{"Engineers"},CTLD_CARGO.Enum.ENGINEERS,NoTroopsSmall,PerTroopMass,Stock,"Infantry")
my_ctld:AddTroopsCargo("Mortar Squad (4)",{"Mortar"},CTLD_CARGO.Enum.TROOPS,NoTroopsSmall,PerTroopMass,Stock,"Infantry")

-- Wheels
my_ctld:AddCratesCargo("Humvee ATGM (2)",{"Humvee ATGM"},CTLD_CARGO.Enum.VEHICLE,CratesSmall,PerCrateMass,Stock,"Rolling")
my_ctld:AddCratesCargo("Humvee MG (2)",{"Humvee MG"},CTLD_CARGO.Enum.VEHICLE,CratesSmall,PerCrateMass,Stock,"Rolling")
my_ctld:AddCratesCargo("Linebacker (4)",{"Linebacker"},CTLD_CARGO.Enum.VEHICLE,CratesMed,PerCrateMass,Stock,"Rolling")
my_ctld:AddCratesCargo("Bradley (4)",{"Bradley"},CTLD_CARGO.Enum.VEHICLE,CratesMed,PerCrateMass,Stock,"Rolling")
my_ctld:AddCratesCargo("ZU-23 Truck (2)",{"ZU-23"},CTLD_CARGO.Enum.VEHICLE,CratesSmall,PerCrateMass,Stock,"Rolling")
my_ctld:AddCratesCargo("Truck (2)",{"Truck"},CTLD_CARGO.Enum.VEHICLE,CratesSmall,PerCrateMass,Stock,"Rolling")
my_ctld:AddCratesCargo("Tanker (2)",{"Tanker"},CTLD_CARGO.Enum.VEHICLE,CratesSmall,PerCrateMass,Stock,"Rolling")

-- Other/Fixed
my_ctld:AddCratesCargo("Hawk System (8)",{"Blue SAM HAWK"},CTLD_CARGO.Enum.FOB,CratesBig,PerCrateMass,Stock,"Installation")
my_ctld:AddCratesCargo("EWR 117 Radar (8)",{"Blue EWR 117"},CTLD_CARGO.Enum.FOB,CratesBig,PerCrateMass,Stock,"Installation")
my_ctld:AddCratesCargo("EWR 117 Power System (1)",{"Blue EWR ECS"},CTLD_CARGO.Enum.FOB,CratesRep,PerCrateMass,Stock,"Installation")
my_ctld:AddCratesCargo("FARP (8)",{"FARP"},CTLD_CARGO.Enum.FOB,CratesBig,PerCrateMass,Stock,"Installation")

-- Repair
my_ctld:AddCratesRepair("Hawk System (2)",{"Blue SAM HAWK"},CTLD_CARGO.Enum.REPAIR,CratesSmall,PerCrateMass,Stock,"Repair")
my_ctld:AddCratesRepair("EWR 117 Radar (2)",{"Blue EWR 117"},CTLD_CARGO.Enum.REPAIR,CratesSmall,PerCrateMass,Stock,"Repair")
my_ctld:AddCratesRepair("EWR 117 Power System (1)",{"Blue EWR ECS"},CTLD_CARGO.Enum.REPAIR,CratesRep,PerCrateMass,Stock,"Installation")

---
-- ZONES
-- 

local zones = SET_AIRBASE:New():FilterOnce()
zones:ForEach(
  function(airbase)
    local zone = airbase:GetZone()
    if zone and (airbase:IsAirdrome() or airbase:IsHelipad()) then
      local name = zone:GetName()
      local coa = airbase:GetCoalition()
      local active = coa == coalition.side.BLUE and true or false
      my_ctld:AddCTLDZone(name,CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,active,active)
    end
  end
)

--- activate zones which switched hands

function CTLDCheckBases()
  zones:ForEach(
    function(airbase)
      local zone = airbase:GetZone()
      if zone and (airbase:IsAirdrome() or airbase:IsHelipad()) then
        local name = zone:GetName()
        local coa = airbase:GetCoalition()
        local active = coa == coalition.side.BLUE and true or false
        my_ctld:ActivateZone(name,CTLD.CargoZoneType.LOAD,active)
      end
    end
  )
end

local CTLDCheckTimer = TIMER:New(CTLDCheckBases)
CTLDCheckTimer:Start(300,300)

---
-- FARP Building
--- 

local FARPFreq = 132
local FARPName = 2 -- numbers 1..10

local FARPClearnames = {
  [1]="London",
  [2]="Dallas",
  [3]="Paris",
  [4]="Moscow",
  [5]="Berlin",
  [6]="Rome",
  [7]="Madrid",
  [8]="Warsaw",
  [9]="Dublin",
  [10]="Perth",
  }
  
local BuiltFARPCoordinates = {}

function SaveFARPS()
  local path = my_ctld.filepath
  local filename = FarpFileName
  local data = "FARP COORDINATES\n"
  for _,_coord in pairs(BuiltFARPCoordinates) do
    local FName = _coord.name
    local coord = _coord.coord -- Core.Point#COORDINATE
    local AFB = STATIC:FindByName("FARP "..FName)
    if AFB and AFB:IsAlive() then
      local vec2 = coord:GetVec2() -- { x = self.x, y = self.z }
      data = data .. string.format("%f;%f;\n",vec2.x,vec2.y)
    end
  end
  if UTILS.SaveToFile(path,filename,data) then
    --BASE:I("***** FARP Positions saved successfully!")
  else
    BASE:E("***** ERROR Saving FARP Positions!")
  end
end
  
function BuildAFARP(Coordinate)
  local coord = Coordinate -- Core.Point#COORDINATE
  
  FARPFreq = FARPFreq + 1
  FARPName = FARPName + 1
  local FarpName = ((FARPName-1)%10)+1
  local FName = FARPClearnames[FarpName]
  
  -- Create a SPAWNSTATIC object from a template static FARP object.
  local SpawnStaticFarp=SPAWNSTATIC:NewFromStatic("FARP Proto", country.id.USA)
  
  -- Spawning FARPS is special in DCS. Therefore, we need to specify that this is a FARP. We also set the callsign and the frequency.
  SpawnStaticFarp:InitFARP(FARPName, FARPFreq, 0)
  SpawnStaticFarp:InitDead(false)
  
  -- Spawn FARP 
  local ZoneSpawn = ZONE_RADIUS:New("FARP "..FName,Coordinate:GetVec2(),160,false)
  local Heading = 0
  local FarpBerlin=SpawnStaticFarp:SpawnFromZone(ZoneSpawn, Heading, "FARP "..FName)
  
  -- ATC and services
  local FarpVehicles = SPAWN:NewWithAlias("FARP Vehicles Template","FARP "..FName.." Technicals")
  FarpVehicles:InitHeading(180)
  local FarpVCoord = coord:Translate(125,0)
  FarpVehicles:SpawnFromCoordinate(FarpVCoord)
  
  local base = 330
  local delta = 30
  
  local windsock = SPAWNSTATIC:NewFromStatic("Static Windsock-1",country.id.USA)
  local sockcoord = coord:Translate(125,base)
  windsock:SpawnFromCoordinate(sockcoord,Heading,"Windsock "..FName)
  base=base-delta
  
  local fueldepot = SPAWNSTATIC:NewFromStatic("Static FARP Fuel Depot-1",country.id.USA)
  local fuelcoord = coord:Translate(125,base)
  fueldepot:SpawnFromCoordinate(fuelcoord,Heading,"Fueldepot "..FName)
  base=base-delta
  
  local ammodepot = SPAWNSTATIC:NewFromStatic("Static FARP Ammo Storage-1",country.id.USA)
  local ammocoord = coord:Translate(125,base)
  ammodepot:SpawnFromCoordinate(ammocoord,Heading,"Ammodepot "..FName)
  base=base-delta
  
  local CommandPost = SPAWNSTATIC:NewFromStatic("Static FARP Command Post-1",country.id.USA)
  local CommandCoord = coord:Translate(125,base)
  CommandPost:SpawnFromCoordinate(CommandCoord,Heading,"Command Post "..FName)
  base=base-delta
  
  local Tent1 = SPAWNSTATIC:NewFromStatic("Static FARP Tent-1",country.id.USA)
  local Tent1Coord = coord:Translate(125,base)
  Tent1:SpawnFromCoordinate(Tent1Coord,Heading,"Command Tent "..FName)
  base=base-delta
  
  local Tent2 = SPAWNSTATIC:NewFromStatic("Static FARP Tent-1",country.id.USA)
  local Tent2Coord = coord:Translate(125,base)
  Tent2:SpawnFromCoordinate(Tent2Coord,Heading,"Command Tent2 "..FName)
   
  my_ctld:AddCTLDZone("FARP "..FName,CTLD.CargoZoneType.LOAD,SMOKECOLOR.Blue,true,true)
  local m  = MESSAGE:New(string.format("FARP %s in operation!",FName),15,"CTLD"):ToBlue()
  
  table.insert(BuiltFARPCoordinates,{name=FName,coord=Coordinate})

end

function LoadFARPS()
  local path = my_ctld.filepath
  local filename = FarpFileName
  local okay,data = UTILS.LoadFromFile(path,filename)
  if okay then
    --BASE:I({data})
    BASE:I("***** FARP Positions loaded successfully!")
    -- remove header
    table.remove(data, 1)
    for _,_entry in pairs(data) do
      local dataset = UTILS.Split(_entry,";")
      local x = tonumber(dataset[1])
      local y = tonumber(dataset[2])
      --BASE:I(string.format("X=%f | Y=%f",x,y))
      local coord = COORDINATE:NewFromVec2({x=x,y=y})
      BuildAFARP(coord)
    end
  else
    BASE:E("***** ERROR Loading FARP Positions!")
  end
end

local LoadFARPTimer = TIMER:New(LoadFARPS)
LoadFARPTimer:Start(5)

local SaveFARPTimer = TIMER:New(SaveFARPS)
SaveFARPTimer:Start(30,300)

function my_ctld:OnAfterCratesBuild(From,Event,To,Group,Unit,Vehicle)
  local name = Vehicle:GetName()
  if string.match(name,"FARP",1,true) then
    local Coord = Vehicle:GetCoordinate()
    Vehicle:Destroy(false)
    BuildAFARP(Coord) 
  end
end

---
-- Troops action
---

-- Cache new MOVE zones here
local RedMoveZones = {}

function BuildMoveZones(Group,Unit,Troops)
  -- find baddies near by with a ZONE filter
  local zone = nil
  if Group then
    zone = ZONE_GROUP:New(Group:GetName(),Group,6000)
  elseif Unit then
    zone = ZONE_UNIT:New(Unit:GetName(),Unit,6000)
  elseif Troops then
    zone = ZONE_GROUP:New(Troops:GetName(),Troops,6000)
  end
  local enemyset = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterZones({zone}):FilterOnce()
  if enemyset:Count() > 0 then
    --MESSAGE:New(string.format("Found %d enemy group(s) nearby!", enemyset:Count()),15):ToBlue()
    for _,_redgrp in pairs(enemyset.Set) do
      local redgrp = _redgrp -- Wrapper.Group#GROUP
      if not RedMoveZones[redgrp:GetName()] then
        -- baddies found, add zone around them
        local zonename = "Baddies-"..math.random(1,10000)
        local redzone = ZONE_GROUP:New(zonename,redgrp,200)
        --redzone:DrawZone(-1,{1,0.6,0},1,{1,0.6,0},0.25,4)
        BlueCTLD:AddCTLDZone(zonename,CTLD.CargoZoneType.MOVE,SMOKECOLOR.Orange,true,false)
        RedMoveZones[redgrp:GetName()] = redzone
      end
    end
  end
end

-- We're using OnBefore ... to add a MOVE zone
function my_ctld:OnBeforeTroopsDeployed(From,Event,To,Group,Unit,Troops)
  BuildMoveZones(Group,Unit,Troops)
  return self
end

-- We're using OnBefore ... to add a MOVE zone
function my_ctld:OnBeforeCratesBuild(From,Event,To,Group,Unit,Vehicle)
  BuildMoveZones(Group,Unit,Vehicle)
  return self
end

local ArmyGroups = {}

function my_ctld:OnAfterTroopsDeployed(From,Event,To,Group,Unit,Troops)
  local name = Troops:GetName()
  if string.match(name,"Mortar",1,true) then
    local m  = MESSAGE:New(string.format("Mortar %s in operation!",name),15,"CTLD"):ToBlue()
    local name = Troops:GetName()
    ArmyGroups[name] = ARMYGROUP:New(Troops)
  end
  --[[
  if string.match(name,"Howitzer",1,true) then
    local m  = MESSAGE:New(string.format("Howitzer %s in operation!",name),15,"CTLD"):ToBlue()
    local name = Troops:GetName()
    ArmyGroups[name] = ARMYGROUP:New(Troops)
  end
  --]]
end

function FindMortarTargets(Mortar)
  local mortar = Mortar -- Wrapper.Group#GROUP
  local mortarzone = ZONE_GROUP:New("MortarZone",mortar,7000)
  local redset = SET_UNIT:New():FilterCoalitions("red"):FilterCategories("ground"):FilterZones({mortarzone}):FilterOnce()
  local mortarcoord = mortar:GetCoordinate()
  local foundset = SET_UNIT:New()
  for _,_object in pairs (redset:GetSetObjects()) do
    local redgrp = _object -- Wrapper.Unit#UNIT
    local redcoo = redgrp:GetCoordinate()
    local dist = mortarcoord:Get2DDistance(redcoo)
    if dist <= 7000 then
      foundset:AddObject(redgrp)
    end
  end
  return foundset
end

function FireMortar(Armygroup)
  local Armygroup = Armygroup -- Ops.ArmyGroup#ARMYGROUP 
    local Troops = Armygroup:GetGroup()
    local inzoneset = FindMortarTargets(Troops)
    local rounds = math.random(60,120)
    local _grp = inzoneset:GetRandom()
    if _grp and _grp:IsAlive() and _grp:GetCoalition() == coalition.side.RED then
      local coord = _grp:GetCoordinate()
      --BASE:I("Adding fire task...")
      Armygroup:AddTaskFireAtPoint(coord,60,750,rounds)
    end
end

function CheckMortars()
  for _name,_armygroup in pairs(ArmyGroups) do
    if _armygroup and _armygroup:IsAlive() then
      FireMortar(_armygroup)
    else
      ArmyGroups[_name] = nil
    end
  end
end

local mortartimer = TIMER:New(CheckMortars)
mortartimer:Start(300,600)

my_ctld:__Start(2)
my_ctld:__Load(5)

 
 