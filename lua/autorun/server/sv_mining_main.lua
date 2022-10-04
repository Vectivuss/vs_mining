resource.AddWorkshop( "2869256243" )
util.AddNetworkString( "VectivusMining.SyncData" )
util.AddNetworkString( "VectivusMining.Effect" )

function VectivusMining:SetOreVar( p, k, v )
    local t = self:getOreVars( p, k )
    t[ k ] = v
    p.oreVars = t
    p:SetNWInt( "VectivusMining.OreVar." .. tostring( k ), v )
end

function VectivusMining:getPlayerOres( sid )
    if !sid then return end
    if !self:LoadData( sid, "ores" ) then return {} end
    local getOre = self:LoadData( sid, "ores", true )
    return getOre or {}
end

function VectivusMining:SetPlayerOre( sid, k, v )
    if !sid then return end
    local t = self:getOre( k or "" )
    if !t then return end
    if !v then return end

    local getOre = self:getPlayerOres( sid )
    getOre[ k ] = v
    self:SaveData( sid, "ores", getOre, true )

    local p = player.GetBySteamID( sid )
    if p then self:SetOreVar( p, k, v ) end
end

hook.Add( "PlayerSpawn", "VectivusMining.LoadData", function( p ) 
    if !IsValid( p ) then return end
    if p.vs_mining_inital_data then return end
    p.vs_mining_inital_data = true
    local sid = p:SteamID()
    local lvl = VectivusMining:LoadData( sid, "level" ) or 1
    local xp = VectivusMining:LoadData( sid, "xp" ) or 0
    p:SetNWInt( "VectivusMining.PlayerLevel", lvl )
    p:SetNWInt( "VectivusMining.PlayerXP", xp )
    // MOUNTS ORES //
    local getOres = VectivusMining:getPlayerOres( sid )
    for k, _ in pairs( VectivusMining:getAllOres() or {} ) do
        VectivusMining:SetOreVar( p, k, getOres[ k ] )
    end
    // MOUNTS ORES //
end )

function VectivusMining:Sync( p )
    if !IsValid( p ) then return end
    net.Start( "VectivusMining.SyncData" )
    net.Send( p )
end

function VectivusMining:SyncAll()
    for _, p in pairs( player.GetAll() ) do
        if !IsValid( p ) then continue end
        self:Sync( p )
    end
end