-- Ammo override base

if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"

-- Override these values
ENT.AmmoType = "Pistol"
ENT.AmmoAmount = 1
ENT.AmmoMax = 10
ENT.Model = Model( "models/props_junk/GlassBottle01a.mdl" )


function ENT:RealInit() end -- bw compat

-- Some subclasses want to do stuff before/after initing (eg. setting color)
-- Using self.BaseClass gave weird problems, so stuff has been moved into a fn
-- Subclasses can easily call this whenever they want to
function ENT:Initialize()
   self:SetModel( self.Model )
	
   self.h = 0
   self:PhysicsInit( SOLID_BBOX )
   self:SetMoveType( MOVETYPE_NONE )
   self:SetSolid( SOLID_BBOX )

   self:SetCollisionGroup( COLLISION_GROUP_WORLD )
   local b = 45
   self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))
   if SERVER then
      self:SetTrigger(true)
   end
	
   self.taken = false
   self.pos = self:GetPos()
   self.pos = Vector(self.pos.x,self.pos.y,self.pos.z + 10)
   self:SetPos(self.pos)
   
   self:SetModelScale( self:GetModelScale() * 1.5, 0 )
   -- this made the ammo get physics'd too early, meaning it would fall
   -- through physics surfaces it was lying on on the client, leading to
   -- inconsistencies
   --	local phys = self.Entity:GetPhysicsObject()
   --	if (phys:IsValid()) then
   --		phys:Wake()
   --	end
end

-- Pseudo-clone of SDK's UTIL_ItemCanBeTouchedByPlayer
-- aims to prevent picking stuff up through fences and stuff
function ENT:PlayerCanPickup(ply)
   if ply == self:GetOwner() then return false end

   local ent = self.Entity
   local phys = ent:GetPhysicsObject()
   local spos = phys:IsValid() and phys:GetPos() or ent:OBBCenter()
   local epos = ply:GetShootPos() -- equiv to EyePos in SDK

   local tr = util.TraceLine({start=spos, endpos=epos, filter={ply, ent}, mask=MASK_SOLID})

   -- can pickup if trace was not stopped
   return tr.Fraction == 1.0
end


function ENT:Touch(ent)
   if SERVER and self.taken != true then
      if (ent:IsValid() and ent:IsPlayer())  then
			ent:AwardPerk()
			ent:EmitSound("items/smallmedkit1.wav",150,130)
			RespawnPerk(self.pos)
            self:Remove()
            -- just in case remove does not happen soon enough
            self.taken = true
      end
   end
end

-- Hack to force ammo to physwake
if SERVER then
   function ENT:Think()
		self.h = self.h + 1
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), ang.p + 20)
		self:SetAngles(ang)
		
		local pos = self:GetPos()
		self:SetPos(Vector(pos.x,pos.y,pos.z + math.sin(self.h) * 3))
	end
end
