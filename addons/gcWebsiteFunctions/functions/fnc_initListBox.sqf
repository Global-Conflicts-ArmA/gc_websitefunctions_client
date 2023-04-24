#include "script_component.hpp"

params [["_ctrl", controlNull]];

uiNamespace setVariable [QGVAR(sendBoxListboxCtrl),_ctrl];

private _fnc_addEntry = {
	params ["_text", "_data"];
	private _index = _ctrl lbAdd _text;
	_ctrl lbSetData [_index, if !(_data isEqualType "") then {
		str _data
	} else {
		_data
	}];
	_index
};

["Good | The mission is well made and interesting.", "positive"] call _fnc_addEntry;
["It's alright | Just a regular enjoyable mission.", "neutral"] call _fnc_addEntry;
["Bad | The mission has concept issues.", "negative"] call _fnc_addEntry;

// set CURSEL ===================================================================
if (lbCurSel _ctrl < 0 || lbCurSel _ctrl >= lbSize _ctrl) then {
	_ctrl lbSetCurSel 1;
} else {
	if (call compile (_ctrl lbData (lbCurSel _ctrl)) < 0) then {
		_ctrl lbSetCurSel 1;
	};
};

