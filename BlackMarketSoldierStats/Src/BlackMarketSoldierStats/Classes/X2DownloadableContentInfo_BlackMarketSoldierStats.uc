class X2DownloadableContentInfo_BlackMarketSoldierStats extends X2DownloadableContentInfo;

static event OnLoadedSavedGame()
{

}

static event InstallNewCampaign(XComGameState StartState)
{

}

static event OnPostTemplatesCreated()
{
	local string Version;
	local bool bLogBanner;

	Version = "v" $ class'BlackMarketSoldierStats_Settings'.const.VERSION_MAJOR;
	Version $= "." $ class'BlackMarketSoldierStats_Settings'.const.VERSION_MINOR;
	Version $= "." $ class'BlackMarketSoldierStats_Settings'.const.VERSION_PATCH;

	bLogBanner = class'BlackMarketSoldierStats_Defaults'.default.LOG_BANNER;

	`log("               _____       __    ___              _____ __        __       ", bLogBanner, 'BlackMarketSoldierStats');
	`log(" Black Market / ___/____  / /___/ (_)__  _____   / ___/  /_____ _/ /______ ", bLogBanner, 'BlackMarketSoldierStats');
	`log("              \\__ \\/ __ \\/ / __  / / _ \\/ ___/   \\__ \\/ __/ __  / __/ ___/ ", bLogBanner, 'BlackMarketSoldierStats');
	`log("             ___/ / /_/ / / /_/ / /  __/ /      ___/ / /_/ /_/ / /_(__  )  ", bLogBanner, 'BlackMarketSoldierStats');
	`log("   " $ Version $ "   /____/\\____/_/\\__,_/_/\\___/_/      /____/\\__/\\__,_/\\__/____/   ", bLogBanner, 'BlackMarketSoldierStats');
}
