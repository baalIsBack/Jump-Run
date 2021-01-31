function Weapon()
	local self = {}

	self.cooldown = nil

	self.attack = nil
	self.update = nil --(self, dt)
	self.draw = nil --(self)

	return self
end