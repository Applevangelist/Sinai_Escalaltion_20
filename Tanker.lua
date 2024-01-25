-------------------------------------
-- Tanker
-------------------------------------

local TankWacsWing = AIRWING:New("Ben-Gurion","63rd Tanker Squad")
TankWacsWing:SetMarker(false)
TankWacsWing:SetAirbase(AIRBASE:FindByName(AIRBASE.Sinai.Ben_Gurion))
local TankerPoint = ZONE:FindByName("Tanker Point"):GetCoordinate()
local AwacsPoint = ZONE:FindByName("Tanker Point"):GetCoordinate()
TankWacsWing:AddPatrolPointTANKER(TankerPoint,22000,UTILS.KnotsToAltKIAS(300,22000),284,50,0)
TankWacsWing:AddPatrolPointTANKER(TankerPoint,18000,UTILS.KnotsToAltKIAS(300,18000),284,50,1)
TankWacsWing:AddPatrolPointAWACS(AwacsPoint,25000,300,294,40)
TankWacsWing:SetNumberTankerBoom(1)
TankWacsWing:SetNumberTankerProbe(1)
TankWacsWing:SetNumberAWACS(1)
--TankWacsWing:SetVerbosity(3)
TankWacsWing:Start()

local TankerProbe =  SQUADRON:New("Texaco 1-1",20,"Texaco")
TankerProbe:AddMissionCapability({AUFTRAG.Type.TANKER},75)
TankerProbe:SetRadio(267,radio.modulation.AM)
TankerProbe:AddTacanChannel(11,11)
TankerProbe:SetMissionRange(200)
TankerProbe:SetCallsign(CALLSIGN.Tanker.Texaco,1)
TankerProbe:SetModex(611)
TankerProbe:SetLivery("Standard USAF")
TankerProbe:SetTakeoffHot()

local TankerBoom = SQUADRON:New("Shell 1-1",20,"Shell")
TankerBoom:AddMissionCapability({AUFTRAG.Type.TANKER},75)
TankerBoom:SetRadio(268,radio.modulation.AM)
TankerBoom:AddTacanChannel(12,12)
TankerBoom:SetMissionRange(200)
TankerBoom:SetCallsign(CALLSIGN.Tanker.Shell,1)
TankerBoom:SetModex(612)
TankerBoom:SetLivery("RAF RC135")
TankerProbe:SetTakeoffHot()

local Awacs = SQUADRON:New("Blue AWACS",20,"Blue AWACS")
Awacs:AddMissionCapability({AUFTRAG.Type.AWACS},75)
Awacs:SetRadio(263,radio.modulation.AM)
Awacs:SetMissionRange(200)
Awacs:SetCallsign(CALLSIGN.AWACS.Overlord,1)
Awacs:SetTakeoffHot()
Awacs:SetModex(613)

TankWacsWing:AddSquadron(TankerBoom)
TankWacsWing:NewPayload(UNIT:FindByName("Shell 1-1"),20,{AUFTRAG.Type.TANKER},75)

TankWacsWing:AddSquadron(TankerProbe)
TankWacsWing:NewPayload(UNIT:FindByName("Texaco 1-1"),20,{AUFTRAG.Type.TANKER},75)

TankWacsWing:AddSquadron(Awacs)
TankWacsWing:NewPayload(UNIT:FindByName("Blue Awacs-1-1"),20,{AUFTRAG.Type.AWACS},75)

function TankWacsWing:OnAfterFlightOnMission(From,Event,To,FlightGroup,Mission)
  if FlightGroup then
    FlightGroup:GetGroup():CommandSetUnlimitedFuel(true):SetCommandInvisible(true):CommandSetUnlimitedFuel(true,1)
  end
end