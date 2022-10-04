VectivusMining.ores = {}
VectivusMining.craftables = {}
//////////////////////////////////////////////////////////////////////////////////

/////////////////////////////// Vectivus´s Mining /////////////////////////////

// Developed by Vectivus:
// http://steamcommunity.com/id/vectivuss
// http://github.com/vectivuss

// Wish to contact me:
// vectivus@qrextomniaservers.co

//////////////////////////////////////////////////////////////////////////////////

local config = VectivusMining

// Max mining level you gain from collecting ores
config.max_level = 15

// How hard it is to level up, 2 would require twice as much etc
config.xp_multiplier = 1

// Default XP ( first level )
config.xp_default = 1000

// Weapns that can 'damage/mine' the ore(s)
config.mining_tools = { 
    vs_mining_pickaxe = 4,
}

// How many hitpoints does ore vein(s) have
config.ore_health = 20

// How much ore(s) the rock can give to a player. E.g an ore can give max 4
config.ore_amount = 4

// How much ore(s) is added onto 'ore_amount' based on level. E.g when level 2 the player can gain 6 max
config.ore_level = 2

/////////////////// CRAFT ///////////////////

VectivusMining:RegisterItem( "weapon_fists", {
    name = "Fists",
    model = "models/hunter/blocks/cube025x025x025.mdl", -- use this to overwrite default look ( MUST be used on hl2 items as they're not done in lua )
    bronze = 150,
    silver = 110,
    gold = 25,
} )

VectivusMining:RegisterItem( "weapon_medkit", {
    name = "Medkit",
    bronze = 222,
    silver = 55,
    ruby = 50,
} )

/////////////////// ORES ///////////////////

VectivusMining:RegisterOre( "bronze", {
    name = "Bronze",
    color = Color( 202, 142, 86 ),
    capacity = 5000,
    order = 1,
} )

VectivusMining:RegisterOre( "silver", {
    name = "Silver",
    color = Color( 185, 177, 181 ),
    capacity = 5000,
    order = 2,
} )

VectivusMining:RegisterOre( "gold", {
    name = "Gold",
    color = Color( 217, 238, 96 ),
    capacity = 5000,
    order = 3,
} )

VectivusMining:RegisterOre( "diamond", {
    name = "Diamond",
    color = Color( 87, 165, 238 ),
    capacity = 5000,
    order = 4,
} )

VectivusMining:RegisterOre( "ruby", {
    name = "Ruby",
    color = Color( 202, 50, 100 ),
    capacity = 5000,
    order = 5,
} )

/////////////////// CONFIG ENDS HERE ///////////////////
if SERVER then timer.Simple( 0, function() VectivusMining:GenerateOres() VectivusMining:SyncAll() end ) end -- IGNORE
/////////////////// CONFIG ENDS HERE ///////////////////