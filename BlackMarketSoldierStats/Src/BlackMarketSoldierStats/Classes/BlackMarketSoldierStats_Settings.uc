class BlackMarketSoldierStats_Settings extends UIScreenListener config(BlackMarketSoldierStats_Settings);

// Mod version
const VERSION_MAJOR = 0;
const VERSION_MINOR = 1;
const VERSION_PATCH = 0;

// Config version
var config int VERSION_CFG;

// Localization Strings for Mod Config Menu Items
var public localized string	SettingsPage_Label, PageTitle_Label;
var public localized string	GroupGeneralSettings_Label;

// Mod Config Menu boilerplate
`include(BlackMarketSoldierStats/Src/ModConfigMenuAPI/MCM_API_Includes.uci)

// `MCM_API_AutoCheckboxVars(XXXX);

`include(BlackMarketSoldierStats/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

// `MCM_API_AutoCheckboxFns(XXXX);

event OnInit(UIScreen Screen)
{
    local string Version;

	if (MCM_API(Screen) != none)
	{
        `MCM_API_Register(Screen, ClientModCallback);
    }
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    // Build the settings UI
    local MCM_API_SettingsPage Page;
    local MCM_API_SettingsGroup Group;

    LoadSavedSettings();

    Page = ConfigAPI.NewSettingsPage(SettingsPage_Label);
    Page.SetPageTitle(PageTitle_Label);
    Page.SetSaveHandler(SaveButtonClicked);

    Group = Page.AddGroup('BMSS_GeneralSettings', GroupGeneralSettings_Label);

    Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
    // XXXX = `GETMCMVAR(XXXX);
}

function SaveButtonClicked(MCM_API_SettingsPage Page)
{
    VERSION_CFG = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	// `MCM_API_AutoReset(XXXX);
}

defaultproperties
{
    ScreenClass = none;
}
