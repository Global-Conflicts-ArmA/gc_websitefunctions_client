#include "script_component.hpp"

params [["_ctrl",controlNull]];

private _text = if ([] call FUNC(isAdminOrZeus)) then {
    localize "STR_gc_websiteFunctionsClient_SENDBOXTITLEADMIN"
} else {
    localize "STR_gc_websiteFunctionsClient_SENDBOXTITLEPLAYER"
};

_ctrl ctrlSetText _text
