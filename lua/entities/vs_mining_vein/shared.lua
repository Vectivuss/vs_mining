ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Vein Base"
ENT.Author = "Vectivus"
ENT.Category = "Vectivus´s Mining"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar( "String", 1, "Ore" )
end