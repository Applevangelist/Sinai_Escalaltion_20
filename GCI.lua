-------------------------------------
-- GCI
-------------------------------------

local AirWing = AIRWING:New("Warehouse Hatzor","Echo")
AirWing:SetMarker(false)
AirWing:Start()

local evileye = AWACS:New("Echo",AirWing,coalition.side.BLUE,AIRBASE.Sinai.Hatzor,"AwacsOrbit","Jerusalem","Hebron",271,radio.modulation.AM)
evileye:SetAsGCI(GROUP:FindByName("Blue EWR Hatzor"))
evileye:SetCallSignOptions(true,false)
evileye:SetCustomAWACSCallSign({
               [1]="Echo", -- Overlord
               [2]="Echo", -- Magic
               [3]="Echo", -- Wizard
               [4]="Echo", -- Focus
               [5]="Echo", -- Darkstar
               })
evileye:SetSRS(mySRSPath,nil,nil,mySRSPort,MSRS.Voices.Google.Standard.en_AU_Standard_B,1,mySRSGKey)
evileye:SetTacticalRadios(140,0.5,radio.modulation.AM,120,6)
evileye.PlayerCapAssignment = false
evileye.PikesSpecialSwitch = true
evileye.IncludeHelicopters = false
evileye:AddGroupToDetection(GROUP:FindByName("Blue EWR Hebron"))
evileye:__Start(2)
