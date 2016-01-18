_teams = [];
_units = playableUnits;
_units = _units - [player];
{
	if (side _x == side player) then
	{
		_callsign = groupId(group _x);
		if (!(_callsign in _teams)) then
		{
			_teams pushBack _callsign;
			_index = lbAdd[4244, _callsign];
			_color = [1,1,1,1];
			lbSetColor [4244, _index, _color];
		};
	};
}
forEach _units;
