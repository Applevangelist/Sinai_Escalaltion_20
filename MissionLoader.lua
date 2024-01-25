---
-- assert(loadfile("C:\\Users\\post\\Saved Games\\DCS\\Missions\\Sinai\\Escalation\\MissionLoader.lua"))()
---

local missionfiles = {
  [1] = "Configuration.lua",
  [2] = "Generals.lua",
  [3] = "CTLDCSAR.lua",
  [4] = "TaskManager.lua", 
  [5] = "Mantis.lua",
  [6] = "GCI.lua",
  [7] = "Navy.lua",
  [8] = "Airforce.lua",
  [9] = "Tanker.lua",
 [10] = "Autolase.lua"
}

local counter = 0
local path = "C:\\Users\\post\\Saved Games\\DCS\\Missions\\Sinai\\Escalation\\"

function Loader()
  counter = counter + 1
  local filename = missionfiles[counter]
  if filename then
  local filetoload = path..filename
    BASE:I(filetoload)
    assert(loadfile(filetoload))()
    MESSAGE:New("***** "..string.gsub(filename,".lua$","").." loaded! *****"):ToLog():ToAll()
  end
end

local loadtimer = TIMER:New(Loader)
loadtimer:Start(1,2,((2*#missionfiles)-1))
