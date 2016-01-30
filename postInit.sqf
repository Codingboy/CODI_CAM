if (hasInterface) then
{
	waitUntil{!isNull player};
	if (!(isClass (configFile >> "CfgPatches" >> "CODI_CAM_ACE"))) then
	{
		player addAction ["Open Cam", {[] call CODI_CAM_fnc_openTeams;}];
		player addMPEventHandler ["MPRespawn", {player addAction ["Open Cam", {[] call CODI_CAM_fnc_openTeams;}];}];
	};
	disableSerialization;
	waitUntil{!isNull(findDisplay 12)};
	_mapDisplay = findDisplay 12;
	_mapControl = _mapDisplay displayCtrl 51;
	_mapControl ctrlAddEventHandler ["MouseButtonClick", {_this call CODI_CAM_fnc_handleMouseButtonClick;}];
};