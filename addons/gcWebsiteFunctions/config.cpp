#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		author = "W-Cephei";
		name = QUOTE(ADDON);
	
		requiredVersion = 1.0;
		requiredAddons[] = { QMAINPATCH ,"A3_Ui_F"};
		units[] = {};
		weapons[] = {};
	};
};

#include "cfgEventHandlers.hpp"

#include "gui\defines.hpp"
#include "gui\sendReviewBoxBase.hpp"
#include "gui\sendRatingBoxBase.hpp"
#include "gui\sendBugReportBoxBase.hpp"

#include "gui\interruptMenu.hpp"
#include "gui\rscTitles.hpp"



 