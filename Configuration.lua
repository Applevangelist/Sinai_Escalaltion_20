-------------------------------------
-- Configuration
-------------------------------------

if BASE.ServerName and BASE.ServerName ~= "DCS Server" then
  mySRSPath = "C:\Users\jgf\Desktop\srs\srs-private"
  mySRSPort = 5010
  mySRSGKey = "C:\\Users\\jgf\\Desktop\\srs\\srs-training2\\theta-mile-349308-0ca2eeb17600.json"
  SavePath = "C:\Users\jgf\Saved Games\DCS.openbeta_server_private\persistent-data"
else
  MSRS.SetDefaultBackendGRPC()
  MSRS.LoadConfigFile()
  GRPC.debug = true
  GRPC.integrityCheckDisabled = true
  GRPC.load()
  mySRSPath = "E:\\Program Files\\DCS-SimpleRadio-Standalone"
  mySRSPort = 5002
  mySRSGKey = "E:\\Program Files\\DCS-SimpleRadio-Standalone\\theta-mile-349308-0ca2eeb17600.json"
  SavePath = "C:\\Users\\post\\Saved Games\\DCS\\Missions\\Sinai\\Escalation\\Persistenz"
end

CurrentPhase = 1

for Phase = 1,4 do
  if Phase ~= CurrentPhase then
  
    -- Filter out SAM groups
     local function FilterOut(grp)
      if grp and grp:IsAlive() then
        local name = grp:GetName()
        if string.find(name,"SAM",1,true) then
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

local redgroundfilename = "RedGround.csv"
local redstaticsfilename = "RedStatics.csv"

function SaveGround()
  local redgroups = SET_GROUP:New():FilterCoalitions("red"):FilterCategoryGround():FilterPrefixes({"Ph"..CurrentPhase}):FilterOnce()
  local names = redgroups:GetSetNames()
  UTILS.SaveStationaryListOfGroups(names,SavePath,redgroundfilename,true)
  local redstatics = SET_STATIC:New():FilterCoalitions("red"):FilterOnce()
  local snames = redstatics:GetSetNames()
  UTILS.SaveStationaryListOfStatics(snames,SavePath,redstaticsfilename)
end

function LoadGround()
  UTILS.LoadStationaryListOfGroups(SavePath,redgroundfilename,true,true,true,5,Density)
  UTILS.LoadStationaryListOfStatics(SavePath,redstaticsfilename,true,true,true,5,Density)
end

local SaveTimer = TIMER:New(SaveGround)
SaveTimer:Start(10,300)

local LoadTimer = TIMER:New(LoadGround)
LoadTimer:Start(2)

