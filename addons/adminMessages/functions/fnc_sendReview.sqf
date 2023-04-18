private _editBox = uiNamespace getVariable ["gc_websiteFunctionsClient_adminmessages_sendboxctrl", controlNull];

systemChat "SEND REVIEW CALLED 1 ";
if (isNull _editBox) exitWith {};

systemChat "SEND REVIEW CALLED 2";

player setVariable ["gc_missionReviewText", "", true];
private _message = ctrlText _editBox;
if (_message == "") exitWith {};
player setVariable ["gc_missionReviewText", _message, true];
 

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
					BIS_Message_Confirmed = true;
					private _message = player getVariable ["gc_missionReviewText",  ""];
					systemChat format["sending msg %1", _message];
					["onSubmitReview", [_message, player]] call CBA_fnc_globalEvent;
				}
			],
			[
				"No",
				{
					BIS_Message_Confirmed = false
				}
			],
			"\A3\ui_f\data\map\markers\handdrawn\warning_CA.paa",
			[] call BIS_fnc_displayMission
		] call BIS_fnc_3DENShowMessage;

	}, [_message] ] call CBA_fnc_execNextFrame;

};

playSound "3DEN_notificationDefault";