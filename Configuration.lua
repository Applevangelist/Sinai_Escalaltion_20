-------------------------------------
-- Configuration
-------------------------------------

if BASE.ServerName and BASE.ServerName ~= "DCS Server" then
  mySRSPath = "C:\Users\jgf\Desktop\srs\srs-private"
  mySRSPort = 5010
  mySRSGKey = "C:\\Users\\jgf\\Desktop\\srs\\srs-training2\\theta-mile-349308-0ca2eeb17600.json"
  SavePath = "C:\Users\jgf\Saved Games\DCS.openbeta_server_private\persistent-data"
else
  MSRS.SetDefaultBackendGRPC()
  MSRS.LoadConfigFile()
  GRPC.debug = true
  GRPC.integrityCheckDisabled = true
  GRPC.load()
  mySRSPath = "E:\\Program Files\\DCS-SimpleRadio-Standalone"
  mySRSPort = 5002
  mySRSGKey = "E:\\Program Files\\DCS-SimpleRadio-Standalone\\theta-mile-349308-0ca2eeb17600.json"
  SavePath = "C:\\Users\\post\\Saved Games\\DCS\\Missions\\Sinai\\Escalation\\Persistenz"
end


