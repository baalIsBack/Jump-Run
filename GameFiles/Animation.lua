function Animation(img, quadTable, animationSpeed)
        local self = {}

        self.img = img
        self.img:setFilter("nearest", "nearest")
        self.quadTable = quadTable
        self.currentQuad = self.quadTable[1]
        self.animationSpeed = animationSpeed
        self.animationCounter = 0

        self.once = false
        self.destroy = nil

        function self.draw(self)
                love.graphics.draw(self.img, self.currentQuad, 0, 0, 0, 2, 2)
        end

        function self.update(self, dt)
                self.animationCounter = self.animationCounter + dt
                self.currentQuad = self.quadTable[math.floor((self.animationCounter * self.animationSpeed)%(#self.quadTable)) + 1]
                if math.floor((self.animationCounter * self.animationSpeed) / (#self.quadTable)) >= 1 and self.once then
                        self.currentQuad = self.quadTable[#self.quadTable]
                        self.destroy = true
                end
        end

        return self
end

function Quadtable(tileW, tileH, numberOfAnimations)
        local self = {}
        
        for i = 1, numberOfAnimations, 1 do
                self[i] = love.graphics.newQuad(tileW*(i-1), 0, tileW, tileH, tileW*numberOfAnimations, tileH)
        end
        
        return self
end