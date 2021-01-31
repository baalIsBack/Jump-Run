function Projectile_MagicBolt(owner)
	local self = Sprite()
    self.type = "Projectile_MagicBolt"
    self.world = nil
    self.life = 1

    self.damage = 2

    self.team = owner.team

    self.sound = love.audio.newSource("sfx/projectile_sword.wav", "static")
    self.sound:setVolume(0.2)
    love.audio.play(self.sound)

    self.destroyFunction = function(self)
            self.destroy = true
            --self.world:addSprite(Projectile_MagicBolt_destroy_animation(self.x, self.y))
    end

    self.owner = owner

    
    
    self.w = 32
    self.h = 16

    
    self.speed = 800


    self.direction = owner.direction
    
    local flip = 1
    local flipOffset = 0
    if self.direction == "left" then
            flip = -1
            flipOffset = self.w/2
    end
    self.x = owner.x - flipOffset + flip * self.w/2
    self.y = owner.y + (owner.h - self.h)/2

    self.vel_x = flip * self.speed
    self.vel_y = 0



    self.hitList = {}

    self.animation = Animation(love.graphics.newImage("gfx/Attack_Magic.png"), Quadtable(170, 110, 1), 100)

    --self:updatePosition()

    function self.update(self, dt)
            self:applyVelocity(dt)
            
            self.life = self.life - dt
            self:foreachSprite(self.checkCollision)
            self.animation:update(dt)
    end

    function self.draw(self)
            local flipImage = 1
            local flipImageOffset = 0
            if self.direction == "left" then
                    flipImage = -1
                    flipImageOffset = 32
            end
            love.graphics.push()
            love.graphics.translate(self.x - (IMG_TILE_WIDTH - self.w)/2 + flipImageOffset + flipImage * -4, self.y - (IMG_TILE_HEIGHT - self.h) - (110/8 - self.h)*4)--
            love.graphics.scale(flipImage / 8, 1 / 8)
            self.animation:draw()
            love.graphics.pop()
            if DEBUG then love.graphics.rectangle("line", self.x, self.y, self.w, self.h) end
    end

    function self.checkCollision(self, obj)
		if CheckCollision(self.x, self.y, self.w, self.h, obj.x, obj.y, obj.w, obj.h) then
			if obj.team and obj.team ~= self.team then
                self:destroyFunction()
                obj.life = obj.life - self.damage

			end
		end
	end

    return self
end



function Projectile_MagicBolt_destroy_animation(x, y)
    local self = Sprite()

    self.x = x
    self.y = y
    self.w = 1
    self.h = 1

    self.destroyFunction = function(self)
            self.destroy = true
    end

    self.animation = Animation(love.graphics.newImage("gfx/metroidvania/miscellaneous_sprites/explosion_anim_strip_10.png"), Quadtable(32, 32, 10), 24)
    self.animation.once = true

    function self.update(self, dt)
            self.animation:update(dt)
            self.destroy = self.animation.destroy
    end

    function self.draw(self)
            love.graphics.push()
            love.graphics.translate(self.x, self.y - 8)
            love.graphics.scale(1/2, 1/2)
            self.animation:draw()
            love.graphics.pop()
    end

    return self
end