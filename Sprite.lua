function Sprite()
        local self = {}

        self.world = nil
        self.type = nil

        self.x = nil
        self.y = nil
        self.x_vel = nil
        self.y_vel = nil

        self.team = nil

        self.life = nil
        self.damage = 0

        --[[
                undefined functions
        ]]----------------------------------------------------------------------------------------------------
        self.destroyFunction = nil--(self)
        self.update = nil--(self, dt)
        self.draw = nil--(self)
        

        --[[
                predefined functions
        ]]----------------------------------------------------------------------------------------------------


        --[[
                returns if the sprite is colliding on the ground
        ]]
        function self.onGround(self)
                if self.world:getTile(self.x + 1, self.y + self.h).solid or self.world:getTile(self.x + self.w - 1, self.y + self.h).solid then
                        return true
                end
                return false
        end

        --[[
                returns if the sprite can jump
        ]]
        function self.canJump(self)
                return self:onGround()
        end

        --[[
                applys the velocity to the actual position
        ]]
        function self.applyVelocity(self, dt)
		self.x = self.x + self.vel_x * dt
		self.y = self.y + self.vel_y * dt
        end

        --[[
                applys the gravity to the velocity if the sprite is not touching the ground
        ]]
        function self.applyGravity(self, dt, gravity)
                local gravity = gravity or 2000
                if not self:onGround() then
                        self.vel_y = self.vel_y + gravity * dt
                end
        end

        --[[
                checks if the sprite is colliding on the ground
                moves it and changes velocity
        ]]
        function self.checkGroundCollision(self, dt)
                if self:onGround() then
                        local tile_x, tile_y = self.world:getTileCoordinates(self.x + self.w/2, self.y + self.h + 1)
                        if self.vel_y > 0 and self.y <= tile_y then
                                self.y = tile_y - self.h
                                self.vel_y = 0
                        end
                        return true
                end
        end

        --[[
                checks if the sprite is colliding on the ceiling
                changes velocity
        ]]
        function self.checkCeilingCollision(self)
                if self.world:getTile(self.x + 1, self.y).solid or self.world:getTile(self.x + self.w - 1, self.y).solid then
			if self.vel_y < 0 then
                                self.vel_y = 0
                                return true
			end
		end
        end

        function self.checkWallCollision(self)
                if 	self.vel_x > 0 then
			if self.world:getTile(self.x + self.w, self.y + self.h/2).solid then
				local tile_x, tile_y = self.world:getTileCoordinates(self.x + self.w, self.y + self.h/2)
				self.vel_x = 0
                                self.x = tile_x - self.w
                                return true
			end
		elseif self.vel_x < 0 then
			if self.world:getTile(self.x-1, self.y + self.h/2).solid then
				local tile_x, tile_y = self.world:getTileCoordinates(self.x-1, self.y + self.h/2)
				self.vel_x = 0
                                self.x = tile_x + TILE_WIDTH
                                return true
			end
		end
        end

        function self.jump(self, jumpForce)
                self.vel_y = -jumpForce or -700
        end

        function self.breakJump(self, breakPoint)
                if self.vel_y < -breakPoint then
                        self.vel_y = -breakPoint
                end
        end

        function self.moveRight(self, dt, speed, turnRate)
                local turnRate = turnRate or 3
                if self.vel_x >= -0.5 then
                        self.vel_x = self.vel_x + speed*dt
                        self.vel_x = math.min(self.vel_x, self.vel_x_max)
                else
                        --self.vel_x = self.vel_x /(self.groundDrag ^ (1/dt))
                        self.vel_x = self.vel_x + turnRate*speed*dt
                        self.vel_x = math.min(self.vel_x, self.vel_x_max)
                end
        end

        function self.moveLeft(self, dt, speed, turnRate)
                local turnRate = turnRate or 3
                if self.vel_x <= 0.5 then
                        self.vel_x = self.vel_x - speed*dt
                        self.vel_x = math.max(self.vel_x, -self.vel_x_max)
                else
                        --self.vel_x = self.vel_x /(self.groundDrag ^ (1/dt))
                        self.vel_x = self.vel_x - turnRate*speed*dt
                        self.vel_x = math.max(self.vel_x, -self.vel_x_max)
                end
        end

        function self.decelerate(self, dt, speed, groundDrag, airDrag)
                local threshold = 5
                if self:onGround() then
                        if self.vel_x > threshold or self.vel_x < -threshold then
                                local sign = self.vel_x/math.abs(self.vel_x)
                                self.vel_x = self.vel_x - sign * speed * groundDrag * dt
                        else
                                self.vel_x = 0
                        end
                else
                        if self.vel_x > threshold or self.vel_x < -threshold then
                                local sign = self.vel_x/math.abs(self.vel_x)
                                self.vel_x = self.vel_x - sign * speed * airDrag * dt
                        else
                                self.vel_x = 0
                        end
                end
        end


        --[[
                f :: (self, obj)
        ]]
        function self.foreachSprite(self, f)
                for x = -1, 1, 1 do
			for y = -1, 1, 1 do
				local xPos = self.x + x * (TILE_WIDTH * TILES_PER_CHUNK_WIDTH)
				local yPos = self.y + y * (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT)
				local currentChunk = self.world:getChunk(xPos, yPos)
				
				for i, obj in ipairs(currentChunk.sprites) do
					f(self, obj)
				end
			end
		end
		for i, obj in ipairs(self.world.sprites) do
			f(self, obj)
		end
        end
        

        


        return self
end