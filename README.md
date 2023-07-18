# Black Market Soldier Stats

XCOM 2 mod that shows the stats of soldiers for sale at the Black Market.

Optionally, a cost can be assigned to revealing the stats. Both the resource
type (Intel or Supplies) and the amount to be paid are configurable via Mod
Config Menu.

## Compatibility

This mod can be activated for existing campaigns. It's compatible with both
vanilla as well as War of the Chosen.

When the option to assign a cost to revealing stats is used, you cannot safely
remove the mod from the campaign anymore.

## Credits

For the sake of a consistent user experience, the stats layout is the same as
in AstralDescend's [Stats on New Promotion Screen](https://steamcommunity.com/sharedfiles/filedetails/?id=1716973380).
The side panel idea was inspired by [Extended Personnel Info](https://steamcommunity.com/sharedfiles/filedetails/?id=1458945379)
by the same author.

## Building

The mod can be built with Visual Studio Code. Be sure to add a `settings.json` file to the
directory `.vscode` and add your Steam paths as follows:

```
{
    "xcom.highlander.sdkroot": "D:\\Steam\\SteamApps\\common",
    "xcom.highlander.gameroot": "D:\\Steam\\SteamApps\\common\\XCOM 2",
}
```

Caveat: `xcom.highlander.sdkroot` must not contain the complete path to the SDK but to the folder
above. So if the SDK is in `D:\Steam\SteamApps\common\XCOM 2 SDK`, the value for the variable must
be `D:\\Steam\\SteamApps\\common`.

To build both for Vanilla and War of the Chosen without changing the settings, both the Vanilla SDK
and the War of the Chosen SDK need to be in the same Steam folder (`D:\Steam\SteamApps\common` in
the example). If that's not the case, the `xcom.highlander.sdkroot` path has to be adapted when
switching the target.
