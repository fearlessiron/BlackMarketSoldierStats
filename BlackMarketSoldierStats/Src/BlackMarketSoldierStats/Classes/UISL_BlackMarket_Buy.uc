class UISL_BlackMarket_Buy extends UIScreenListener;

event OnInit(UIScreen Screen)
{
    if (UIBlackMarket_Buy(Screen) != none)
    {
        AddStats(UIBlackMarket_Buy(Screen));
    }
}

event OnReceiveFocus(UIScreen Screen)
{
    OnInit(Screen);
}

function AddStats(UIBlackMarket_Buy Screen)
{
    local XComGameStateHistory History;
    local X2CharacterTemplateManager TemplateManager;
    local X2CharacterTemplate CharacterTemplate;
    local UIInventory_ListItem ListItem;
    local XComGameState_Reward RewardState;
    local XComGameState_Unit UnitState;
    local UIImage StatsImage;
    local int RewardRefObjectID;
    local int i;
    local string StatsString;

    History = `XCOMHISTORY;
    TemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    for (i = 0; i < Screen.List.ItemCount; i++)
    {
        ListItem = UIInventory_ListItem(Screen.List.GetItem(i));
        RewardRefObjectID = ListItem.ItemComodity.RewardRef.ObjectID;

		if (RewardRefObjectID != 0)
		{
			RewardState = XComGameState_Reward(History.GetGameStateForObjectID(RewardRefObjectID));
            if (RewardState == none)
            {
                return;
            }
			
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
        	if (UnitState != none)
            {
                if (UnitState.IsSoldier())
                {
                    CharacterTemplate = TemplateManager.FindCharacterTemplate(UnitState.GetMyTemplateName());
    
                    StatsString = "";
    
                    StatsImage = ListItem.Spawn(class'UIImage', ListItem).InitImage(, class'UIUtilities_Image'.static.GetToDoWidgetImagePath(eUIToDoCat_SoldierStatus));
                    StatsImage.ProcessMouseEvents();
                    StatsImage.SetScale(0.8);
                    StatsImage.SetPosition(575, 4);
                    StatsImage.SetColor(class'UIUtilities_Colors'.const.PERK_HTML_COLOR);
                    StatsImage.SetAlpha(0.8);

                    StatsString $= GetColoredStat(UnitState, eStat_Offense, CharacterTemplate) $ "<br/>";
                    StatsString $= GetColoredStat(UnitState, eStat_HP, CharacterTemplate) $ "<br/>";
                    StatsString $= GetColoredStat(UnitState, eStat_Mobility, CharacterTemplate) $ "<br/>";
                    StatsString $= GetColoredStat(UnitState, eStat_Defense, CharacterTemplate) $ "<br/>";
                    StatsString $= GetColoredStat(UnitState, eStat_Will, CharacterTemplate) $ "<br/>";
                    StatsString $= GetColoredStat(UnitState, eStat_Hacking, CharacterTemplate) $ "<br/>";
                    StatsString $= GetColoredStat(UnitState, eStat_Dodge, CharacterTemplate) $ "<br/>";

                    StatsImage.SetTooltipText(StatsString, class'UIControllerMap'.default.m_sDetails);
                }
            }
        }
    }
}

function string GetColoredStat(XComGameState_Unit Unit, ECharStatType StatType, X2CharacterTemplate CharacterTemplate)
{
    local int UnitStat, BaseStat;
    local string StatLabel;
    local EUIState Colour;
    
    StatLabel = class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[StatType] $ ":";
    UnitStat = Unit.GetCurrentStat(StatType);
    BaseStat = CharacterTemplate.CharacterBaseStats[StatType];

    if (UnitStat < BaseStat)
    {
        Colour = eUIState_Bad;
    }
    else if (UnitStat > BaseStat)
    {
        Colour = eUIState_Good;
    }
    else
    {
        Colour = eUIState_Normal;
    }

    return StatLabel @ class'UIUtilities_Text'.static.GetColoredText(string(UnitStat), Colour);
}

defaultproperties
{
    ScreenClass = none;
}