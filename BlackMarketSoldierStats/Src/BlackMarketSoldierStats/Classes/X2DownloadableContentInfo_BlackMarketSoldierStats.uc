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

	Version = "v" $ class'BlackMarketSoldierStats_Settings'.const.VERSION_MAJOR;
	Version $= "." $ class'BlackMarketSoldierStats_Settings'.const.VERSION_MINOR;
	Version $= "." $ class'BlackMarketSoldierStats_Settings'.const.VERSION_PATCH;

    `log("               _____       __    ___              _____ __        __       ");
    `log(" Black Market / ___/____  / /___/ (_)__  _____   / ___/  /_____ _/ /______ ");
    `log("              \\__ \\/ __ \\/ / __  / / _ \\/ ___/   \\__ \\/ __/ __  / __/ ___/ ");
    `log("             ___/ / /_/ / / /_/ / /  __/ /      ___/ / /_/ /_/ / /_(__  )  ");
    `log("   " $ Version $ "   /____/\\____/_/\\__,_/_/\\___/_/      /____/\\__/\\__,_/\\__/____/   ");
}
