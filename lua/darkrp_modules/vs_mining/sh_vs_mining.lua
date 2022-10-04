TEAM_VS_MINER = DarkRP.createJob( "Miner", 
    {
        color           = Color( 73, 122, 214 ),
        model           = { "models/player/eli.mdl" },
        description     = [[ Typical ore miner that is can collect/sell ore(s) and craft items ]],
        weapons         = { "vs_mining_pickaxe" },
        command         = "vs_miner",
        max             = 6,
        salary          = 90,
        admin           = 0,
        vote            = false,
        category        = "Citizens",
        hasLicense      = false,
    }
)
