waitUntil{!isNull player};
if (!(isClass (configFile >> "CfgPatches" >> "CODI_CAM_ACE"))) then
{
	player addAction ["Open Cam", {[] call CODI_CAM_fnc_openTeams;}];
	player addMPEventHandler ["MPRespawn", {player addAction ["Open Cam", {[] call CODI_CAM_fnc_openTeams;}];}];
};