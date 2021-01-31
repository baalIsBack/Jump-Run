function Weapon_Sword(owner)
	local self = Weapon()

	self.owner  = owner
	self.attack_cooldown = 0.2

	

	function self.attack(self)
		self.owner.world:addSprite(Projectile_Sword(self.owner))	
	end

	function self.update(self, dt)
		
	end

	function self.draw(self)
		--
	end

	return self
end