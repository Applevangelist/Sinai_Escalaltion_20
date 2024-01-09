

-------------------------------------
-- PlayerRecce
-------------------------------------
local HeloPrefixes = { "UH", "SA342", "Mi-8", "Mi-24", "AH-64"}
local PlayerSet = SET_CLIENT:New():FilterCoalitions("blue"):FilterCategories("helicopter"):FilterPrefixes(HeloPrefixes):FilterStart()
local HeloRecce = PLAYERRECCE:New("Blue HeloRecce",coalition.side.BLUE,PlayerSet)
HeloRecce:SetCallSignOptions(true,false)
HeloRecce:SetMenuName("Scouting")
HeloRecce:SetTransmitOnlyWithPlayers(true)
HeloRecce:SetSRS({140,240},{radio.modulation.AM,radio.modulation.AM},mySRSPath,"male","en-IR",mySRSPort,MSRS.Voices.MicrosoftGRPC.Susan,1)
HeloRecce.SRS:SetProvider(MSRS.Provider.WINDOWS)
HeloRecce.SRS:SetVoice("Sean")