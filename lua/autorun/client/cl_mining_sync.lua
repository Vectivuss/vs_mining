// NETWORKED DATA //
timer.Simple( 0, function() VectivusMining:GenerateOres() end )
net.Receive( "VectivusMining.SyncData", function()
    VectivusMining:GenerateOres()
    RunConsoleCommand( "spawnmenu_reload" )
end )
// NETWORKED DATA //


// NETWORKED CHAT //
net.Receive( "VectivusMining.Chat", function()
    chat.AddText( Color( 73, 122, 214 ), "[MINING]" .. " ", color_white, net.ReadString() or "" )
end )
// NETWORKED CHAT //


// NETWORKED ORE EFFECT //
net.Receive( "VectivusMining.Effect", function()
    local v = net.ReadVector()
	local effectData = EffectData()
	effectData:SetOrigin( v or Vector(0,0,0) )
	effectData:SetScale( .02 )
	effectData:SetMagnitude( .02 )
	util.Effect( "StunstickImpact", effectData )
end )
// NETWORKED ORE EFFECT //