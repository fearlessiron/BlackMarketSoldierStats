class SoldierStatsPanel extends UIPanel;

`include(BlackMarketSoldierStats\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

var UIBlackMarket_Buy BlackMarketBuy;
var X2CharacterTemplateManager TemplateManager;

var XComGameState_Unit SelectedUnit;
var X2CharacterTemplate CharacterTemplate;
var X2SoldierClassTemplate SoldierClassTemplate;
var XComGameState_Reward_BMSS PersonellRewardState;

var UIPanel StatsContainer;
var UIStatList StatList;
var UIButton RevealButton;
var UIText RevealCostLabel;

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
        SoldierClassTemplate = SelectedUnit.GetSoldierClassTemplate();
        PersonellRewardState = GetPersonellRewardState();
    }
}

function XComGameState_Reward_BMSS GetPersonellRewardState()
{
    local XComGameState_Reward_BMSS RevealState;

    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Reward_BMSS', RevealState)
    {
        if (RevealState.RewardRef.ObjectID == SelectedUnit.GetReference().ObjectID)
        {
            return RevealState;
        }
    }

    return none;
}

function bool IsRevealCostEnabled()
{
    return `GETMCMVAR(REVEAL_COST_ENABLED);
}

function UpdateStats()
{
    local UIBGBox BGBox;
    local UIX2PanelHeader Header;
    local string RevealButtonText, CostString;

    if (StatsContainer != none)
    {
        StatsContainer.Remove();
        StatsContainer = none;
    }

    if (StatList != none)
    {
        StatList.Remove();
        StatList = none;
    }

    if (RevealButton != none)
    {
        RevealButton.Remove();
        RevealButton = none;
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

    if (IsRevealCostEnabled())
    {
        RevealButtonText = class'UIAdventOperations'.default.m_strReveal;
        CostString = class'UIUtilities_Strategy'.static.GetStrategyCostString(GetRevealCost(), GetCostScalars());
        CostString = class'UIUtilities_Text'.static.AddFontInfo(CostString, false, true, , 24);	

        RevealButton = Spawn(class'UIButton', StatsContainer);
        RevealButton.InitButton('RevealButton', RevealButtonText, OnRevealButtonClicked);
        RevealButton.OnSizeRealized = OnButtonSizeRealized;

        RevealCostLabel = Spawn(class'UIText', StatsContainer);
        RevealCostLabel.InitText();
        RevealCostLabel.SetText(class'UIUtilities_Text'.static.AlignCenter(CostString));
        RevealCostLabel.SetWidth(PanelWidth);
        RevealCostLabel.SetY((40 + PanelHeight) / 2.0);

        if (PersonellRewardState != none && PersonellRewardState.RevealCostPaid)
        {
            RevealButton.Remove();
            RevealCostLabel.Remove();
            RevealStats();
        }
    }
    else
    {
        RevealStats();
    }
}

simulated function array<StrategyCostScalar> GetCostScalars()
{
    local array<StrategyCostScalar> CostScalars;

    CostScalars.Length = 0;

    return CostScalars;
}

simulated function StrategyCost GetRevealCost()
{
    local StrategyCost RevealCost;
    local ArtifactCost ResourceCost;

    RevealCost.ResourceCosts.Length = 0;
    ResourceCost.ItemTemplateName = name(`GETMCMVAR(REVEAL_COST_RESOURCE));
    ResourceCost.Quantity = `GETMCMVAR(REVEAL_COST_QUANTITY);
    RevealCost.ResourceCosts.AddItem(ResourceCost);

    return RevealCost;
}

simulated function OnRevealButtonClicked(UIButton Button)
{
    local XComGameState_HeadquartersXCom XComHQ;
    local XComGameState NewGameState;
    local XComGameState_Reward_BMSS RewardPaidState;

    XComHQ = `XCOMHQ;

    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reveal Black Market Soldier Stats");
    XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    NewGameState.AddStateObject(XComHQ);

    XComHQ.PayStrategyCost(NewGameState, GetRevealCost(), GetCostScalars());

    RewardPaidState = XComGameState_Reward_BMSS(NewGameState.CreateStateObject(class'XComGameState_Reward_BMSS'));
    RewardPaidState.RewardRef = SelectedUnit.GetReference();
    RewardPaidState.RevealCostPaid = true;
    NewGameState.AddStateObject(RewardPaidState);

    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

    Button.Remove();
    RevealCostLabel.Remove();

    `HQPRES.m_kAvengerHUD.UpdateResources();

    RevealStats();
}

simulated function RevealStats()
{
    local array<UISummary_ItemStat> Stats;

    Stats.AddItem(GetStat(SelectedUnit, eStat_HP));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Will));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Offense));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Mobility));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Hacking));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Dodge));
    Stats.AddItem(GetStat(SelectedUnit, eStat_Defense));
    if (!`GETMCMVAR(PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY) || `XCOMHQ.IsTechResearched('AutopsySectoid'))
    {
        Stats.AddItem(GetStat(SelectedUnit, eStat_PsiOffense));
    }
 
    StatList.RefreshData(Stats, false);
}

simulated function OnButtonSizeRealized()
{
    RevealButton.SetX((PanelWidth - RevealButton.Width) / 2.0);
    RevealButton.SetY((PanelHeight - RevealButton.Height) / 2.0);
}

function UISummary_ItemStat GetStat(XComGameState_Unit Unit, ECharStatType StatType)
{
    local int UnitStat, BaseStat, ProgressedStat, Rank, i, j;
    local EUIState Colour;
    local UISummary_ItemStat Stat;
    local array<SoldierClassStatType> StatProgression;
    
    UnitStat = Unit.GetCurrentStat(StatType);
    BaseStat = CharacterTemplate.CharacterBaseStats[StatType];
    ProgressedStat = BaseStat;
    Rank = Unit.GetRank();

    for (i = 0; i < Rank; i++)
    {
        // Calculate stat progression
        StatProgression = SoldierClassTemplate.GetStatProgression(i);
        for(j = 0; j < StatProgression.Length; j++)
        {
            if (StatProgression[j].StatType == StatType)
            {
                ProgressedStat += StatProgression[j].StatAmount;
            }
        }
    }

    if (UnitStat < ProgressedStat && `GETMCMVAR(HIGHLIGHT_ABOVE_BELOW_AVERAGE))
    {
        Colour = eUIState_Bad;
    }
    else if (UnitStat > ProgressedStat && `GETMCMVAR(HIGHLIGHT_ABOVE_BELOW_AVERAGE))
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
