SWEP.PrintName = "Pickaxe"
SWEP.Purpose = "Used to mine ore(s)"
SWEP.Spawnable = true
SWEP.ViewModel = "models/zerochain/props_mining/zrms_v_pickaxe.mdl"
SWEP.WorldModel = "models/zerochain/props_mining/zrms_w_pickaxe.mdl"
SWEP.ViewModelFOV = 55
SWEP.UseHands = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.Weight = 5
SWEP.DrawCrosshair = true
SWEP.Category = "Vectivus´s Mining"
SWEP.DrawAmmo = false
SWEP.base = "weapon_base"
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType( "melee2" )
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	if !IsValid( self.Owner ) then return end
	self:SetNextPrimaryFire( CurTime() + 1 )
	local tr = self.Owner:GetEyeTrace()
	self:SendWeaponAnim( ACT_VM_HITCENTER )
	self:SendWeaponAnim( ACT_VM_MISSCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    if SERVER then
        local e = tr.Entity
        local d = tr.HitPos:Distance( tr.StartPos )
        if d > 64 then return end
        if !IsValid(e) then return end
        self:ShootBullet( 1, 1, 0, "", 1, 0 )
		sound.Play( "Concrete.ImpactHard", tr.HitPos, 75, 100, 1 )
    end
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Equip()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self.Owner:SetAnimation( PLAYER_IDLE )
end