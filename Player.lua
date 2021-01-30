function Player(world, x, y)
	local self = Sprite()
	self.type = "Player"

	self.drawable = Player_draw(self)

	self.world = world
	self.x = x
	self.y = y
	self.w = 20
	self.h = 26

	self.team = 1

	self.life = 100

	self.vel_x = 0
	self.vel_x_max = 500
	self.vel_y = 0

	self.knockback = 400

	self.direction = "right"

	

	self.speed = 800
	self.groundDrag = 2
	self.airDrag = 1.5

	self.jumpForce = 700

	self.pressed_jump = false
	self.remainingJumpsMax = 1
	self.remainingJumps = self.remainingJumpsMax

	self.pressed_attack = false
	self.attack_lag = 4/16
	self.attack_cooldown = 0.2
	self.attack_counter = 0

	self.invincibility_time = 0.2
	self.invincibility_counter = 0

	self.sound_jump = love.audio.newSource("sfx/player_jump.wav", "static")
	self.sound_jump:setVolume(0.2)
	self.sound_death = love.audio.newSource("sfx/goblin_death.wav", "static")
        self.sound_death:setVolume(0.2)

	function self.draw(self)
		--love.graphics.push()
		
		--love.graphics.setColor(1, 0, 0)
		
		--love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		
		--love.graphics.setColor(1, 1, 1)

		self.drawable:draw()
	end

	function self.update(self, dt)
		self.invincibility_counter = self.invincibility_counter - dt
		

		self:applyVelocity(dt)
		self:applyGravity(dt)
		self:checkGroundCollision(dt)
		self:checkCeilingCollision(dt)

		if love.keyboard.isDown("w") then
			if not self.pressed_jump and self:canJump()  then
				love.audio.play(self.sound_jump)
				self:jump(self.jumpForce)
			end
			self.pressed_jump = true
		else
			if self.pressed_jump then
				self:breakJump(400)
			end
			self.pressed_jump = false
		end
		
		local pressed_left = false
		local pressed_right = false
		if love.keyboard.isDown("d") then
			if love.keyboard.isDown("a") then
				
			else
				pressed_right = true
				if self.attack_counter <= 0 then
					self.direction = "right"
				end
			end
		elseif love.keyboard.isDown("a") then
			pressed_left = true
			if self.attack_counter <= 0 then
				self.direction = "left"
			end
		end

		if pressed_right then
			self:moveRight(dt, self.speed, 3)
		elseif pressed_left then
			self:moveLeft(dt, self.speed, 3)
		elseif not pressed_left and not pressed_right then
			self:decelerate(dt, self.speed, self.groundDrag, self.airDrag)
		end


		self:checkWallCollision()

		self.attack_counter = self.attack_counter - dt
		if love.keyboard.isDown("space") then
			if self.attack_counter <= -self.attack_cooldown and not self.pressed_attack then
				self.attack_counter = self.attack_lag
				self.world:addSprite(Projectile_Sword(self))
			end
			self.pressed_attack = true
		else
			self.pressed_attack = false
		end

		self.drawable:update(dt)

		self:foreachSprite(self.checkCollision)
	end

	self.destroyFunction = function(self)
		self.destroy = true
		love.audio.play(self.sound_death)
        end
	
	function self.checkCollision(self, obj)
		if CheckCollision(self.x, self.y, self.w, self.h, obj.x, obj.y, obj.w, obj.h) then
			if obj.type == "Coin" then
				obj:destroyFunction()
			elseif 	obj.type == "Goblin" then
				if self.invincibility_counter <= 0 then
					self.life = self.life - obj.damage
					self.invincibility_counter = self.invincibility_time
					local flip = 1
					if self.direction == "left" then
						flip = -1
					end
					self.vel_x = -flip * self.knockback
					self.vel_y = -self.knockback/2
				end
			end
		end
	end

	return self
end