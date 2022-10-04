AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    local t = VectivusMining:getOre( self:GetOre() )

    self:SetModel( "models/props_junk/rock001a.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
    if IsValid( self:GetPhysicsObject() ) then
        self:GetPhysicsObject():Wake()
    end

    if !t then return end
    self:SetColor( t.color )
end

function ENT:Use( p )
    self:SetModelScale( 0, .1 )
    timer.Simple( .2, function()
        if !IsValid( self ) then return end
        SafeRemoveEntity( self )
        if !IsValid( p ) then return end
        VectivusMining:MineOre( p, self:GetOre(), VectivusMining.ore_amount )
    end )
end