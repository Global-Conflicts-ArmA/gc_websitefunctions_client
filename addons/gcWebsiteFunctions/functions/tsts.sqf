{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {
		'BIS_fnc_EGSpectator'
	} else {
		_fnc_scriptName
	};
	private _fnc_scriptName = 'BIS_fnc_EGSpectator';
	scriptName _fnc_scriptName;

	if (count (supportInfo "n:is3DEN") > 0 && {
		is3DEN
	}) exitWith {};

	disableSerialization;

	scriptName "BIS_fnc_EGSpectator";

	private _mode = _this param [0, "", [""]];
	private _params = _this param [1, [], [[]]];

	switch (_mode) do
	{
		case "Initialize" :
		{
			_params params
			[
				["_spectator", objNull, [objNull]],
				["_whitelistedSides", [], []],
				["_allowAi", false, [false]],
				["_allowFreeCamera", true, [false]],
				["_allow3PPCamera", true, [false]],
				["_showFocusInfo", true, [false]],
				["_showCameraButtons", true, [false]],
				["_showControlsHelper", true, [false]],
				["_showHeader", true, [false]],
				["_showLists", true, [false]]
			];

			if (!hasInterface) exitWith {};

			waitUntil {
				!isNil {
					player
				} && {
					!isNull player
				}
			};

			private _bIsInitialized = ["IsInitialized"] call {
				_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
			};

			private _isPlayer = _spectator == player;

			if (!_bIsInitialized && _isPlayer) then {
				_bIsInitialized = true;

				missionNamespace setVariable [ "BIS_EGSpectator_draw3D", addMissionEventHandler ["Draw3D", {
					[] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectatorDraw3D", {}])
					};
				}]];

				missionNamespace setVariable [ "BIS_EGSpectator_initialized", _bIsInitialized];

				missionNamespace setVariable [ "BIS_EGSpectator_entityRespawned", addMissionEventHandler ["EntityRespawned", {
					(_this select 0) setVariable [ "BIS_EGSpectator_entityFired", nil];
				}]];

				private _sides = [];

				{
					switch (toUpper _x) do
					{
						case "WEST" : {
							_sides pushBack west;
						};
						case "EAST" : {
							_sides pushBack east;
						};
						case "RESISTANCE" : {
							_sides pushBack resistance;
						};
						default {
							_sides pushBack civilian;
						};
					};
				} forEach (_spectator getVariable ["WhitelistedSides", []]);

				missionNamespace setVariable [ "BIS_EGSpectator_allowAiSwitch", _spectator getVariable ["AllowAi", _allowAi]];
				missionNamespace setVariable [ "BIS_EGSpectator_allowFreeCamera", _spectator getVariable ["AllowFreeCamera", _allowFreeCamera]];
				missionNamespace setVariable [ "BIS_EGSpectator_allow3PPCamera", _spectator getVariable ["Allow3PPCamera", _allow3PPCamera]];
				missionNamespace setVariable [ "BIS_EGSpectator_showFocusInfo", _spectator getVariable ["ShowFocusInfo", _showFocusInfo]];
				missionNamespace setVariable [ "BIS_EGSpectator_showCameraButtons", _spectator getVariable ["ShowCameraButtons", _showCameraButtons]];
				missionNamespace setVariable [ "BIS_EGSpectator_showControlsHelper", _spectator getVariable ["ShowControlsHelper", _showControlsHelper]];
				missionNamespace setVariable [ "BIS_EGSpectator_showHeader", _spectator getVariable ["ShowHeader", _showHeader]];
				missionNamespace setVariable [ "BIS_EGSpectator_showLists", _spectator getVariable ["ShowLists", _showLists]];
				if (count _sides > 0) then {
					missionNamespace setVariable [ "BIS_EGSpectator_whitelistedSides", _sides];
				} else {
					missionNamespace setVariable [ "BIS_EGSpectator_whitelistedSides", _whitelistedSides];
				};

				missionNamespace setVariable [ "BIS_EGSpectator_viewDistance", viewDistance];

				missionNamespace setvariable [ "BIS_EGSpectatorDraw3D_drawLocations", true];

				missionNamespace setVariable [ "BIS_EGSpectator_projectiles", []];
				missionNamespace setVariable [ "BIS_EGSpectator_grenades", []];

				private _initialMode = if (_allowFreeCamera) then {
					"free";
				} else {
					if (_allow3PPCamera) then {
						"follow";
					} else {
						"fps";
					};
				};

				["Initialize", [ "camcurator", _initialMode]] call {
					_this call (missionNamespace getVariable ["BIS_fnc_EGSpectatorCamera", {}])
				};

				["CreateDisplay"] spawn {
					_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
				};

				_spectator allowDamage false;

				missionNamespace setVariable [ "BIS_EGSpectator_thread", [] spawn
					{
						scriptName "BIS_EGSpectator_thread";

						private _delay = 0.25;

						while { true } do {
							missionNamespace setVariable [ "BIS_EGSpectator_unitsIconsToDraw", [] call {
								_this call (missionNamespace getVariable ["BIS_fnc_EGSpectatorGetUnitsToDraw", {}])
							}];

							private _allUnits = allUnits;
							private _allUnitsCount = count _allUnits;

							{
								if (isNil {
									_x getVariable "BIS_EGSpectator_entityFired"
								}) then
								{
									_x setVariable [ "BIS_EGSpectator_entityFired", _x addEventHandler ["Fired",
										{
											private _weapon = _this param [1, "", [""]];
											private _projectile = _this param [6, objNull, [objNull]];

											(_this select 0) setVariable [ "BIS_EGSpectator_unitHighlightTime", time + 0.05];

											if (!isNull _projectile && {
												missionNamespace getVariable [ "BIS_EGSpectator_drawProjectilesPath", false]
											}) then
											{
												private _projectiles = missionNamespace getVariable [ "BIS_EGSpectator_projectiles", []];
												private _grenades = missionNamespace getVariable [ "BIS_EGSpectator_grenades", []];

												if (_weapon == "Throw") then {
													if (count _grenades > 10) then {
														_grenades deleteAt 0
													};
													_grenades pushBack _projectile;
													missionNamespace setVariable [ "BIS_EGSpectator_grenades", _grenades];
												} else {
													if (count _projectiles > 50) then {
														_projectiles deleteAt 0
													};
													_projectiles pushBack [_projectile, [[getPosVisual _projectile, [1, 0, 0, 0]]]];
													missionNamespace setVariable [ "BIS_EGSpectator_projectiles", _projectiles];
												};
											};
										}]];
									};

									sleep (_delay / _allUnitsCount);
								} forEach _allUnits;

								sleep _delay;
							};
						}];
					};

					["VirtualSpectator_F: %1 / %2 / %3 / %4", _bIsInitialized, player == _spectator, player, _spectator] call BIS_fnc_logFormat;

					_bIsInitialized;
				};

				case "Terminate" :
				{
					private "_bSucceeded";
					_bSucceeded = false;

					if (["IsInitialized"] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					}) then
					{
						removeMissionEventHandler ["Draw3D", missionNamespace getVariable [ "BIS_EGSpectator_draw3D", -1]];

						terminate (missionNamespace getVariable [ "BIS_EGSpectator_thread", scriptNull]);

						removeMissionEventHandler ["EntityRespawned", missionNamespace getVariable [ "BIS_EGSpectator_entityRespawned", -1]];

						missionNamespace setVariable [ "BIS_EGSpectator_draw3D", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_customIcons", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_initialized", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_entityRespawned", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_thread", nil];

						missionNamespace setVariable [ "BIS_EGSpectator_allowAiSwitch", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_allowFreeCamera", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_allow3PPCamera", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_showFocusInfo", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_showCameraButtons", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_showControlsHelper", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_showHeader", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_showLists", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_whitelistedSides", nil];

						missionNamespace setVariable [ "BIS_EGSpectator_projectiles", nil];
						missionNamespace setVariable [ "BIS_EGSpectator_grenades", nil];

						["DestroyDisplay"] call {
							_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
						};

						["Terminate"] call {
							_this call (missionNamespace getVariable ["BIS_fnc_EGSpectatorCamera", {}])
						};

						player switchCamera "Internal";

						player allowDamage true;

						setViewDistance (missionNamespace getVariable [ "BIS_EGSpectator_viewDistance", viewDistance]);

						_bSucceeded = true;
					};

					_bSucceeded;
				};

				case "IsInitialized" :
				{
					!isNil {
						missionNamespace getVariable "BIS_EGSpectator_initialized"
					};
				};

				case "IsSpectator" :
				{
					params [["_object", objNull, [objNull]]];

					_object isKindOf "VirtualSpectator_F";
				};

				case "IsSpectating" :
				{
					!isNil {
						missionNamespace getVariable "BIS_EGSpectator_initialized"
					};
				};

				case "GetCamera" :
				{
					["GetCamera"] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectatorCamera", {}])
					};
				};

				case "GetTargetEntities" :
				{
					private _allowAi = missionNamespace getVariable [ "BIS_EGSpectator_allowAiSwitch", false];
					private _whitelist = missionNamespace getVariable [ "BIS_EGSpectator_whitelistedSides", []];
					private _whitelistEmpty = count _whitelist < 1;
					private _entities = [];
					private _validEntities = [];

					if (_allowAi) then {
						_entities = allUnits;
					} else {
						_entities = [] call BIS_fnc_listPlayers;
					};

					{
						if
						(
						simulationEnabled _x && {
							simulationEnabled vehicle _x
						} &&
						{
							!isObjectHidden _x && {
								!isObjectHidden vehicle _x
							}
						} &&
						{
							!(_x isKindOf "VirtualSpectator_F")
						} &&
						{
							(_whitelistEmpty || {
								side group _x in _whitelist
							})
						}
						) then
						{
							_validEntities pushBack _x;
						};
					} forEach _entities;

					_validEntities;
				};

				case "GetTargetGroups" :
				{
					private _allowAi = missionNamespace getVariable [ "BIS_EGSpectator_allowAiSwitch", false];
					private _whitelist = missionNamespace getVariable [ "BIS_EGSpectator_whitelistedSides", []];
					private _whitelistEmpty = count _whitelist < 1;
					private _groups = [];
					private _validGroups = [];

					if (_allowAi) then {
						_groups = allGroups;
					} else {
						private _players = [] call BIS_fnc_listPlayers;
						{
							_groups pushBackUnique (group _x);
						} forEach _players;
					};

					{
						if ((_whitelistEmpty || {
							side _x in _whitelist
						}) && {
							{
								!(_x isKindOf "VirtualSpectator_F")
							} count units _x > 0
						}) then
						{
							_validGroups pushBack _x;
						};
					} forEach _groups;

					_validGroups;
				};

				case "CreateDisplay" :
				{
					private _display = displayNull;

					waitUntil
					{
						_display = [] call BIS_fnc_displayMission;
						!isNull _display
					};

					_display createDisplay "RscDisplayEGSpectator";
				};

				case "DestroyDisplay" :
				{
					private _display = ["GetDisplay"] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					};

					if (!isNull _display) then {
						_display closeDisplay 2;
					};

					isNull (["GetDisplay"] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					});
				};

				case "GetDisplay" :
				{
					findDisplay 60492;
				};

				case "AddCustomIcon" :
				{
					private ["_id", "_target", "_iconParams", "_background", "_conditionShow"];
					_id = _params param [0, "", [""]];
					_target = _params param [1, objNull, [objNull, []]];
					_iconParams = _params param [2, ["", [1, 1, 1, 1], [0, 0, 0], 4.0, -0.7, 0, "", 2, 0.035, "PuristaLight", "center"], [[]]];
					_background = _params param [3, [false, [1, 1, 1, 0.5]], [[]]];
					_conditionShow = _params param [4, {
						true
					}, [{}]];

					if (_id == "") exitWith {
						"AddCustomIcon: Unique ID can not be empty" call BIS_fnc_error;
					};

					if (["HasCustomIcon", [_id]] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					}) exitWith
					{
						["AddCustomIcon: Unique ID (%1) already in use by another custom icon, no action taken", _id] call BIS_fnc_error;
					};

					private _list = ["GetCustomIcons"] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					};

					_list pushBack [_id, _target, _iconParams, _background, _conditionShow];

					["SetCustomIcons", _list] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					};
				};

				case "RemoveCustomIcon" :
				{
					private _id = _params param [0, "", [""]];
					private _index = ["GetCustomIconIndex", [_id]] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					};

					if (_index < 0) exitWith {
						["RemoveCustomIcon: Unique ID (%1) not found, there is no such custom icon registered", _id] call BIS_fnc_error;
					};

					private _list = ["GetCustomIcons"] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					};

					_list deleteAt _index;

					["SetCustomIcons", _list] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					};
				};

				case "GetCustomIcons" :
				{
					missionNamespace getVariable [ "BIS_EGSpectator_customIcons", []];
				};

				case "SetCustomIcons" :
				{
					missionNamespace setVariable [ "BIS_EGSpectator_customIcons", _params];
				};

				case "HasCustomIcon" :
				{
					private _id = _params param [0, "", [""]];

					["GetCustomIconIndex", [_id]] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					} >= 0;
				};

				case "GetCustomIconIndex" :
				{
					private _id = _params param [0, "", [""]];
					private _list = ["GetCustomIcons"] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					};
					private _index = -1;

					{
						private _idOther = _x param [0, "", [""]];

						if (_idOther == _id) exitWith {
							_index = _forEachIndex;
						};
					} forEach _list;

					_index;
				};

				case "GetLocations" :
				{
					missionNamespace getVariable [ "BIS_EGSpectator_locations", []];
				};

				case "GetLocationById" :
				{
					private _id = _params select 0;
					private _locations = missionNamespace getVariable [ "BIS_EGSpectator_locations", []];
					private _location = [];

					{
						if (_x select 0 == _id) exitWith {
							_location = _x;
						};
					} forEach _locations;

					_location;
				};

				case "IsLocationIdUsed" :
				{
					private _locations = missionNamespace getVariable [ "BIS_EGSpectator_locations", []];
					private _index = -1;

					{
						if (_x select 0 == _id) exitWith {
							_index = _forEachIndex;
						};
					} forEach _locations;

					if (_index != -1) then {
						true;
					} else {
						false;
					};
				};

				case "AddLocation" :
				{
					private ["_id", "_description", "_texture", "_cameraTransform", "_dirOverride"];
					_id = _params param [0, "", [""]];
					_name = _params param [1, "", [""]];
					_description = _params param [2, "", [""]];
					_texture = _params param [3, "", [""]];
					_cameraTransform = _params param [4, [[], [], []], [[]]];
					_dirOverride = _params param [5, [0, false], [[]]];

					if (_id != "" && !(["IsLocationIdUsed", [_id]] call {
						_this call (missionNamespace getVariable ["BIS_fnc_EGSpectator", {}])
					})) then
					{
						private _locations = missionNamespace getVariable [ "BIS_EGSpectator_locations", []];

						if (_texture == "") then {
							_texture = "#(rgb, 8, 8, 3)color(0, 0, 0, 0)";
						};

						_locations pushBack [_id, _name, _description, _texture, _cameraTransform, _dirOverride];
						missionNamespace setVariable [ "BIS_EGSpectator_locations", _locations];
					};
				};

				case "RemoveLocation" :
				{
					private _id = _params param [0, "", [""]];
					private _locations = missionNamespace getVariable [ "BIS_EGSpectator_locations", []];
					private _index = -1;

					{
						if (_x select 0 == _id) exitWith {
							_index = _forEachIndex;
						};
					} forEach _locations;

					if (_index != -1) then {
						_locations deleteAt _index;
						missionNamespace setVariable [ "BIS_EGSpectator_locations", _locations];
					};
				};

				case "CountSpectators" :
				{
					private _count = 0;

					{
						if (_x isKindOf "VirtualSpectator_F") then {
							_count = _count + 1;
						};
					} forEach allPlayers;

					_count;
				};

				default
				{
					["Unknown mode: %1", _mode] call BIS_fnc_error;
				};
			};
		}