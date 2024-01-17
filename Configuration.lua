-------------------------------------
-- Configuration
-------------------------------------

if BASE.ServerName and BASE.ServerName ~= "DCS Server" then
  mySRSPath = "C:\\Users\\jgf\\Desktop\\srs\\srs-private"
  mySRSPort = 5004
  mySRSGKey = "C:\\Users\\jgf\\Desktop\\srs\\srs-training2\\theta-mile-349308-0ca2eeb17600.json"
  SavePath = "C:\\Users\\jgf\\Saved Games\\DCS.openbeta_server_private\\persistent-data"
else
  MSRS.LoadConfigFile()
  GRPC.debug = true
  GRPC.integrityCheckDisabled = true
  GRPC.load()
  mySRSPath = "E:\\Program Files\\DCS-SimpleRadio-Standalone"
  mySRSPort = 5002
  mySRSGKey = "E:\\Program Files\\DCS-SimpleRadio-Standalone\\theta-mile-349308-0ca2eeb17600.json"
  SavePath = "C:\\Users\\post\\Saved Games\\DCS\\Missions\\Sinai\\Escalation\\Persistenz"
end

_SETTINGS:SetPlayerMenuOn()
_SETTINGS:SetA2G_MGRS()
_SETTINGS:SetMGRS_Accuracy(3)
_SETTINGS:SetImperial()

PhaseAirbases = {
  [1] = {AIRBASE.Sinai.Kedem,AIRBASE.Sinai.Hatzerim,AIRBASE.Sinai.Nevatim,AIRBASE.Sinai.Ramon_Airbase,AIRBASE.Sinai.Ovda},
  [2] = {AIRBASE.Sinai.El_Arish,AIRBASE.Sinai.El_Gora,AIRBASE.Sinai.Melez,AIRBASE.Sinai.Bir_Hasanah,AIRBASE.Sinai.Abu_Rudeis,AIRBASE.Sinai.St_Catherine},
  [3] = {AIRBASE.Sinai.Baluza,AIRBASE.Sinai.As_Salihiyah,AIRBASE.Sinai.Al_Ismailiyah,AIRBASE.Sinai.Abu_Suwayr,AIRBASE.Sinai.Difarsuwar_Airfield,AIRBASE.Sinai.Fayed,AIRBASE.Sinai.Kibrit_Air_Base},
  [4] = {AIRBASE.Sinai.Al_Mansurah,AIRBASE.Sinai.Cairo_International_Airport,AIRBASE.Sinai.Cairo_West,AIRBASE.Sinai.AzZaqaziq,AIRBASE.Sinai.Bilbeis_Air_Base,AIRBASE.Sinai.Inshas_Airbase,AIRBASE.Sinai.Wadi_al_Jandali},
}

PhaseBorderNames = {}
PhaseBorderZones = {}
for i=1,4 do
  PhaseBorderNames[i] = "Phase "..i.." Border"
  PhaseBorderZones[i] = ZONE:New(PhaseBorderNames[i])
end

UseAirboss = false

--- TODO Load/Save Phase State

CurrentPhase = 1

---
AIRBASE:FindByName(AIRBASE.Sinai.Ramon_Airbase):SetParkingSpotWhitelist({31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,37,48,49,50,51,52,61,62,63,64,65,66,99,100,101,102,103,104,105,106,107})
AIRBASE:FindByName(AIRBASE.Sinai.Ovda):SetParkingSpotWhitelist({4,5,6,7,8,9,30,31,32,33,34,35,36,37,38,39,40,41,42,43,48,49,50,51,52,53,72,73,74,75,76,77,78,79,80,81,82,83,84,85})

-------------------------------------
-- Remove non-phase ground units
-------------------------------------

for Phase = 1,4 do
  if Phase ~= CurrentPhase then
  
    -- Filter out SAM groups
     local function FilterOut(grp)
      if grp and grp:IsAlive() then
        local name = grp:GetName()
        if string.find(name,"SAM",1,true) or string.find(name,"EW",1,true) then
          return false
        else
          return true
        end
      end
      return false
     end
  
     local set = SET_GROUP:New():FilterCategoryGround():FilterCoalitions("red"):FilterPrefixes({"Ph"..Phase}):FilterFunction(FilterOut):FilterOnce()
     set:ForEach(
      function(grp)
        if grp and grp:IsAlive() then
          grp:Destroy(false)
        end
      end
     )
  end
end

-------------------------------------
-- Persistenz
-------------------------------------

local redgroundfilename = "RedGround_"..CurrentPhase..".csv"
local redspawnedgroundfilename = "RedGroundSpawned_"..CurrentPhase..".csv"
local bluegroundfilename = "BlueGroundSpawned_"..CurrentPhase..".csv"
local redstaticsfilename = "RedStatics_"..CurrentPhase..".csv"

local reddynamic = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterPrefixes({"Spetznatz","Grouse"}):FilterStart()
local bluedynamic = SET_GROUP:New():FilterCoalitions("blue"):FilterCategoryGround():FilterPrefixes({"Marines","ADStinger"}):FilterStart()

local redgroups = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterPrefixes({"Ph"..CurrentPhase}):FilterOnce()
local redstatics = SET_STATIC:New():FilterCoalitions("red"):FilterOnce()

function SaveGround()
  local names = redgroups:GetSetNames()
  UTILS.SaveStationaryListOfGroups(names,SavePath,redgroundfilename,true)
  local snames = redstatics:GetSetNames()
  UTILS.SaveStationaryListOfStatics(snames,SavePath,redstaticsfilename)
  UTILS.SaveSetOfGroups(reddynamic,SavePath,redspawnedgroundfilename,true)
  UTILS.SaveSetOfGroups(bluedynamic,SavePath,bluegroundfilename,true)
end

function LoadGround()
  UTILS.LoadStationaryListOfGroups(SavePath,redgroundfilename,true,true,false)
  UTILS.LoadStationaryListOfStatics(SavePath,redstaticsfilename,true,true,false)
  UTILS.LoadSetOfGroups(SavePath,redspawnedgroundfilename,true,true,false)
  UTILS.LoadSetOfGroups(SavePath,bluegroundfilename,true,true,false)
end

local SaveTimer = TIMER:New(SaveGround)
SaveTimer:Start(10,300)

local LoadTimer = TIMER:New(LoadGround)
LoadTimer:Start(2)

