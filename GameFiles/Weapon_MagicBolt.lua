function Weapon_MagicBolt(owner)
	local self = Weapon()

	self.owner  = owner
	self.attack_cooldown = 0.4

	

	function self.attack(self)
		self.owner.world:addSprite(Projectile_MagicBolt(self.owner))	
	end

	function self.update(self, dt)
		
	end

	function self.draw(self)
		--
	end

	return self
end