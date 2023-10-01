#include "script_component.hpp"

private _reviewResponseId = ["gc_reviewResponse", {
	params ["_response"];
	SETPVAR(player,sendingInProgress,false);
	if (count _response > 1) then {
		private _success = _response select 1;
		systemChat format["GC Mission Review | %1", _response select 0];
		if (_success) then {
			playSoundUI ["a3\sounds_f\sfx\ui\Tactical_Ping\Tactical_Ping.wss"];
			SETPVAR(player,hasSentReview,true);
		} else {
			playSoundUI ["a3\sounds_f\debugsound.wss"];
		}
	} else {
		systemChat format["GC Mission Review | Critical error."];
		playSoundUI ["a3\sounds_f\debugsound.wss"];
	};
}] call CBA_fnc_addEventHandler;

private _bugReportResponseId = ["gc_bugReportResponse", {
	params ["_response"];
	SETPVAR(player,sendingInProgress,false);
	if (count _response > 1) then {
		private _success = _response select 1;
		systemChat format["GC Mission Bug Report | %1", _response select 0];
		if (_success) then {
			playSoundUI ["a3\sounds_f\sfx\ui\Tactical_Ping\Tactical_Ping.wss"];
		} else {
			playSoundUI ["a3\sounds_f\debugsound.wss"];
		}
	} else {
		systemChat format["GC Mission Bug Report | Critical error."];
		playSoundUI ["a3\sounds_f\debugsound.wss"];
	};
}] call CBA_fnc_addEventHandler;

 
private _getBugReportsResponseId = ["gc_getBugReportsResponse", {
	params ["_response", "_message"];
	SETPVAR(player,sendingInProgress,false);
	if (count _response > 1) then {
		private _success = _response select 1;
	
		if (_success) then {
			//show bug reports
			if(count (_response select 0) > 0 ) then{
				[ 
					[_response select 0], 
					"READ THE CURRENT BUG REPORTS BEFORE SUBMITTING!",
					{ 
						if (_confirmed) then { 
							 [] spawn {
	 
								[{
									
									[
										"Only use this for actual bug reports.",
										"Are you sure?",
										[
											"Yes",
											{
												BIS_Message_Confirmed = true;
												SETPVAR(player,sendingInProgress,true);
												private _message = GETVAR(player,missionBugReportText,"");
												systemChat "GC Mission Bug Report | Please wait, submitting bug report.";
												["gc_onSubmitBugReport", [_message, player]] call CBA_fnc_serverEvent;
											}
										],
										[
											"No",
											{
												BIS_Message_Confirmed = false
											}
										],
										"\x\gc_websiteFunctionsClient\addons\gcWebsiteFunctions\data\gc_logo.paa",
										[] call BIS_fnc_displayMission
									] call BIS_fnc_3DENShowMessage;
								}, [] ] call CBA_fnc_execNextFrame;
							}
						}; 
					}, 
					"CONFIRM",
					"CANCEL"
				] call CAU_UserInputMenus_fnc_guiMessage;
			}else{
				[] spawn {
		 
					[{
						 
						[
							"Only use this for actual bug reports.",
							"Are you sure?",
							[
								"Yes",
								{
									BIS_Message_Confirmed = true;
									SETPVAR(player,sendingInProgress,true);
									private _message = GETVAR(player,missionBugReportText,"");
									["gc_onSubmitBugReport", [_message, player]] call CBA_fnc_serverEvent;
								}
							],
							[
								"No",
								{
									BIS_Message_Confirmed = false
								}
							],
							"\x\gc_websiteFunctionsClient\addons\gcWebsiteFunctions\data\gc_logo.paa",
							[] call BIS_fnc_displayMission
						] call BIS_fnc_3DENShowMessage;
					}, [] ] call CBA_fnc_execNextFrame;
				}
			};
 

			playSoundUI ["a3\sounds_f\sfx\ui\Tactical_Ping\Tactical_Ping.wss"];
		} else {
			playSoundUI ["a3\sounds_f\debugsound.wss"];
		}
	} else {
		systemChat format["GC Mission Bug Report | Critical error."];
		playSoundUI ["a3\sounds_f\debugsound.wss"];
	};
}] call CBA_fnc_addEventHandler;


private _ratingResponseId = ["gc_ratingResponse", {
	params ["_response"];
	
	SETPVAR(player,sendingInProgress,false);
	if (count _response > 1) then {
		private _success = _response select 1;
		systemChat format["GC Mission Rating | %1", _response select 0];
		if (_success) then {
			playSoundUI ["a3\sounds_f\sfx\ui\Tactical_Ping\Tactical_Ping.wss"];
		} else {
			playSoundUI ["a3\sounds_f\debugsound.wss"];
		}
	} else {
		systemChat format["GC Mission Rating | Critical error."];
		playSoundUI ["a3\sounds_f\debugsound.wss"];
	};
}] call CBA_fnc_addEventHandler;



