BASE:E("Mission Load, Loading Const. RED CAP")
--CONST RED
-- Setting and Zones for Dispatcher
REDAIRSPACE = ZONE:New("RED AIRSPACE")
REDCAP1 = ZONE:New("RED CAP 1")
-- END CONST RED

BASE:E("Mission Load, Loading Const. RED CAP Ready")

-- RED CAP AI
BASE:E("Mission Load, Loading RED CAP")
-- Setup Red Detection Group for AWACS and RADAR
REDDetectionGroup = SET_GROUP:New()
REDDetectionGroup:FilterPrefixes({"RED AWACS","RED EW"})
REDDetectionGroup:FilterStart()

RedDet = DETECTION_AREAS:New(REDDetectionGroup,30000)

-- Dispatcher
REDA2ADISP = AI_A2A_DISPATCHER:New(RedDet)

REDA2ADISP:SetBorderZone(REDAIRSPACE)
REDA2ADISP:SetEngageRadius(50000)
REDA2ADISP:SetDefaultDamageThreshold(0.4)
REDA2ADISP:SetDefaultFuelThreshold(0.4)
REDA2ADISP:SetDefaultGrouping(2)
REDA2ADISP:SetDefaultLandingAtEngineShutdown()
REDA2ADISP:SetDefaultTakeoffFromParkingCold()

REDA2ADISP:SetGciRadius(100000)
REDA2ADISP:SetIntercept(450)
REDA2ADISP:SetTacticalDisplay(false)

if ((AIRBASE:FindByName(AIRBASE.Sinai.Ramon_Airbase):GetCoalition()) == coalition.side.RED)then 
  -- REDCAP 1
  --- Ramon Squad  
  
  REDA2ADISP:SetSquadron("Ramon Squad",AIRBASE.Sinai.Ramon_Airbase,{"RED MIG29 TEMPLATE", "RED MIG21 TEMPLATE"},24)
  REDA2ADISP:SetSquadronCap("Ramon Squad",REDCAP1,UTILS.FeetToMeters(10000),UTILS.FeetToMeters(35000),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(437),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(600),"BARO")
  REDA2ADISP:SetSquadronCapInterval("Ramon Squad",2,180,600,1)
  REDA2ADISP:SetSquadronOverhead("Ramon Squad",1.5)
  REDA2ADISP:SetSquadronTakeoffFromParkingCold("Ramon Squad")
  REDA2ADISP:SetSquadronLanding("Ramon Squad",AI_A2A_DISPATCHER.Landing.AtEngineShutdown)
  REDA2ADISP:SetSquadronVisible("Ramon Squad")
  
  -- Nevatim Squad
  REDA2ADISP:SetSquadron("Nevatim Squad",AIRBASE.Sinai.Nevatim,{"RED MIG21 TEMPLATE"},6)
  REDA2ADISP:SetSquadronOverhead("Nevatim Squad",1.5)
  REDA2ADISP:SetSquadronGci("Nevatim Squad",UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(600))
end

if ((AIRBASE:FindByName(AIRBASE.Sinai.Ovda):GetCoalition()) == coalition.side.RED) then 
-- REDCAP 2
--- Ovda Squad 
  red_awacs = SPAWN:New("RED_AWACS_1")
  redawacsgroup = red_awacs:Spawn()
  
  REDA2ADISP:SetSquadron("Ovda Squad",AIRBASE.Sinai.Ovda,{"RED MIG29 TEMPLATE","RED MIG21 TEMPLATE"},12)
  REDA2ADISP:SetSquadronCap("Ovda Squad",REDCAP1,UTILS.FeetToMeters(10000),UTILS.FeetToMeters(35000),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(437),UTILS.KnotsToKmph(400),UTILS.KnotsToKmph(600),"BARO")
  REDA2ADISP:SetSquadronCapInterval("Ovda Squad",2,180,600,1)
  REDA2ADISP:SetSquadronOverhead("Ovda Squad",1.5)
  REDA2ADISP:SetSquadronTakeoffFromParkingCold("Ovda Squad")
  REDA2ADISP:SetSquadronLanding("Ovda Squad",AI_A2A_DISPATCHER.Landing.AtEngineShutdown)
  REDA2ADISP:SetSquadronVisible("Ovda Squad")
end


REDA2ADISP:Start()
BASE:E("Mission Load, Loading RED CAP Ready")

--END RED CAP AI

BASE:E("Mission Load, Loading RED A2G DISP Sochi Ready")