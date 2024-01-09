-------------------------------------
-- GCI
-------------------------------------


local anvil = PLAYERTASKCONTROLLER:New("Anvil",coalition.side.BLUE,PLAYERTASKCONTROLLER.Type.A2G)
anvil:SetMenuName("Anvil")
anvil:SetMenuOptions(true)
anvil:SetSRS({135,255},{radio.modulation.AM, radio.modulation.AM},mySRSPath,nil,nil,mySRSPort,MSRS.Voices.Google.Standard.en_GB_Standard_D,1,mySRSGKey,nil,AIRBASE:FindByName(AIRBASE.Sinai.Tel_Nof):GetCoordinate())
anvil:SetSRSBroadcast(243,radio.modulation.AM)
anvil:SetCallSignOptions(true,false)
anvil:SetEnableIlluminateTask()
anvil:SetTransmitOnlyWithPlayers(true)
anvil:SetEnableUseTypeNames()
anvil:EnableTaskInfoMenu()

local TgtSetOne = SET_ZONE:New():FilterPrefixes("army_fuel_tank"):FilterOnce()
local scensetone = SET_SCENERY:New(TgtSetOne)
local ScenTask = PLAYERTASK:New(AUFTRAG.Type.BOMBING,TARGET:New(scensetone),true,5,"Destroy the fuel tanks at Nevatim Airbase!")
ScenTask:SetMenuName("Bomb Fuel Tanks")
ScenTask:AddFreetext("Destroy the fuel tanks at Nevatim Airbase!")
ScenTask:AddFreetextTTS(("Destroy the fuel tanks at Nevatim Airbase!"))
anvil:AddPlayerTaskToQueue(ScenTask)