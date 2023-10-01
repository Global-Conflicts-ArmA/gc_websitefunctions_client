#include "script_component.hpp"

private _hasSentReview = GETVAR(player,hasSentReview,false);
private _sendingInProgress = GETVAR(player,sendingInProgress,false);

if (_hasSentReview) exitWith {
	playSoundUI ["a3\sounds_f\debugsound.wss"];
	[] spawn {
		[{
			["GC Mission Review ", "You already submited a review.", {true}] call ace_common_fnc_errorMessage;
		}, [] ] call CBA_fnc_execNextFrame;
	};
};

if (_sendingInProgress) exitWith {
	playSoundUI ["a3\sounds_f\debugsound.wss"];
	[] spawn {
		[{
			["GC Mission Review ", "Please wait, your previous request is being processed.", {true}] call ace_common_fnc_errorMessage;
		}, [] ] call CBA_fnc_execNextFrame;
	};
};

private _editBox = uiNamespace getVariable [QGVAR(reviewSendBoxCtrl), controlNull];

if (isNull _editBox) exitWith {};

SETPVAR(player,missionReviewText,""); // resets the text
private _message = ctrlText _editBox;
if (_message == "") exitWith {};
SETPVAR(player,missionReviewText,_message); // sets the text to the player vars so I can get it inside the callback of the BIS_fnc_3DENShowMessage

private _isSpectating = ["IsSpectating"] call BIS_fnc_EGSpectator;
private _missionDisplay = nil;
if (!_isSpectating) then {
	findDisplay 49 closeDisplay 1;
	_missionDisplay = [] call BIS_fnc_displayMission;
};

[_message] spawn {
	params ["_message"];
	[{
		params ["_message"];

		[
			"You won't be able to send a new review during this playthrough of this mission.",
			"Are you sure?",
			[
				"Yes",
				{
		 
					["gc_onSubmitReview", [_message, player]] call CBA_fnc_serverEvent;
				}
			],
			[
				"No",
				{
					BIS_Message_Confirmed = false
				}
			],
			"\x\gc_websiteFunctionsClient\addons\gcWebsiteFunctions\data\gc_logo.paa",
			_missionDisplay
		] call BIS_fnc_3DENShowMessage;
	}, [_message] ] call CBA_fnc_execNextFrame;
};

playSoundUI ["a3\sounds_f\sfx\beep_target.wss"];