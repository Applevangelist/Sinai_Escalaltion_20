

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
