AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/Eli.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	if ( IsValid( self:GetPhysicsObject() ) ) then
		self:GetPhysicsObject():Wake()
	end
end

function ENT:Use( p )
	if !IsValid( p ) and !p:IsPlayer() then return end
	p:ConCommand( "vs.mining_ui" )
end