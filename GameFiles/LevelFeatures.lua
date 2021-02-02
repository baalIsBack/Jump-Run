--x = 0 and y = 0 :: left most block of ground

function LevelFeature_Shrine(world, x, y)
        world:setTile(x+TILE_HEIGHT*0, y+TILE_HEIGHT*-2, Tile(true, 32))
        world:setTile(x+TILE_HEIGHT*1, y+TILE_HEIGHT*-2, Tile(true, 33))
        world:setTile(x+TILE_HEIGHT*2, y+TILE_HEIGHT*-2, Tile(true, 34))
        world:setTile(x+TILE_HEIGHT*0, y+TILE_HEIGHT*-1, Tile(true, 64))
        world:setTile(x+TILE_HEIGHT*1, y+TILE_HEIGHT*-1, Tile(true, 65))
        world:setTile(x+TILE_HEIGHT*2, y+TILE_HEIGHT*-1, Tile(true, 66))

        world:addSprite(Pickup_MagicBolt(x+TILE_WIDTH*1, y+TILE_HEIGHT*-3))
end