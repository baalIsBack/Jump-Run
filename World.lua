TILE_WIDTH = 32
TILE_HEIGHT = 32
TILES_PER_CHUNK_WIDTH = 40
TILES_PER_CHUNK_HEIGHT = 40

function World()
	local self = {}

	self.chunks = {}
	self.sprites = {}

	function self.addSprite(self, sprite, global)
		sprite.world = self
		if global then
			table.insert(self.sprites, sprite)
		else
			self:getChunk(sprite.x, sprite.y):addSprite(sprite)
		end
	end

	function self.getTile(self, raw_x, raw_y)
		return self:getChunk(raw_x, raw_y):getTile(raw_x, raw_y)
	end

	function self.setTile(self, raw_x, raw_y, tile)
		return self:getChunk(raw_x, raw_y):setTile(raw_x, raw_y, tile)
	end

	function self.getTileCoordinates(self, raw_x, raw_y)
		return TILE_WIDTH * math.floor(raw_x / TILE_WIDTH), TILE_HEIGHT * math.floor(raw_y / TILE_HEIGHT)
	end

	function self.getChunk(self, raw_x, raw_y)
		local chunk_x = math.floor(raw_x / (TILE_WIDTH * TILES_PER_CHUNK_WIDTH))
		local chunk_y = math.floor(raw_y / (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT))
		self:createChunk(raw_x, raw_y)
		return self.chunks[chunk_x][chunk_y]
	end

	function self.createChunk(self, raw_x, raw_y)
		local chunk_x = math.floor(raw_x / (TILE_WIDTH * TILES_PER_CHUNK_WIDTH))
		local chunk_y = math.floor(raw_y / (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT))
		if not self.chunks[chunk_x] then
			self.chunks[chunk_x] = {}
		end
		if not self.chunks[chunk_x][chunk_y] then
			self.chunks[chunk_x][chunk_y] = Chunk()
		end
	end


	self:createChunk(0, 0)
	return self
end

function Chunk()
	local self = {}

	self.needsRedraw = false

	self.tiles = {}
	self.sprites = {}
	
	--DEPRECATED
	--[[
	for x = 0, TILES_PER_CHUNK_WIDTH -1, 1 do
		self.tiles[x] = {}
		for y = 0, TILES_PER_CHUNK_HEIGHT -1, 1 do
			self.tiles[x][y] = Tile(false, 0)
			if y == TILES_PER_CHUNK_HEIGHT -1 and x ~= 0 and x ~= 1 or y == TILES_PER_CHUNK_HEIGHT -2 and x == 5 or y == TILES_PER_CHUNK_HEIGHT -3 and x == 10 or x == 0 and y == 0 then
				self.tiles[x][y] = Tile(true, 3)
			end
		end
	end]]

	local randomLevelId = math.random(1, 2)

	self.tiles.id = 0
	self.tiles = Levels[randomLevelId]()
	self.tiles.id = randomLevelId
	

	self.canvas = nil

	function self.addSprite(self, sprite)
		table.insert(self.sprites, sprite)
	end

	function self.redrawCanvas(self)
		love.graphics.push()
		love.graphics.reset()
		self.canvas = love.graphics.newCanvas(TILE_WIDTH * TILES_PER_CHUNK_WIDTH, TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT)
		love.graphics.setCanvas(self.canvas)
		for x = 0, TILES_PER_CHUNK_WIDTH -1, 1 do
			for y = 0, TILES_PER_CHUNK_HEIGHT -1, 1 do
				love.graphics.draw(TILEMAP, QUADS[self.tiles[x][y].gfx_id], x * TILE_WIDTH, y * TILE_HEIGHT, 0, 1, 1)
			end
		end
		love.graphics.setCanvas()
		love.graphics.pop()
	end


	function self.getTile(self, raw_x, raw_y)
		local inChunk_x = math.floor((raw_x % (TILE_WIDTH * TILES_PER_CHUNK_WIDTH))/TILE_WIDTH)
		local inChunk_y = math.floor((raw_y % (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT))/TILE_HEIGHT)
		return self.tiles[inChunk_x][inChunk_y]
	end

	function self.setTile(self, raw_x, raw_y, tile)
		local inChunk_x = math.floor((raw_x % (TILE_WIDTH * TILES_PER_CHUNK_WIDTH))/TILE_WIDTH)
		local inChunk_y = math.floor((raw_y % (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT))/TILE_HEIGHT)
		self.tiles[inChunk_x][inChunk_y] = tile
		self.needsRedraw = true
	end

	self:redrawCanvas()
	return self
