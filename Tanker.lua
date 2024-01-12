-------------------------------------
-- Tanker
-------------------------------------

local TankwerWing = AIRWING:New("Ben-Gurion","63rd Tanker Squad")
TankwerWing:SetMarker(false)
TankwerWing:SetAirbase(AIRBASE:FindByName(AIRBASE.Sinai.Ben_Gurion))
local TankerPoint = ZONE:FindByName("Tanker Point"):GetCoordinate()
TankwerWing:AddPatrolPointTANKER(TankerPoint,22000,275,284,50,0)
TankwerWing:AddPatrolPointTANKER(TankerPoint,18000,275,284,50,1)
TankwerWing:SetNumberTankerBoom(1)
TankwerWing:SetNumberTankerProbe(1)
--TankwerWing:SetVerbosity(3)
TankwerWing:Start()

local TankerProbe =  SQUADRON:New("Texaco 1-1",20,"Texaco")
TankerProbe:AddMissionCapability({AUFTRAG.Type.TANKER},75)
TankerProbe:SetRadio(267,radio.modulation.AM)
TankerProbe:AddTacanChannel(11,11)
TankerProbe:SetMissionRange(200)
TankerProbe:SetCallsign(CALLSIGN.Tanker.Texaco,1)
TankerProbe:SetModex(611)
TankerProbe:SetLivery("Standard USAF")

local TankerBoom = SQUADRON:New("Shell 1-1",20,"Shell")
TankerBoom:AddMissionCapability({AUFTRAG.Type.TANKER},75)
TankerBoom:SetRadio(268,radio.modulation.AM)
TankerBoom:AddTacanChannel(12,12)
TankerBoom:SetMissionRange(200)
TankerBoom:SetCallsign(CALLSIGN.Tanker.Shell,1)
TankerBoom:SetModex(612)
TankerBoom:SetLivery("RAF RC135")

TankwerWing:AddSquadron(TankerBoom)
TankwerWing:NewPayload(UNIT:FindByName("Shell 1-1"),20,{AUFTRAG.Type.TANKER},75)

TankwerWing:AddSquadron(TankerProbe)
TankwerWing:NewPayload(UNIT:FindByName("Texaco 1-1"),20,{AUFTRAG.Type.TANKER},75)

function TankwerWing:OnAfterFlightOnMission(From,Event,To,FlightGroup,Mission)
  if FlightGroup then
    FlightGroup:GetGroup():CommandSetUnlimitedFuel(true):SetCommandInvisible(true)
  end
end