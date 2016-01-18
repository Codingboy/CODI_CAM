_units = allUnits;
_units = _units - [player];
{
	if (side _x == side player) then
	{
		_callsign = groupId(group _x);
		if (_callsign == CODI_CAM_team) then
		{
			if ([_x] call CODI_CAM_fnc_canStream) then
			{
				_index = lbAdd[4245, name _x];
				_color = [1,1,1,1];
				lbSetColor [4245, _index, _color];
			};
		};
	};
}
forEach _units;