end

function Tile(solid, gfx_id)
	local self = {}

	self.solid = solid
	self.gfx_id = gfx_id

	return self
end

function Camera(world, player)
	local self = {}
	
	self.world = world
	self.player = player
	world:addSprite(player)
	self.x = player.x
	self.y = player.y

	

	self.canvas_timer = 0

	function self.draw(self)
		
		love.graphics.translate(-math.floor(self.x), -math.floor(self.y))
		love.graphics.translate(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
		--love.graphics.scale(2, 2)
		--love.graphics.rectangle("fill", 0, 0, 3200, 3200)
		
		for x = -1, 1, 1 do
			for y = -1, 1, 1 do
				local xPos = self.x + x * (TILE_WIDTH * TILES_PER_CHUNK_WIDTH)
				local yPos = self.y + y * (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT)
				local currentChunk = self.world:getChunk(xPos, yPos)
				if currentChunk.needsRedraw and self.canvas_timer > 0.3 then
					currentChunk:redrawCanvas()
					currentChunk.needsRedraw = false
					self.canvas_timer = 0
				end
				love.graphics.draw(currentChunk.canvas, (TILE_WIDTH * TILES_PER_CHUNK_WIDTH) * math.floor(xPos / (TILE_WIDTH * TILES_PER_CHUNK_WIDTH)), (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT) * math.floor(yPos / (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT)))
				
				
				local sprite
				for i = #currentChunk.sprites, 1, -1 do
					sprite = currentChunk.sprites[i]
					--if sprite.destroy then
					--	table.remove(currentChunk.sprites, i)
					--else
					--	sprite:draw()
					--end
					sprite:draw()
				end
				if DEBUG then love.graphics.rectangle("line", (TILE_WIDTH * TILES_PER_CHUNK_WIDTH) * math.floor(xPos / (TILE_WIDTH * TILES_PER_CHUNK_WIDTH)), (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT) * math.floor(yPos / (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT)), (TILE_WIDTH * TILES_PER_CHUNK_WIDTH), (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT)) end
			end
		end


		for i, sprite in ipairs(self.world.sprites) do
			sprite:draw()
		end
		--self.player:draw()
	end

	function self.update(self, dt)
		self.canvas_timer = self.canvas_timer + dt
		self.x = self.player.x
		self.y = self.player.y
		for i, sprite in ipairs(self.world.sprites) do
			sprite:update(dt)
		end
		for x = -1, 1, 1 do
			for y = -1, 1, 1 do
				local xPos = self.x + x * (TILE_WIDTH * TILES_PER_CHUNK_WIDTH)
				local yPos = self.y + y * (TILE_HEIGHT * TILES_PER_CHUNK_HEIGHT)
				local currentChunk = self.world:getChunk(xPos, yPos)
				
				local sprite
				for i = #currentChunk.sprites, 1, -1 do
					sprite = currentChunk.sprites[i]
					if sprite.life <= 0 then
						sprite:destroyFunction()
					end
					if sprite.destroy then
						table.remove(currentChunk.sprites, i)
					else
						sprite:update(dt)
						if self.world:getChunk(sprite.x, sprite.y) ~= currentChunk then
							table.remove(currentChunk.sprites, i)
							self.world:addSprite(sprite)
						end
					end
				end
			end
		end
		--self.player:update(dt)
	end

	function self.getMousePosition(self)
		local mx, my = love.mouse.getPosition()
		return mx +math.floor(self.x) - SCREEN_WIDTH/2, my +math.floor(self.y) - SCREEN_HEIGHT/2
	end

	return self
end