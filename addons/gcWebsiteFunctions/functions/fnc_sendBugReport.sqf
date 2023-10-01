#include "script_component.hpp"

private _sendingInProgress = GETVAR(player,sendingInProgress,false);

if (_sendingInProgress) exitWith {
	playSoundUI ["a3\sounds_f\debugsound.wss"];
	[] spawn {
		[{
			["GC Mission Bug Report", "Please wait, your previous request is being processed.", {true}] call ace_common_fnc_errorMessage;
		}, [] ] call CBA_fnc_execNextFrame;
	};
};

private _editBox = uiNamespace getVariable [QGVAR(bugReportSendBoxCtrl), controlNull];

if (isNull _editBox) exitWith {};

SETPVAR(player,missionBugReportText,""); // resets the text
private _message = ctrlText _editBox;
if (_message == "") exitWith {};
SETPVAR(player,missionBugReportText,_message); // sets the text to the player vars so I can get it inside the callback of the BIS_fnc_3DENShowMessage

																																																																																																																																										private _isSpectating = ["IsSpectating"] call BIS_fnc_EGSpectator;
if (!_isSpectating) then {
	findDisplay 49 closeDisplay 1;
};

 
["gc_onGetBugReports", [player]] call CBA_fnc_serverEvent;
 

systemChat "GC Mission Bug Report | Please wait, fetching current bug reports.";

playSoundUI ["a3\sounds_f\sfx\beep_target.wss"];








