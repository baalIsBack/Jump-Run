function TilePicker(world, camera)
        local self = {}

        self.open = false
        self.world = world

        self.key_open_pressed = false
        self.currentSelection = 0
        self.mouse_pressed = false

        function self.draw(self)
                if self.open then
                        love.graphics.reset()
                        love.graphics.clear()
                        love.graphics.draw(TILEMAP)
                else
                        print(self.currentSelection)
                        love.graphics.draw(TILEMAP, QUADS[self.currentSelection%1024], camera:getMousePosition())
                end
        end

        function self.update(self, dt)
                if love.keyboard.isDown("f1") then
                        if not self.key_open_pressed then
                                self.open = not self.open
                        end
                        self.key_open_pressed = true
                else
                        self.key_open_pressed = false
                end

                if self.open then
                        if love.mouse.isDown(1) then
                                local x = math.floor(love.mouse.getX() / TILE_WIDTH)
                                local y = math.floor(love.mouse.getY() / TILE_HEIGHT)
                                self.currentSelection = (x + (y * 32)) % 1000
                                if not self.mouse_pressed then
                                        self.open = false
                                end
                                self.mouse_pressed = true
                        else
                                self.mouse_pressed = false
                        end
                else
                        local mx, my = camera:getMousePosition()
                        if love.mouse.isDown(1) then
                                if not self.mouse_pressed then
                                        self.world:setTile(mx, my, Tile(true, self.currentSelection))
                                end
                        else
                                self.mouse_pressed = false
                        end
                        if love.mouse.isDown(2) then
                                self.world:setTile(mx, my, Tile(false, self.currentSelection))
                        end
                end
        end

        return self
end