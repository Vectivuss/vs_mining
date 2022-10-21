function VectivusMining:MineOre( p, ore, amount )
    if !IsValid( p ) then print( "VectivusMining:MineOre", "missing argument #1 (player)" ) return end
    if !ore then print( "VectivusMining:MineOre", "missing argument #2 (entity ore)" ) return end
    local t = self:getOre( ore )
    if !t then print( "VectivusMining:MineOre", "argument #2 (invalid ore type)" ) return end

    local sid = p:SteamID()
    local lvl = self:getPlayerLevel( sid )
    amount = math.random( 1 * lvl, amount + lvl )

    local vars = self:getOreVars( p, ore )
    local totalOre = ( vars[ ore ] or 0 )
    local capacity = VectivusMining:getOre( ore ).capacity or 0

    if totalOre >= capacity then
        if DarkRP then
            DarkRP.notify( p, 1, 2, "[MINING] You've reached max capacity for " .. ore .. "!" )
        else
            self:AddText( p, "You've reached max capacity for " .. ore .. "!" )
        end
        return 
    end

    totalOre = ( totalOre + amount ) 
    do // check if the player has reached capacity
        if totalOre > capacity then
            local overCapacity = ( totalOre - capacity )
            amount = amount - overCapacity
            VectivusMining:MineOre( p, ore, amount )
            return
        end
    end

    self:SetPlayerOre( sid, ore, totalOre )
    self:AddPlayerXP( sid, amount )

    if DarkRP then
        DarkRP.notify( p, 0, 2, "[MINING] You've gained " .. amount .. " " .. ore .. "!" )
    else
        self:AddText( p, "You've gained " .. amount .. " " .. ore .. "!" )
    end
end

function VectivusMining:CraftItem( p, item )
    if !IsValid( p ) then print( "VectivusMining:CraftItem", "missing argument #1 (player)" ) return end
    if !item then print( "VectivusMining:CraftItem", "missing argument #2 (string item)" ) return end
    local t = self:getItem( item )
    if !t then print( "VectivusMining:CraftItem", "argument #2 (invalid item '" .. item .. "')" ) return end

    local tt = {}
    do // Checks if the player can afford to craft item
        local cannotAfford = false
        for k, v in pairs( t ) do
            if !self:getOre( k ) then continue end
            tt[ k ] = v
            if !self:canAfford( p, k, v ) then
                cannotAfford = true
            end
        end
        if cannotAfford then
            VectivusMining:AddText( p, "Insufficient crafting materials." )
            return
        end
    end

    if p:HasWeapon( item ) then
        self:AddText( p, "You're currently holding a(n) " .. item .. "!" )
        return
    end

    local sid = p:SteamID()
    for k, v in pairs( tt ) do
        local ore = self:getPlayerOres( sid )
        ore = ( ore[k] or 0 )
        ore = ore - v
        self:SetPlayerOre( sid, k, ore )
    end
    self:AddText( p, "Crafted: " .. item .. "!" )

    if self:IsEntity( item ) then
        local trace = {}
        trace.start = p:EyePos()
        trace.endpos = trace.start + p:GetAimVector() * 100
        trace.filter = p
        local tr = util.TraceLine( trace )

        local e = ents.Create( item )
        e:SetPos( tr.HitPos )
        e:Spawn()
        return
    end

    p:Give( item )
end
concommand.Add( "vs.mining.craftingitem", function( p, _, t )
    local k = tostring( t[1] or "" )
    VectivusMining:CraftItem( p, k )
end )