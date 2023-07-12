class UISL_BlackMarket_Buy extends UIScreenListener;

event OnInit(UIScreen Screen)
{
    local UIBlackMarket_Buy BlackMarketBuy;
    local SoldierStatsPanel Stats;

    BlackMarketBuy = UIBlackMarket_Buy(Screen);
    if (BlackMarketBuy != none)
    {
        Stats = BlackMarketBuy.Spawn(class'SoldierStatsPanel', BlackMarketBuy);
        Stats.Init(BlackMarketBuy);
    }
}

event OnReceiveFocus(UIScreen Screen)
{
    OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}