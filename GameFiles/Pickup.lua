function Pickup(x, y)
        local self = Sprite()
        self.type = "Pickup"

        self.destroyFunction = function(self)
                self.destroy = true
        end

        
        self.x = x
        self.y = y
	self.w = 32
        self.h = 32

        self.damage = 0
        
        self.life = 1

        self.vel_x = 0
        self.vel_y = 0

        self.quad = nil
        --self.quad = love.graphics.newQuad(4 * 32, 3 * 32, 32, 32, 224, 384)

        function self.update(self, dt)
               
        end

        function self.draw(self)
                love.graphics.push()
                love.graphics.translate(self.x - (IMG_TILE_WIDTH - self.w)/2 + 0, self.y - (IMG_TILE_HEIGHT - self.h))
                love.graphics.draw(ITEM_ICONSET, self.quad)
                love.graphics.pop()
                if DEBUG then love.graphics.rectangle("line", self.x, self.y, self.w, self.h) end
        end

        self.pickup = nil

        return self
end