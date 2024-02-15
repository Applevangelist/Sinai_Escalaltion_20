-------------------------------------
-- GCI
-------------------------------------

local AirWing = AIRWING:New("Warehouse Hatzor","Echo")
AirWing:SetMarker(false)
AirWing:Start()

local evileye = AWACS:New("Echo",AirWing,coalition.side.BLUE,AIRBASE.Sinai.Hatzor,"AwacsOrbit","Jerusalem","Hebron",266,radio.modulation.AM)
evileye.DetectionSet = SET_GROUP:New():FilterCoalitions("blue"):FilterPrefixes({"Blue EWR", "AWACS", "Blue SAM"}):FilterStart()
evileye:SetAsGCI(GROUP:FindByName("Blue EWR Hatzor"))
evileye:SetCallSignOptions(true,true)
evileye:SetCustomAWACSCallSign({
               [1]="Echo", -- Overlord
               [2]="Echo", -- Magic
               [3]="Echo", -- Wizard
               [4]="Echo", -- Focus
               [5]="Echo", -- Darkstar
               })
evileye:SetSRS(mySRSPath,nil,nil,mySRSPort,MSRS.Voices.Google.Standard.en_AU_Standard_B,1,mySRSGKey)
evileye:SetTacticalRadios(130.5,1,radio.modulation.AM,60,9)
evileye.PlayerCapAssignment = false
evileye.PikesSpecialSwitch = true
evileye.IncludeHelicopters = false
evileye:AddGroupToDetection(GROUP:FindByName("Blue EWR Hebron"))
evileye.ControlZoneRadius = 200
evileye:__Start(2)
