class CODI_CAM_Picture
{
	access = 0;
	idc = -1;
	type = 0;
	style = 48;
	linespacing = 1;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	text = "";
	shadow = 2;
	font = "Bitstream";
	sizeEx = "0.02 / (getResolution select 5)";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0;
	w = 0;
};
class CODI_CAM_List
{
	access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
	idc = -1; // Control identification (without it, the control won't be displayed)
	type = 5; // Type is 5
	style = 0 + 16; // Style
	default = 0; // Control selected by default (only one within a display can be used)
	blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.

	x = 1 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X; // Horizontal coordinates
	y = 11 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y; // Vertical coordinates
	w = 10 * GUI_GRID_CENTER_W; // Width
	h = 3 * GUI_GRID_CENTER_H; // Height

	colorBackground[] = {0.75,0.75,0.75,0.5}; // Fill color
	colorSelectBackground[] = {0.75,0.75,0.75,0.5}; // Selected item fill color
	colorSelectBackground2[] = {0.75,0.75,0.75,0.5}; // Selected item fill color (oscillates between this and colorSelectBackground)

	sizeEx = "0.04 / (getResolution select 5)"; // Text size
	font = "PuristaMedium"; // Font from CfgFontFamilies
	shadow = 0; // Shadow (0 - none, 1 - directional, color affected by colorShadow, 2 - black outline)
	colorText[] = {1,1,1,1}; // Text and frame color
	colorDisabled[] = {1,1,1,0.5}; // Disabled text color
	colorSelect[] = {1,1,1,1}; // Text selection color
	colorSelect2[] = {1,1,1,1}; // Text selection color (oscillates between this and colorSelect)
	colorShadow[] = {0,0,0,0.5}; // Text shadow color (used only when shadow is 1)

	pictureColor[] = {1,1,1,1}; // Picture color
	pictureColorSelect[] = {1,1,1,1}; // Selected picture color
	pictureColorDisabled[] = {1,1,1,0.5}; // Disabled picture color

	tooltip = ""; // Tooltip text
	tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
	tooltipColorText[] = {1,1,1,1}; // Tooltip text color
	tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color

	period = 1; // Oscillation time between colorSelect/colorSelectBackground2 and colorSelect2/colorSelectBackground when selected

	rowHeight = 1.5 * GUI_GRID_CENTER_H; // Row height
	itemSpacing = 0; // Height of empty space between items
	maxHistoryDelay = 1; // Time since last keyboard type search to reset it
	canDrag = 1; // 1 (true) to allow item dragging

	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected

	// Scrollbar configuration (applied only when LB_TEXTURES style is used)
	class ListScrollBar //In older games this class is "ScrollBar"
	{
		width = 0; // width of ListScrollBar
		height = 0; // height of ListScrollBar
		scrollSpeed = 0.01; // scroll speed of ListScrollBar

		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)

		color[] = {1,1,1,1}; // Scrollbar color
	};
};
class CODI_CAM_SmartphoneTeams
{
	idd = -1;
	movingEnable = 0;
	onLoad = "_this execVM '\CODI_CAM\initSmartphoneTeams.sqf';";
	class controlsBackground {
	};
	class objects {
	};
	class controls {
		class SmartphonePicture: CODI_CAM_Picture
		{
			idc = -1;
			text = "\CODI_CAM\smartphone.paa";
			x = safezoneX+(safezoneW-safezoneH)/2;
			y = safezoneY;
			w = safezoneH;
			h = safezoneH;
		};
		class SmartphoneUserList: CODI_CAM_List
		{
			idc = 4244;
			text = "";
			x = safezoneX+(safezoneW-safezoneH)/2+safezoneH*0.248;
			y = safezoneY+safezoneH*0.085;
			w = safezoneH*0.502;
			h = safezoneH*0.845;
			onLBSelChanged = "_this call CODI_CAM_fnc_openUnits";
		};
	};
};
class CODI_CAM_SmartphoneUnits
{
	idd = -1;
	movingEnable = 0;
	onLoad = "_this execVM '\CODI_CAM\initSmartphoneUnits.sqf';";
	class controlsBackground {
	};
	class objects {
	};
	class controls {
		class SmartphonePicture: CODI_CAM_Picture
		{
			idc = -1;
			text = "\CODI_CAM\smartphone.paa";
			x = safezoneX+(safezoneW-safezoneH)/2;
			y = safezoneY;
			w = safezoneH;
			h = safezoneH;
		};
		class SmartphoneUserList: CODI_CAM_List
		{
			idc = 4245;
			text = "";
			x = safezoneX+(safezoneW-safezoneH)/2+safezoneH*0.248;
			y = safezoneY+safezoneH*0.085;
			w = safezoneH*0.502;
			h = safezoneH*0.845;
			onLBSelChanged = "_this call CODI_CAM_fnc_openUnit";
		};
	};
};