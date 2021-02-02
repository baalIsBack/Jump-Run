function Pickup_MagicBolt(x, y)
        local self = Pickup(x, y)

        self.quad = love.graphics.newQuad(4 * 32, 3 * 32, 32, 32, 224, 384)

        function self.pickup(self, player)
                player.weapon = Weapon_MagicBolt(player)
        end

        return self
end