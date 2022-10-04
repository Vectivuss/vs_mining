include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()

	local t = VectivusMining:getOre( self:GetOre() )
	if !t then return end

	local p, w, h = LocalPlayer(), ScrW(), ScrH()
	if p:GetPos():Distance( self:GetPos() ) > 100 then return end

	local pos = self:GetPos() + Vector( 0, 0, self:OBBMaxs().z ) + Vector(0,0,math.sin(CurTime()*2+self:EntIndex()))
	local ang = p:EyeAngles()

	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )
	pos = pos + Vector( 0, 0, 12 )

	cam.Start3D2D( pos, ang, 0.1 )
		local text = ( ( t and t.name ) or "Ore Base" )
		surface.SetFont( "vs.mining.ui.35" )
		local tW, _ = surface.GetTextSize( text ) + w*.02
		draw.RoundedBox( 0, -tW / 2, -50, tW, 60, Color( 0, 0, 0, 188 ) )
		draw.SimpleText( text, "vs.mining.ui.35", 0, -24, ( t.color or color_white ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end