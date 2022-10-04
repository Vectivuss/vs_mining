AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetOre( self.OreKey or "" )
    local t = VectivusMining:getOre( self:GetOre() )
    self:SetModel( "models/props/cs_militia/militiarock05.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:GetPhysicsObject():EnableMotion( false )
	self:Reset()

    if !t then return end
    self:SetColor( t.color )
end

function ENT:Reset() 
	self:SetNoDraw( false )
	self:SetNotSolid( false )
	self.NumberOfHits = 0
	self:SetMaxHealth( VectivusMining.ore_health )
	self:SetHealth( self:GetMaxHealth() - self.NumberOfHits )
	self:RemoveAllDecals()
end

function ENT:Think()
	self:NextThink( CurTime() + 1 )  
	return true
end

function ENT:SpawnOre( v, n, a )
	local k = self:GetOre()
	if !k then return end
	local e = ents.Create( "vs_mining_ore" )
	if !IsValid( e ) then return end
	e:SetOre( k )
	e:SetPos( v )
	e:Spawn()
	e:GetPhysicsObject():SetVelocity( n + VectorRand() * ( a or 100 ) )
	e:PhysWake()
	timer.Create( "vs_mining_ore.despawntime." .. tostring( e ), 15, 1, function()
		if !IsValid( e ) then return end
		SafeRemoveEntity( e )
	end )
end

function ENT:ScaleDownAndUp()
	local k = tostring( self )
	self:SetModelScale( .9, .1 )
	timer.Create( k ..".ScaleDownAndUp", .1, 1, function()
		if !IsValid( self ) then return end
		self:SetModelScale( 1, .1 )
	end	)
end

function ENT:OnTakeDamage( t )
    local att = t:GetAttacker()
	local inf = t:GetInflictor()
	local w = att and att.GetActiveWeapon and att:GetActiveWeapon() 
	if !IsValid( att ) or !IsValid( inf ) or !IsValid( w ) then return end

    local sid = att:SteamID()
    local spawnCount
    spawnCount = VectivusMining.mining_tools[ w:GetClass() ] or 0
    if spawnCount < 1 then return end

    local tt = VectivusMining:getOre( self:GetOre() )
    if !tt then return end

    if VectivusMining:getPlayerLevel( sid ) < ( ( tt and tt.level ) or 0 ) then
		VectivusMining:AddText( att, "Requires mining level " .. tt.level .. "!" )
        return
    end

	self:ScaleDownAndUp()

	local v = t:GetDamagePosition()
	local n = ( att:EyePos() - v ) * 2

	net.Start( "VectivusMining.Effect" )
		net.WriteVector( v )
	net.Send( att )

	util.ScreenShake( v, 1, 1000, .2, 128 )	
	self:SetMaxHealth( VectivusMining.ore_health )
	
	do // depleation and respawn systems	
		self.NumberOfHits = (self.NumberOfHits or 0) + 1
		self:SetHealth( self:GetMaxHealth() - self.NumberOfHits )

		local chance = math.random( 1, 3 )
		
		if chance == 1 then
			self:SpawnOre( v, n )
		end

		if self.NumberOfHits >= self:GetMaxHealth() then 
			self:SetNoDraw( true )
			self:SetNotSolid( true )

			for i=1, spawnCount do
				self:SpawnOre( v, n )
			end
		end
		
		timer.Create( tostring(self).."Respawn", 5, 1, function()
			if !IsValid(self) then return end
			self:Reset()
		end	)
	end
end