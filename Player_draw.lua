function Player_draw(player)
        local self = {}
        self.object = player
        
        self.animation_idle = Animation(PLAYER_IDLE, Quadtable(16, 16, 4), 10)
        self.animation_run = Animation(PLAYER_RUN, Quadtable(16, 16, 6), 10)
        self.animation_jump_up = Animation(PLAYER_JUMP_UP, Quadtable(16, 16, 3), 10)
        self.animation_jump_down = Animation(PLAYER_JUMP_DOWN, Quadtable(16, 16, 3), 10)
        self.animation_attack = Animation(PLAYER_ATTACK, Quadtable(16, 16, 4), 16)
        --[[
                POSSIBLE STATES:
                idle
                run
                jump_up
                jump_down
                attack
        ]]
        self.state = "idle"

        function self.draw(self)
                local flipImage = 1
                local flipImageOffset = 0
                if self.object.direction == "left" then
                        flipImage = -1
                        flipImageOffset = 32
                end

                love.graphics.push()
                love.graphics.translate(self.object.x - (IMG_TILE_WIDTH - self.object.w)/2 + flipImageOffset, self.object.y - (IMG_TILE_HEIGHT - self.object.h))
                love.graphics.scale(flipImage, 1)
                if self.state == "idle" then
                        self.animation_idle:draw()
                elseif self.state == "run" then
                        self.animation_run:draw()
                elseif self.state == "jump_up" then
                        self.animation_jump_up:draw()
                elseif self.state == "jump_down" then
                        self.animation_jump_down:draw()
                elseif self.state == "attack" then
                        self.animation_attack:draw()
                end
                love.graphics.pop()
                if DEBUG then love.graphics.rectangle("line", self.object.x, self.object.y, self.object.w, self.object.h) end

                --love.graphics.draw(self.currentImage, self.currentQuad, self.object.x - (IMG_TILE_WIDTH - self.object.w)/2 + flipImageOffset, self.object.y - (IMG_TILE_HEIGHT - self.object.h), 0, 2 * flipImage, 2)
        end
        function self.update(self, dt)
                if self.object.attack_counter < 0 then
                        self.animation_attack.animationCounter = 0
                        if self.object.world:getTile(self.object.x + 1, self.object.y + self.object.h).solid or self.object.world:getTile(self.object.x + self.object.w - 1, self.object.y + self.object.h).solid then
                                if 	self.object.vel_x > 0 then
                                        self.state = "run"
                                elseif self.object.vel_x < 0 then
                                        self.state = "run"
                                else
                                        self.state = "idle"
                                end
                        else
                                if self.object.vel_y < 0 then
                                        self.state = "jump_up"
                                else
                                        self.state = "jump_down"
                                end
                        end
                else
                        self.state = "attack"
                end
                if self.state == "idle" then
                        self.animation_idle:update(dt)
                elseif self.state == "run" then
                        self.animation_run:update(dt)
                elseif self.state == "jump_up" then
                        self.animation_jump_up:update(dt)
                elseif self.state == "jump_down" then
                        self.animation_jump_down:update(dt)
                elseif self.state == "attack" then
                        self.animation_attack:update(dt)
                end
        end

        return self
end