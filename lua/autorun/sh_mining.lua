VectivusMining = VectivusMining or {}
VectivusMining.ores = VectivusMining.ores or {}
VectivusMining.craftables = VectivusMining.craftables or {}

function VectivusMining:getAllOres()
    return self.ores or {}
end

function VectivusMining:getOre( k )
    return self:getAllOres()[ k or "" ] or false
end

function VectivusMining:getOreVars( p, k )
    if SERVER then
        return p.oreVars or {}
    end
    return p:GetNWInt( "VectivusMining.OreVar." .. tostring( k ), 0 )
end

function VectivusMining:IsEntity( txt )
    return scripted_ents.Get( txt or "" ) and true or false
end

function VectivusMining:IsWeapon( txt )
    return weapons.Get( txt or "" ) and true or false
end

function VectivusMining:canAfford( p, k, v )
    if !IsValid( p ) then return end
    if !self:getOre( k or "" ) then return end
    local ore = self:getOreVars( p, k )
    if SERVER then
        return ( ore[ k ] or 0 ) >= v and true or false
    end
    return ore >= v and true or false
end

function VectivusMining:RegisterOre( k, t )
    t.id = k
    self.ores[ k ] = t
end

function VectivusMining:GenerateOres()
    for k, t in pairs( self:getAllOres() ) do
        local ENT = {}
        ENT.Base = "vs_mining_vein"
        ENT.ClassName = "vs_mining_vein_" .. k
        ENT.PrintName = t.name
        ENT.Category = "Vectivus´s Mining"
        ENT.Spawnable = true
        if SERVER then ENT.OreKey = k end
        scripted_ents.Register( ENT, ENT.ClassName )
        print( "[   Vectivus´s Mining - Register Ore:  ]", k )
    end
end

function VectivusMining:RegisterItem( k, t )
    t.id = k
    self.craftables[ k ] = t
end

function VectivusMining:getAllItems()
    return self.craftables or {}
end

function VectivusMining:getItem( k )
    return self:getAllItems()[ k or "" ] or false
end

function VectivusMining:getPlayerLevel( sid )
    if !sid then return end
    local p = player.GetBySteamID( sid )
    if p then
        return tonumber( p:GetNWInt( "VectivusMining.PlayerLevel", 1 ) )
    end
    if SERVER then return self:LoadData( sid, "level" ) end
end

function VectivusMining:getPlayerXP( sid )
    if !sid then return end
    local p = player.GetBySteamID( sid )
    if p then
        return tonumber( p:GetNWInt( "VectivusMining.PlayerXP", 0 ) )
    end
    if SERVER then return self:LoadData( sid, "xp" ) end
end

function VectivusMining:getMaxXP( sid )
    if !sid then return end
    local lvl = self:getPlayerLevel( sid )
    return ( ( lvl or 1 ) * ( self.xp_default ) * (  self.xp_multiplier ) )
end
