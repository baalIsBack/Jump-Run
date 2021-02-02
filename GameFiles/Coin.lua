function Coin(x, y)
        local self = Sprite()
        self.type = "Coin"
        self.world = nil

        self.sound_pickup = love.audio.newSource("sfx/coin.wav", "static")
        self.sound_pickup:setVolume(0.2)

        self.life = 1

        self.destroyFunction = function(self)
                self.world:addSprite(Coin_destroy_animation(self.x, self.y))
                self.destroy = true
                love.audio.play(self.sound_pickup)
        end

        self.x = x
        self.y = y
        self.w = 16
        self.h = 16

        local theta = math.random(0, 200) / 100
        self.vel_x = math.cos(theta * math.pi) * 500
        self.vel_y = math.sin(theta * math.pi) * 500

        self.animation = Animation(love.graphics.newImage("gfx/metroidvania/miscellaneous_sprites/coin_anim_strip_6.png"), Quadtable(16, 16, 6), 12)

        function self.update(self, dt)
                self:applyVelocity(dt)
                self:applyGravity(dt)
                self:checkGroundCollision(dt)
                self:checkWallCollision(dt)

                self:decelerate(dt, 500, 3, 1)
                self.animation:update(dt)
        end

        function self.draw(self)
                love.graphics.push()
                love.graphics.translate(self.x, self.y)
                love.graphics.scale(1/2, 1/2)
                self.animation:draw()
                love.graphics.pop()
        end

        return self
end

function Coin_destroy_animation(x, y)
        local self = Sprite()

        self.x = x
        self.y = y
        self.w = 1
        self.h = 1

        self.destroyFunction = function(self)
                self.destroy = true
        end

        self.animation = Animation(love.graphics.newImage("gfx/metroidvania/miscellaneous_sprites/coin_pickup_anim_strip_6.png"), Quadtable(8, 32, 6), 24)
        self.animation.once = true

        function self.update(self, dt)
                self.animation:update(dt)
                self.destroy = self.animation.destroy
        end

        function self.draw(self)
                love.graphics.push()
                love.graphics.translate(self.x, self.y - 16)
                love.graphics.scale(1/2, 1/2)
                self.animation:draw()
                love.graphics.pop()
        end

        return self
end