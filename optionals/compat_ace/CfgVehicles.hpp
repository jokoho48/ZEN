class CfgVehicles {
    class ModuleEmpty_F;
    class ModuleMine_F: ModuleEmpty_F {
        function = QEFUNC(modules,bi_moduleMine);
    };

    // Hide ACE Zeus modules for which replacements exist
    class ACEGVAR(zeus,moduleBase);

    #define HIDE_MODULE(moduleName) \
        class ACEGVAR(zeus,moduleName): ACEGVAR(zeus,moduleBase) { \
            scopeCurator = QUOTE(2 - parseNumber GETMVAR(QGVAR(hideModules),true)); \
        }

    HIDE_MODULE(moduleEditableObjects);
    HIDE_MODULE(moduleGlobalSetSkill);
    HIDE_MODULE(moduleGroupSide);
    HIDE_MODULE(moduleHeal);
    HIDE_MODULE(modulePatrolArea);
    HIDE_MODULE(moduleSimulation);
    HIDE_MODULE(moduleSuicideBomber);
    HIDE_MODULE(moduleTeleportPlayers);
    HIDE_MODULE(moduleToggleFlashlight);
    HIDE_MODULE(AddFullArsenal);
    HIDE_MODULE(RemoveFullArsenal);
    HIDE_MODULE(AddFullAceArsenal);
    HIDE_MODULE(RemoveFullAceArsenal);
};
