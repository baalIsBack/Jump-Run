

require 'World'
require 'Player'
require 'Player_draw'
require 'Coin'
require 'Animation'
require 'BoundingBox'
require 'Sprite'
require 'Goblin'
require 'Projectile_Sword'

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

IMG_TILE_WIDTH = 32
IMG_TILE_HEIGHT = 32

GLOBAL_COUNTER = 0


Levels = {}
for i = 1, 2, 1 do
	Levels[i] = require ('Levels/' .. i)
end

DEBUG = false
function love.keypressed(key, scancode, isrepeat)
	local mx, my = camera:getMousePosition()
	if key == "g" and not isrepeat then
		local goblin = Goblin(mx, my)
		world:addSprite(goblin)
	end
end



function love.load()
	love.graphics.setDefaultFilter( "nearest", "nearest")

	TILEMAP = love.graphics.newImage("gfx/Tilemap.png")
	PLAYER_IDLE = love.graphics.newImage("gfx/metroidvania/herochar_sprites(new)/herochar_idle_anim_strip_4.png")
	PLAYER_RUN = love.graphics.newImage("gfx/metroidvania/herochar_sprites(new)/herochar_run_anim_strip_6.png")
	PLAYER_JUMP_UP = love.graphics.newImage("gfx/metroidvania/herochar_sprites(new)/herochar_jump_up_anim_strip_3.png")
	PLAYER_JUMP_DOWN = love.graphics.newImage("gfx/metroidvania/herochar_sprites(new)/herochar_jump_down_anim_strip_3.png")
	PLAYER_ATTACK = love.graphics.newImage("gfx/metroidvania/herochar_sprites(new)/herochar_attack_anim_strip_4(new).png")
	PLAYER_DAMAGE = love.graphics.newImage("gfx/metroidvania/herochar_sprites(new)/herochar_hit_anim_strip_3.png")







	QUADS = {}
	local QUADSIZE = 32
	for x = 0, 255, 1 do
		QUADS[x] = love.graphics.newQuad((x % QUADSIZE) *QUADSIZE, math.floor(x/QUADSIZE) *QUADSIZE, QUADSIZE, QUADSIZE, 512, 512)
	end
	
	world = World()
	player = Player(world, 100, 100)
	camera = Camera(world, player)
	print(player.x, camera.x)

	

	file = love.filesystem.newFile("level.lua")
	currentSelection = 1
end

function bool2String(bool)
	if bool then
		return "true"
	else
		return "false"
	end
end

function love.update(dt)
	GLOBAL_COUNTER = GLOBAL_COUNTER + dt

	if dt <= 0.1 then
		camera:update(dt)
	end
	--print(currentSelection)

	local mx, my = camera:getMousePosition()
	if love.mouse.isDown(1) then
		print(mx, my, 1)
		world:setTile(mx, my, Tile(true, currentSelection))
	end
	if love.mouse.isDown(2) then
		world:setTile(mx, my, Tile(false, currentSelection))
	end
	if love.keyboard.isDown("c") then
		local c = Coin(mx, my)
		world:addSprite(c)
	end
	if love.keyboard.isDown("f2") then
		local DEBUG_tmp = DEBUG
		DEBUG = true
		local data = "local function Level() \nlocal self = {}\n"
		local tile, chunk
		chunk = world:getChunk(player.x, player.y)
		print(player.x, player.y)
		for x = 0, TILES_PER_CHUNK_WIDTH -1, 1 do
			data = data .. "self[" .. x .. "] = {}\n"
			for y = 0, TILES_PER_CHUNK_HEIGHT -1, 1 do
				tile = chunk:getTile(x * TILE_WIDTH, y * TILE_HEIGHT)
				if x == 0 and y == 0 then
					print((tile.solid), bool2String(tile.solid))
				end
				data = data .. "self[" .. x .. "]" .. "[" .. y .. "] = {solid = " .. bool2String(tile.solid) .. ", gfx_id = " .. tile.gfx_id .. "} \n"
			end
		end
		data = data .. "return self\n"
		data = data .. "end\nreturn Level"
		love.filesystem.write( "level.lua", data)
		DEBUG = DEBUG_TMP
	end
end

function love.wheelmoved(x, y)
	if 	y > 0 then--up
		currentSelection = (currentSelection - 1) % 256
	elseif 	y < 0 then--down
		currentSelection = (currentSelection + 1) % 256
	end
end

function love.draw()
	love.graphics.setDefaultFilter( "nearest" )
	camera:draw()
	--love.graphics.draw(TILEMAP, QUADS[0], 100, 010)

	love.graphics.draw(TILEMAP, QUADS[currentSelection], camera:getMousePosition())

	--love.graphics.setBackgroundColor(135/255, 206/255, 235/255)
end