include( "shared.lua" )

function ENT:Draw()
	self:DrawModel()

	local p, w, h = LocalPlayer(), ScrW(), ScrH()
	if p:GetPos():Distance( self:GetPos() ) > 250 then return end

	local pos = self:GetPos() + Vector( 0, 0, self:OBBMaxs().z ) + Vector(0,0,math.sin(CurTime()*1+self:EntIndex()))
	local ang = p:EyeAngles()

	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )
	pos = pos + Vector( 0, 0, 10 )

	cam.Start3D2D( pos, ang, 0.1 )
		local text = "Mining NPC"

		surface.SetFont( "vs.mining.ui.35" )
		local tW, _ = surface.GetTextSize( text ) + w*.01
		draw.RoundedBox( 0, -tW/2, -30, tW, 55, Color( 0, 0, 0, 220 ) )

		draw.SimpleText( text, "vs.mining.ui.35", 0, -5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end