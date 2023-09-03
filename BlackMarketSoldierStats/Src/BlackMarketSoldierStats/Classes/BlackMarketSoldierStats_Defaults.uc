class BlackMarketSoldierStats_Defaults extends Object config(BlackMarketSoldierStats_Defaults);

// Config version
var config int VERSION_CFG;

// Highlight above/below average stats
var config bool HIGHLIGHT_ABOVE_BELOW_AVERAGE;

// Panel location
var config int PANEL_X;
var config int PANEL_Y;

// Reveal cost
var config bool REVEAL_COST_ENABLED;
var config string REVEAL_COST_RESOURCE;
var config int REVEAL_COST_QUANTITY;

// Require Sectoid autopsy before showing Psi Offense stat
var config bool PSI_OFFENSE_REQUIRE_SECTOID_AUTOPSY;