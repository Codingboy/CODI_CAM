if (isNil "CODI_CAM_maxDist") then
{
	CODI_CAM_maxDist = 2000;
};
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
CODI_CAM_fnc_isInBuilding = {
	private["_unit","_dist","_pos","_intersections"];
	_unit = _this select 0;
	_dist = 10;
	_pos = eyePos _unit;
	_intersections = 0;
	if (lineIntersects [_pos, _pos vectorAdd [0, 0, _dist]]) then
	{
		_intersections = _intersections + 1;
	};
	if (lineIntersects [_pos, _pos vectorAdd [_dist, 0, 0]]) then
	{
		_intersections = _intersections + 1;
	};
	if (lineIntersects [_pos, _pos vectorAdd [-1*_dist, 0, 0]]) then
	{
		_intersections = _intersections + 1;
	};
	if (lineIntersects [_pos, _pos vectorAdd [0, _dist, 0]]) then
	{
		_intersections = _intersections + 1;
	};
	if (lineIntersects [_pos, _pos vectorAdd [0, -1*_dist, 0]]) then
	{
		_intersections = _intersections + 1;
	};
	_intersections > 3
};
if (isNil "CODI_CAM_fnc_calculateQuality") then
{
	CODI_CAM_fnc_calculateQuality = {
		private["_a","_b","_maxDist","_return","_dir","_pos","_targetPos","_offsetX","_offsetY","_maxHeight","_height","_ang"];
		_a = _this select 0;
		_b = _this select 1;
		_maxDist = _this select 2;
		_return = (_a distance _b)/_maxDist;
		if (_return >= 1) then
		{
			_return = 0;
		}
		else
		{
			_return = 1 - _return;
			if ([_a] call CODI_CAM_fnc_isInBuilding) then
			{
				_return = _return - 0.05;
			};
			if ([_b] call CODI_CAM_fnc_isInBuilding) then
			{
				_return = _return - 0.05;
			};
			_dir = [_a, _b] call BIS_fnc_dirTo;
			_pos = getPosASL _a;
			_targetPos = getPosASL _b;
			_offsetX = sin(_dir)*10;
			_offsetY = cos(_dir)*10;
			_maxHeight = [0,0,0];
			while {_pos distance2D _targetPos > 10} do
			{
				_pos = [(_pos select 0)+_offsetX, (_pos select 1)+_offsetY];
				_height = getTerrainHeightASL _pos;
				if (_height > (_maxHeight select 2)) then
				{
					_maxHeight = [_pos select 0, _pos select 1, _height];
				};
			};
			if ((_maxHeight select 2) > ((getPosASL _a) select 2) && (_maxHeight select 2) > ((getPosASL _b) select 2)) then
			{
				_ang = acos((_maxHeight vectorDiff (getPosASL _a)) vectorCos (_maxHeight vectorDiff (getPosASL _b)));
				if (_ang > 180) then
				{
					_ang = _ang - 180;
				};
				_return = _return * sin(_ang/2);
			};
		};
		_return
	};
};
CODI_CAM_fnc_update = {
	private["_factor","_qualityReduction","_maxDist","_return"];
	CODI_CAM_pos = ASLToAGL(eyePos CODI_CAM_unit);
	CODI_CAM_dir = eyeDirection CODI_CAM_unit;
	_factor = 0.15;
	CODI_CAM_pos = [(CODI_CAM_pos select 0)+(CODI_CAM_dir select 0)*_factor,(CODI_CAM_pos select 1)+(CODI_CAM_dir select 1)*_factor,(CODI_CAM_pos select 2)+(CODI_CAM_dir select 2)*_factor];
	CODI_CAM_cam camPrepareTarget [(CODI_CAM_pos select 0)+(CODI_CAM_dir select 0),(CODI_CAM_pos select 1)+(CODI_CAM_dir select 1),(CODI_CAM_pos select 2)+(CODI_CAM_dir select 2)];
	CODI_CAM_cam camPreparePos CODI_CAM_pos;
	CODI_CAM_cam camCommitPrepared 0;
	_qualityReduction = 1-([player, CODI_CAM_unit, CODI_CAM_maxDist] call CODI_CAM_fnc_calculateQuality);
	if (_qualityReduction >= 1) then
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
		case 1:
		{
			_return = true;
			call CODI_CAM_fnc_close;
		};
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
CODI_CAM_fnc_openTeams = {
	createDialog "CODI_CAM_SmartphoneTeams";
};
CODI_CAM_fnc_openUnits = {
	CODI_CAM_team = (_this select 0) lbText (_this select 1);
	closeDialog 0;
	createDialog "CODI_CAM_SmartphoneUnits";
	true
};
CODI_CAM_fnc_openUnit = {
	_unit = (_this select 0) lbText (_this select 1);
	closeDialog 0;
	{
		if (name _x == _unit) then
		{
			[_x] call CODI_CAM_fnc_open;
		};
	}
	forEach allUnits;
	true
};
CODI_CAM_fnc_handleMouseButtonClick = {
	private["_handled","_ctrl","_button","_mapControl","_pos","_nearesIndex","_nearestDistance","_distance","_marker"];
	_mapControl = _this select 0;
	_button = _this select 1;
	_pos = [_this select 2, _this select 3];
	_ctrl = _this select 5;
	_handled = false;
	if ([player] call CODI_CAM_fnc_canWatch) then
	{
		if (_ctrl) then
		{
			if (_button == 1) then
			{
				_allUnits = allUnits - [player];
				_nearestUnit = objNull;
				_distance = 999999;
				_worldPos = _mapControl ctrlMapScreenToWorld _pos;
				{
					if (side _x == side player) then
					{
						_dist = (getPos _x) distance2D _worldPos;
						if (_dist < _distance) then
						{
							_distance = _dist;
							_nearestUnit = _x;
						};
					};
				}
				forEach _allUnits;
				if (!isNull _nearestUnit) then
				{
					if (_pos distance2D(_mapControl ctrlMapWorldToScreen (getPos _nearestUnit)) < 0.05) then
					{
						if ([_nearestUnit] call CODI_CAM_fnc_canStream) then
						{
							[_nearestUnit] call CODI_CAM_fnc_open;
						};
					};
				};
			};
		};
	};
	_handled
};