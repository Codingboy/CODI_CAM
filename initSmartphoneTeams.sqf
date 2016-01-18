{
	if (side _x == side player) then
	{
		_hasStreamer = false;
		{
			if ([_x] call CODI_CAM_fnc_canStream && _x != player) then
			{
				_hasStreamer = true;
			};
		}
		forEach (units _x);
		if (_hasStreamer) then
		{
			_callsign = groupId(_x);
			_index = lbAdd[4244, _callsign];
			_color = [1,1,1,1];
			lbSetColor [4244, _index, _color];
		};
	};
}
forEach allGroups;
