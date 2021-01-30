function Projectile_Sword(source)
        local self = Sprite()
        self.type = "Projectile_Sword"
        self.world = nil
        self.life = 4/16

        self.damage = 1

        self.team = source.team

        self.sound = love.audio.newSource("sfx/projectile_sword.wav", "static")
        self.sound:setVolume(0.2)
        love.audio.play(self.sound)

        self.destroyFunction = function(self)
                self.destroy = true
        end

        self.source = source

        
        
        self.w = 32
        self.h = 16
        self.x = source.x
        self.y = source.y

        self.hitList = {}

        self.animation = Animation(love.graphics.newImage("gfx/metroidvania/herochar_sprites(new)/sword_effect_strip_4(new).png"), Quadtable(16, 16, 4), 8)

        function self.updatePosition(self)
                local flip = 1
                local flipOffset = 0
                if self.source.direction == "left" then
                        flip = -1
                        flipOffset = self.w/2
                        flipSide = -1
                end
                self.x = source.x + flip * flipOffset + flip * self.w/2
                self.y = source.y + (source.h - self.h)/2
        end
        self:updatePosition()

        function self.update(self, dt)
                self:updatePosition()
                
                self.life = self.life - dt
                self:foreachSprite(self.checkCollision)
                self.animation:update(dt)
        end

        function self.draw(self)
                local flipImage = 1
                local flipImageOffset = 0
                if self.source.direction == "left" then
                        flipImage = -1
                        flipImageOffset = 32
                end
                love.graphics.push()
                love.graphics.translate(self.x - (IMG_TILE_WIDTH - self.w)/2 + flipImageOffset + flipImage * 5, self.y - (IMG_TILE_HEIGHT - self.h) + 2)
                love.graphics.scale(flipImage, 1)
                self.animation:draw()
                love.graphics.pop()
                if DEBUG then love.graphics.rectangle("line", self.x, self.y, self.w, self.h) end
        end

        function self.checkCollision(self, obj)
		if CheckCollision(self.x, self.y, self.w, self.h, obj.x, obj.y, obj.w, obj.h) then
			if obj.team ~= self.team then
                                for i, objHit in ipairs(self.hitList) do
                                        if objHit == obj then
                                                return
                                        end
                                end
                                table.insert(self.hitList, obj)
                                obj.life = obj.life - self.damage
			end
		end
	end

        return self
end