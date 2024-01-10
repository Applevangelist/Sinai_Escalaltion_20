-------------------------------------
-- NAVY
-------------------------------------

local RecoveryTanker = RECOVERYTANKER:New(UNIT:FindByName("CVN-73 Battle Group-1"),"RescueTanker")
RecoveryTanker:SetRadio(269)
RecoveryTanker:SetTACAN(74,"SHL","Y")
RecoveryTanker:SetTakeoffHot()
RecoveryTanker:SetCallsign(CALLSIGN.Tanker.Navy_One,1)
RecoveryTanker:SetUnlimitedFuel(true)
RecoveryTanker:__Start(2)

-- STN 02000
local AWACS = RECOVERYTANKER:New(UNIT:FindByName("CVN-73 Battle Group-1"),"CarrierAWACS")
AWACS:SetAWACS(true,false)
AWACS:SetTakeoffHot()
AWACS:SetCallsign(CALLSIGN.AWACS.Wizard,1)
AWACS:SetRadio(265)
AWACS:SetAltitude(20000)
AWACS:__Start(3)

local RescueHelo = RESCUEHELO:New(UNIT:FindByName("CVN-73 Battle Group-1"),"RescueHelo")
RescueHelo:SetTakeoffHot()
RescueHelo:__Start(4)

local GWA = AIRBOSS:New("CVN-73 Battle Group-1","CVN-73")
GWA:SetAirbossNiceGuy(true)
GWA:SetTACAN(73,"X","GWA")
GWA:SetICLS(1,"GWA")
GWA:SetAWACS(AWACS)
GWA:SetRecoveryTanker(RecoveryTanker)
GWA:SetMenuSingleCarrier(true)
GWA:SetMenuRecovery(30,25)
GWA:SetDefaultPlayerSkill(AIRBOSS.Difficulty.NORMAL)
GWA:EnableSRS(mySRSPath,mySRSPort,nil,nil,MSRS.Voices.Google.Standard.en_US_Standard_F,mySRSGKey)
GWA:SetAirbossRadio(227.5,"AM",MSRS.Voices.Google.Standard.en_US_Standard_G)
GWA:SetLSORadio(305,"AM",MSRS.Voices.Google.Standard.en_US_Standard_H)
GWA:SetMarshalRadio(295,"AM",MSRS.Voices.Google.Standard.en_US_Standard_J)
GWA:SetSRSPilotVoice(MSRS.Voices.Google.Standard.en_US_Standard_I)
GWA:__Start(1)

AIRBASE:FindByName("CVN-73 Battle Group-1"):SetRadioSilentMode(true)