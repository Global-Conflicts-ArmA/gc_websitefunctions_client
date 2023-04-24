#include "script_component.hpp"

private _sendingInProgress = GETVAR(player,sendingInProgress,false);

if (_sendingInProgress) exitWith {
	playSoundUI ["a3\sounds_f\debugsound.wss"];
	[] spawn {
		[{
			["GC Mission Rating", "Please wait, your previous request is being processed.", {true}] call ace_common_fnc_errorMessage;
		}, [] ] call CBA_fnc_execNextFrame;
	};
};

private _listbox = uiNamespace getVariable [QGVAR(sendBoxListboxCtrl), controlNull];

private _lbCurSel = lbCurSel _listbox;
private _rating = _listbox lbData _lbCurSel;
private _lbText = _listbox lbText _lbCurSel;
private _receiveConditionParams = [];

SETPVAR(player,missionRating,_rating); // sets the text to the player vars so I can get it inside the callback of the BIS_fnc_3DENShowMessage
findDisplay 49 closeDisplay 1;

if (_rating == "negative") then {
	[_rating] spawn {
		params ["_rating"];
		[{
			params ["_rating"];

			[
				"Please consider writing a constructive review for the mission maker.",
				"You are sending a negative rating",
				[
					"Confirm",
					{
						BIS_Message_Confirmed = true;
						SETPVAR(player,sendingInProgress,true);
						private _rating = GETVAR(player,missionRating,"");
						["gc_onSubmitRating", [_rating, player]] call CBA_fnc_serverEvent;
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
		}, [_rating] ] call CBA_fnc_execNextFrame;
	};
} else{

	SETPVAR(player,sendingInProgress,true);
	["gc_onSubmitRating", [_rating, player]] call CBA_fnc_serverEvent;
};



