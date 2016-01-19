CODI_CAM is gives you the possibillity to watch a stream from a helmet camera of a friendly unit.
To view a unit you can open the map, hold control and rightclick the unit you want to view.

Distance, buildings and terrain intercept the quality of the videofeed.

ACE:
To watch a feed you need a CODI_CAM_Tablet.
To broadcast your view you need a CODI_CAM_Camera.

Missionmakers:
You can set the maximum distance by editing CODI_CAM_maxDist. (default: 2000)
You can also implement your own quality algorithm by setting
CODI_CAM_fnc_calculateQuality = {
	_a = _this select 0;
	_b = _this select 1;
	_maxDist = _this select 2;
	_return
};