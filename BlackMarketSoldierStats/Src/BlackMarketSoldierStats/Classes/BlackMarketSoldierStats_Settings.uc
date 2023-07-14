class BlackMarketSoldierStats_Settings extends UIScreenListener config(BlackMarketSoldierStats_Settings);

// Mod version
const VERSION_MAJOR = 1;
const VERSION_MINOR = 0;
const VERSION_PATCH = 0;

// Config version
var config int VERSION_CFG;

// Localization Strings for Mod Config Menu Items
var public localized string	SettingsPage_Label, PageTitle_Label;
var public localized string	GroupGeneralSettings_Label, UISettings_Label;

// Mod Config Menu boilerplate
`include(BlackMarketSoldierStats/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`MCM_API_AutoCheckboxVars(HIGHLIGHT_ABOVE_BELOW_AVERAGE);
`MCM_API_AutoSliderVars(PANEL_X);
`MCM_API_AutoSliderVars(PANEL_Y);

`include(BlackMarketSoldierStats/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
`MCM_API_AutoCheckboxFns(HIGHLIGHT_ABOVE_BELOW_AVERAGE);
`MCM_API_AutoSliderFns(PANEL_X);
`MCM_API_AutoSliderFns(PANEL_Y);

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

    LoadSavedSettings();

    Page = ConfigAPI.NewSettingsPage(SettingsPage_Label);
    Page.SetPageTitle(PageTitle_Label);
    Page.SetSaveHandler(SaveButtonClicked);
    Page.EnableResetButton(ResetButtonClicked);

    GeneralGroup = Page.AddGroup('BMSS_GeneralSettings', GroupGeneralSettings_Label);
	`MCM_API_AutoAddCheckbox(GeneralGroup, HIGHLIGHT_ABOVE_BELOW_AVERAGE);

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
}

defaultproperties
{
    ScreenClass = none;
}
