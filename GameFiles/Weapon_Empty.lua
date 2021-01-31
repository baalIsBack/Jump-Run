function Weapon_Empty()
	local self = Weapon()

	self.owner  = owner
	self.attack_cooldown = 1

	

	function self.attack(self)
		--self.owner.world:addSprite(Projectile_Sword(self.owner))	
	end

	function self.update(self, dt)
		
	end

	function self.draw(self)
		--
	end

	return self
end