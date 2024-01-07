class BlackMarketSoldierStats_MCM_ScreenListener extends UIScreenListener;

event OnInit (UIScreen Screen)
{
	local BlackMarketSoldierStats_Settings MCMScreen;

	if (ScreenClass == none)
	{
		if (MCM_API(Screen) != none)
		{
			ScreenClass = Screen.Class;
		}
		else
		{
			return;
		}
	}

	MCMScreen = new class'BlackMarketSoldierStats_Settings';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}

