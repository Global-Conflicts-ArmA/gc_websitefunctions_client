#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {};
        authors[] = {"DerZade [A]","Salbei"};
        VERSION_CONFIG;
    };
};

#include <CfgSettings.hpp>
