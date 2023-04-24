class RscText;
class RscTitle;
class RscEdit;
class RscButtonMenu;
class RscCombo;

class gc_gcWebsiteFunctions_submit_rating_sendBoxTitleBase: RscTitle {
    idc = -1;
    style = 0;
    text = "SUBMIT A MISSION RATING";
    colorBackground[] = {
        "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
    };

    x = QUOTE(gc_GCWEBSITEFUNCTIONS_TITLE_X);
    y = QUOTE(gc_GCWEBSITEFUNCTIONS_SUBMIT_RATING_TITLE_Y);
    w = QUOTE(gc_GCWEBSITEFUNCTIONS_TOTAL_W);
    h = QUOTE(gc_GCWEBSITEFUNCTIONS_ELEMENT_H);
}; 

class gc_gcWebsiteFunctions_submit_rating_sendBoxListboxBase: RscCombo {
    idc = -1;

    font = "RobotoCondensed";
	sizeEx = 0.035;
    rowHeight = 10;

    onLoad = QUOTE(_this call FUNC(initListbox));
    onUnLoad = QUOTE(uiNamespace setVariable [ARR_2(QQGVAR(sendBoxListboxCtrl), nil)]);
    onLBSelChanged = QUOTE(_this call FUNC(onRecipientChanged));

    x = QUOTE(gc_GCWEBSITEFUNCTIONS_TITLE_X);
    y = QUOTE(gc_GCWEBSITEFUNCTIONS_SUBMIT_RATING_COMBO_Y);
    w = QUOTE(gc_GCWEBSITEFUNCTIONS_TOTAL_W);
    h = QUOTE(gc_GCWEBSITEFUNCTIONS_ELEMENT_H);
};

class gc_gcWebsiteFunctions_submit_rating_sendBoxButtonBase: RscButtonMenu {
    idc = gc_GCWEBSITEFUNCTIONS_IDC_SUBMIT_RATING_SENDBUTTON;
 
    text = "SEND RATING";
    action = QUOTE(call FUNC(sendRating));
    x = QUOTE(gc_GCWEBSITEFUNCTIONS_TITLE_X);
    y = QUOTE(gc_GCWEBSITEFUNCTIONS_SUBMIT_RATING_SENDBUTTON_Y);
    w = QUOTE(gc_GCWEBSITEFUNCTIONS_TOTAL_W);
    h = QUOTE(gc_GCWEBSITEFUNCTIONS_ELEMENT_H);
};


 