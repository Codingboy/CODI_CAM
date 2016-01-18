CODI_CAM_maxDist = 50;
CODI_CAM_colorCorrections = -1;

CODI_CAM_fnc_open = {
	private["_display","_unit"];
	disableSerialization;
	_unit = _this select 0;
	CODI_CAM_unit = _unit;
	CODI_CAM_cam = "camera" camCreate ASLToAGL(eyePos _unit);
	CODI_CAM_cam cameraEffect ["internal","back"];
	showCinemaBorder false;
	["CODI_CAM_update", "onEachFrame", {call CODI_CAM_fnc_update;}] call BIS_fnc_addStackedEventHandler;
	_display = findDisplay 46;
	CODI_CAM_keyDownEH = _display displayAddEventHandler ["KeyDown","_this call CODI_CAM_fnc_keyDownEH"];
};
CODI_CAM_fnc_update = {
	CODI_CAM_pos = ASLToAGL(eyePos CODI_CAM_unit);
	_factor = 0.15;
	CODI_CAM_pos = [(CODI_CAM_pos select 0)+(CODI_CAM_dir select 0)*_factor,(CODI_CAM_pos select 1)+(CODI_CAM_dir select 1)*_factor,(CODI_CAM_pos select 2)+(CODI_CAM_dir select 2)*_factor];
	CODI_CAM_dir = eyeDirection CODI_CAM_unit;
	CODI_CAM_cam camPrepareTarget [(CODI_CAM_pos select 0)+(CODI_CAM_dir select 0),(CODI_CAM_pos select 1)+(CODI_CAM_dir select 1),(CODI_CAM_pos select 2)+(CODI_CAM_dir select 2)];
	CODI_CAM_cam camPreparePos CODI_CAM_pos;
	CODI_CAM_cam camCommitPrepared 0;
	_qualityReduction = (player distance CODI_CAM_unit)/CODI_CAM_maxDist;
	if (_qualityReduction > 1) then
	{
		CODI_CAM_colorCorrections = ppEffectCreate ["ColorCorrections",2006];
		CODI_CAM_colorCorrections ppEffectEnable true;
		CODI_CAM_colorCorrections ppEffectAdjust [
			0,
			0,
			0,
			0, 0, 0, 0, 
			1, 1, 1, 1, 
			0.299, 0.587, 0.114, 0
		];
		CODI_CAM_colorCorrections ppEffectCommit 0;
	}
	else
	{
		if (CODI_CAM_colorCorrections != -1) then
		{
			ppEffectDestroy CODI_CAM_colorCorrections;
			CODI_CAM_colorCorrections = -1;
		};
	};
	CODI_CAM_ppGrain = ppEffectCreate ["filmGrain",2005];
	CODI_CAM_ppGrain ppEffectEnable true;
	CODI_CAM_ppGrain ppEffectAdjust [_qualityReduction,1,1,_qualityReduction,_qualityReduction];
	CODI_CAM_ppGrain ppEffectCommit 0;
};
CODI_CAM_fnc_close = {
	private["_display"];
	disableSerialization;
	camUseNVG false;
	ppEffectDestroy CODI_CAM_ppGrain;
	if (CODI_CAM_colorCorrections != -1) then
	{
		ppEffectDestroy CODI_CAM_colorCorrections;
		CODI_CAM_colorCorrections = -1;
	};
	_display = findDisplay 46;
	_display displayRemoveEventHandler ["KeyDown", CODI_CAM_keyDownEH];
	CODI_CAM_cam cameraEffect ["terminate","back"];
	camDestroy CODI_CAM_cam;
	["CODI_CAM_update", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};
CODI_CAM_fnc_keyDownEH = {
	private["_keyCode","_return"];
	_keyCode = _this select 1;
	_return = false;
	switch (_keyCode) do
	{
		_return = true;
		call CODI_CAM_fnc_close;
	};
	_return
};
CODI_CAM_fnc_canWatch = {
	private["_unit","_ret"];
	_unit = _this select 0;
	_ret = true;
	if (isClass (configFile >> "CfgPatches" >> "CODI_CAM_ACE")) then
	{
		_ret = [_unit, "CODI_CAM_Tablet"] call ace_common_fnc_hasItem;
	};
	_ret
};
CODI_CAM_fnc_canStream = {
	private["_unit","_ret"];
	_unit = _this select 0;
	_ret = true;
	if (isClass (configFile >> "CfgPatches" >> "CODI_CAM_ACE")) then
	{
		_ret = [_unit, "CODI_CAM_Camera"] call ace_common_fnc_hasItem;
	};
	_ret
};