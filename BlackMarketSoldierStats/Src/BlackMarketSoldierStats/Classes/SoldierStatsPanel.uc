class SoldierStatsPanel extends UIPanel;

`include(BlackMarketSoldierStats\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

var UIBlackMarket_Buy BlackMarketBuy;
var X2CharacterTemplateManager TemplateManager;

var XComGameState_Unit SelectedUnit;
var X2CharacterTemplate CharacterTemplate;

var UIPanel StatsContainer;

var float PanelX, PanelY, PanelWidth, PanelHeight;

delegate OriginalOnSelectionChanged(UIList List, int ItemIndex);

function Init(UIBlackMarket_Buy TheScreen)
{
    InitPanel('SoldierStatsController');
    SetPosition(0, 0);

    BlackMarketBuy = TheScreen;
    TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    PanelX = `GETMCMVAR(PANEL_X);
    PanelY = `GETMCMVAR(PANEL_Y);

    OriginalOnSelectionChanged = BlackMarketBuy.List.OnSelectionChanged;
    BlackMarketBuy.List.OnSelectionChanged = OnSelectionChanged;
}

function OnSelectionChanged(UIList List, int ItemIndex)
{
    SetSelectedUnit(ItemIndex);
    UpdateStats();

    OriginalOnSelectionChanged(List, ItemIndex);
}

function SetSelectedUnit(int ItemIndex)
{
    local XComGameStateHistory History;
    local UIInventory_ListItem ListItem;
    local int RewardRefObjectID;
    local XComGameState_Reward RewardState;

    History = `XCOMHISTORY;

    SelectedUnit = none;

    ListItem = UIInventory_ListItem(BlackMarketBuy.List.GetItem(ItemIndex));
    RewardRefObjectID = ListItem.ItemComodity.RewardRef.ObjectID;

    if (RewardRefObjectID != 0)
    {
        RewardState = XComGameState_Reward(History.GetGameStateForObjectID(RewardRefObjectID));
        if (RewardState == none)
        {
            return;
        }
        
        SelectedUnit = XComGameState_Unit(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
        CharacterTemplate = TemplateManager.FindCharacterTemplate(SelectedUnit.GetMyTemplateName());
    }
}

function UpdateStats()
{
    local UIStatList StatList;
    local UIBGBox BGBox;
    local UIX2PanelHeader Header;
    local array<UISummary_ItemStat> Stats;

    if (StatsContainer != none)
    {
        StatsContainer.Remove();
        StatsContainer = none;
    }

    if (SelectedUnit == none || !SelectedUnit.IsSoldier())
    {
        return;
    }

    StatsContainer = Spawn(class'UIPanel', self);
    StatsContainer.bAnimateOnInit = false;
    StatsContainer.InitPanel();
    StatsContainer.SetPosition(PanelX, PanelY);

    BGBox = Spawn(class'UIBGBox', StatsContainer);
    BGBox.bAnimateOnInit = false;
    BGBox.InitBG('StatsContainerBG');
    BGBox.SetSize(PanelWidth, PanelHeight);
    BGBox.SetBGColor("gray");

    Header = Spawn(class'UIX2PanelHeader', StatsContainer);
    Header.InitPanelHeader('Header', class'UIControllerMap'.default.m_sDetails);
    Header.SetHeaderWidth(PanelWidth - 20);
    Header.SetPosition(10, 10);

    StatList = Spawn(class'UIStatList', StatsContainer);
    StatList.InitStatList('StatList');
    StatList.Width = PanelWidth;
    StatList.PADDING_LEFT = 10;
    StatList.PADDING_RIGHT = 10;
    StatList.SetY(50);

    Stats.AddItem(GetStat(SelectedUnit, eStat_HP));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Will));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Offense));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Mobility));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Hacking));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Dodge));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Defense));
    if (SelectedUnit.IsPsiOperative() || (SelectedUnit.GetRank() == 0 && !SelectedUnit.CanRankUpSoldier() && `XCOMHQ.IsTechResearched('AutopsySectoid')))
    {
        Stats.AddItem(GetStat(SelectedUnit, eStat_PsiOffense));
    }

    StatList.RefreshData(Stats, false);
}

function UISummary_ItemStat GetStat(XComGameState_Unit Unit, ECharStatType StatType)
{
    local int UnitStat, BaseStat;
    local EUIState Colour;
    local UISummary_ItemStat Stat;
    
    UnitStat = Unit.GetCurrentStat(StatType);
    BaseStat = CharacterTemplate.CharacterBaseStats[StatType];

    if (UnitStat < BaseStat && `GETMCMVAR(HIGHLIGHT_ABOVE_BELOW_AVERAGE))
    {
        Colour = eUIState_Bad;
    }
    else if (UnitStat > BaseStat && `GETMCMVAR(HIGHLIGHT_ABOVE_BELOW_AVERAGE))
    {
        Colour = eUIState_Good;
    }
    else
    {
        Colour = eUIState_Normal;
    }

    Stat.Label = class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[StatType];
    Stat.Value = string(int(SelectedUnit.GetCurrentStat(StatType)));
    Stat.ValueState = Colour;
    Stat.ValueStyle = eUITextStyle_Tooltip_AbilityRight; // Prevent that zeros are converted to dashes (--)
    
    return Stat;
}

defaultproperties
{
    PanelX = -225;
    PanelY = 175;
	PanelWidth = 250;
	PanelHeight = 300;

	bAnimateOnInit = false;
}
