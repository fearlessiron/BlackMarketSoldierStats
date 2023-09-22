class BlackMarketSoldierStats_Settings extends UIScreenListener config(BlackMarketSoldierStats_Settings);

// Mod version
const VERSION_MAJOR = 1;
const VERSION_MINOR = 3;
const VERSION_PATCH = 1;

// Config version
var config int VERSION_CFG;

// Localization Strings for Mod Config Menu Items
var public localized string	SettingsPage_Label, PageTitle_Label;
var public localized string	GroupGeneralSettings_Label, UISettings_Label;

// Mod Config Menu boilerplate
`include(BlackMarketSoldierStats/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`MCM_API_AutoCheckboxVars(HIGHLIGHT_ABOVE_BELOW_AVERAGE);
`MCM_API_AutoCheckboxVars(PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY);
`MCM_API_AutoSliderVars(PANEL_X);
`MCM_API_AutoSliderVars(PANEL_Y);
`MCM_API_AutoCheckboxVars(REVEAL_COST_ENABLED);
`MCM_API_AutoDropdownVars(REVEAL_COST_RESOURCE);
`MCM_API_AutoSliderVars(REVEAL_COST_QUANTITY);

`include(BlackMarketSoldierStats/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_API_AutoCheckboxFns(HIGHLIGHT_ABOVE_BELOW_AVERAGE);
`MCM_API_AutoCheckboxFns(PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY, 3);
`MCM_API_AutoSliderFns(PANEL_X);
`MCM_API_AutoSliderFns(PANEL_Y);
`MCM_API_AutoCheckboxFns(REVEAL_COST_ENABLED, 2);
`MCM_API_AutoDropdownFns(REVEAL_COST_RESOURCE, 2);
`MCM_API_AutoSliderFns(REVEAL_COST_QUANTITY, , 2);

event OnInit(UIScreen Screen)
{
	if (MCM_API(Screen) != none)
	{
        `MCM_API_Register(Screen, ClientModCallback);
    }
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    // Build the settings UI
    local MCM_API_SettingsPage Page;
    local MCM_API_SettingsGroup GeneralGroup, UIGroup;
    local array<string> RevealCostResourceOptions;
    local string Version;

    Version = "v" $ VERSION_MAJOR $ "." $ VERSION_MINOR $ "." $ VERSION_PATCH;

    LoadSavedSettings();

    Page = ConfigAPI.NewSettingsPage(SettingsPage_Label);
    Page.SetPageTitle(PageTitle_Label @ Version);
    Page.SetSaveHandler(SaveButtonClicked);
    Page.EnableResetButton(ResetButtonClicked);

    // MCM does not provide an easy way to allow for the translation of the
    // options while storing the template name in the config variable
    RevealCostResourceOptions.AddItem("Intel");
    RevealCostResourceOptions.AddItem("Supplies");

    GeneralGroup = Page.AddGroup('BMSS_GeneralSettings', GroupGeneralSettings_Label);
    `MCM_API_AutoAddCheckbox(GeneralGroup, HIGHLIGHT_ABOVE_BELOW_AVERAGE);
    `MCM_API_AutoAddCheckbox(GeneralGroup, PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY);
    `MCM_API_AutoAddCheckbox(GeneralGroup, REVEAL_COST_ENABLED);
    `MCM_API_AutoAddDropdown(GeneralGroup, REVEAL_COST_RESOURCE, RevealCostResourceOptions);
    `MCM_API_AutoAddSlider(GeneralGroup, REVEAL_COST_QUANTITY, 1, 500, 1);

    UIGroup = Page.AddGroup('BMSS_UISettings', UISettings_Label);
   	`MCM_API_AutoAddSlider(UIGroup, PANEL_X, -2000, 2000, 5);
   	`MCM_API_AutoAddSlider(UIGroup, PANEL_Y, 0, 4000, 5);

    Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
    PANEL_X = `GETMCMVAR(PANEL_X);
    PANEL_Y = `GETMCMVAR(PANEL_Y);
    HIGHLIGHT_ABOVE_BELOW_AVERAGE = `GETMCMVAR(HIGHLIGHT_ABOVE_BELOW_AVERAGE);
    PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY = `GETMCMVAR(PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY);
    REVEAL_COST_ENABLED = `GETMCMVAR(REVEAL_COST_ENABLED);
    REVEAL_COST_RESOURCE = `GETMCMVAR(REVEAL_COST_RESOURCE);
    REVEAL_COST_QUANTITY = `GETMCMVAR(REVEAL_COST_QUANTITY);
}

function SaveButtonClicked(MCM_API_SettingsPage Page)
{
    VERSION_CFG = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
    `MCM_API_AutoReset(PANEL_X);
    `MCM_API_AutoReset(PANEL_Y);
    `MCM_API_AutoReset(HIGHLIGHT_ABOVE_BELOW_AVERAGE);
    `MCM_API_AutoReset(PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY);
    `MCM_API_AutoReset(REVEAL_COST_ENABLED);
    `MCM_API_AutoReset(REVEAL_COST_RESOURCE);
    `MCM_API_AutoReset(REVEAL_COST_QUANTITY);
}

defaultproperties
{
    ScreenClass = none;
}
