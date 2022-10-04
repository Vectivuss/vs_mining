function VectivusMining:SetPlayerLevel( sid, i )
    if !sid then print( "VectivusMining:SetPlayerLevel", "missing argument #1 (string SteamID)" ) return end
    i = i or self:getPlayerLevel( sid )
    self:SaveData( sid, "level", i )
    local p = player.GetBySteamID( sid )
    if !p then return end
    p:SetNWInt( "VectivusMining.PlayerLevel", i )
end

function VectivusMining:SetPlayerXP( sid, i )
    if !sid then print( "VectivusMining:SetPlayerXP", "missing argument #1 (string SteamID)" ) return end
    i = i or self:getPlayerXP( sid )
    self:SaveData( sid, "xp", i )
    local p = player.GetBySteamID( sid )
    if !p then return end
    p:SetNWInt( "VectivusMining.PlayerXP", i )
end

function VectivusMining:AddPlayerXP( sid, i )
    if !sid then print( "VectivusMining:AddPlayerXP", "missing argument #1 (string SteamID)" ) return end

    local p = player.GetBySteamID( sid )
    local lvl = self:getPlayerLevel( sid )
    local xp = self:getPlayerXP( sid )
    local totalXP = xp + i

    if ( ( !lvl or !xp ) or lvl >= self.max_level ) then return end

    if totalXP >= self:getMaxXP( sid ) then
        lvl = lvl + 1
        self:SetPlayerLevel( sid, lvl )
        self:SetPlayerXP( sid, 0 )
        if p then
            VectivusMining:AddText( p, "You've reached level " .. lvl .. "!" )
        end
        return
    end
    self:SetPlayerXP( sid, totalXP )
end