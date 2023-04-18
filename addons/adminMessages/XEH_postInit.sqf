#include "script_component.hpp"

GVAR(channel) = radioChannelCreate [[0.9,0.1,0.1,1],"Admin","Admin",[],true];
publicVariable QGVAR(channel);


private _reviewResponseId = ["reviewResponse", {
	diag_log "reviewResponse";
	diag_log str _this;
	systemChat str _this;
	}] call CBA_fnc_addEventHandler;

private _bugReportResponseId = ["bugReportResponse", {systemChat str _this}] call CBA_fnc_addEventHandler;

private _ratingResponseId = ["ratingResponse", {systemChat str _this}] call CBA_fnc_addEventHandler;