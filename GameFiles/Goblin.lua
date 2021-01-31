function Goblin(x, y)
        local self = Sprite()
        self.type = "Goblin"
        self.world = nil

        self.sound_death = love.audio.newSource("sfx/goblin_death.wav", "static")
        self.sound_death:setVolume(0.2)

        self.destroyFunction = function(self)
                self.destroy = true
                love.audio.play(self.sound_death)
                self.world:addSprite(Goblin_destroy_animation(self.x, self.y))
                for i = 1, math.random(0, 3), 1 do
                        self.world:addSprite(Coin(self.x, self.y))
                end
        end

        self.direction = nil
        
        self.x = x
        self.y = y
	self.w = 20
        self.h = 26

        self.team = 2

        self.damage = 1
        
        self.life = 1

        self.vel_x = math.random(0, 1) * 100
        if self.vel_x == 0 then
                self.vel_x = -100
        end
        self.vel_y = 0

        self.animation = Animation(love.graphics.newImage("gfx/metroidvania/enemies sprites/goblin/goblin_run_anim_strip_6.png"), Quadtable(16, 16, 6), 12)

        function self.update(self, dt)
                self:applyVelocity(dt)
                self:applyGravity(dt)
                self:checkGroundCollision(dt)
                if self.vel_x > 0 then
                        self.direction = "right"
                else
                        self.direction = "left"
                end
                local vel_x_buf = self.vel_x
                if self:checkWallCollision(dt) then
                        if self.direction == "right" then
                                self.direction = "left"
                                self.vel_x = -vel_x_buf
                        else
                                self.direction = "right"
                                self.vel_x = -vel_x_buf
                        end
                end

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
                love.graphics.translate(self.x - (IMG_TILE_WIDTH - self.w)/2 + flipImageOffset, self.y - (IMG_TILE_HEIGHT - self.h))
                love.graphics.scale(flipImage, 1)
                self.animation:draw()
                love.graphics.pop()
                if DEBUG then love.graphics.rectangle("line", self.x, self.y, self.w, self.h) end
        end

        return self
end

function Goblin_destroy_animation(x, y)
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