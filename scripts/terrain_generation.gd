extends Node2D

# Terrain generation settings
const WORLD_WIDTH = 200   # Width of the world in tiles
const WORLD_HEIGHT = 100  # Height of the world in tiles
const TERRAIN_HEIGHT = 50 # The base height of the terrain
const SCALE = 10.0        # Noise scale for terrain variation
const DIRT_LAYER = 5      # Depth of dirt above stone
const ORE_FREQUENCY = 0.1 # Ore spawn frequency

# Reference to the TileMap node
@export var tilemap: TileMapLayer
# FastNoiseLite for terrain generation
@export var noise := FastNoiseLite.new()

# Tile IDs in TileMap (assuming you've set them in the TileSet)
const TILE_AIR = -1
const TILE_GRASS = 1
const TILE_DIRT = 2

# Source IDs in the TileSetScenesCollectionSource (set these based on your TileSet)
const SOURCE_ID = 0

func _ready():
	generate_terrain()

# Function to generate the terrain
func generate_terrain():
	for x in range(WORLD_WIDTH):
		# Create terrain height based on noise
		var height = TERRAIN_HEIGHT + int(noise.get_noise_2d(x / SCALE, 0) * 10)  # Create terrain height
		
		for y in range(WORLD_HEIGHT):
			if y == height:
				tilemap.set_cell(Vector2i(x, y), SOURCE_ID, Vector2i(0, 0), TILE_GRASS)  # Top layer is grass
			elif y > height and y > height - DIRT_LAYER:
				tilemap.set_cell(Vector2i(x, y), SOURCE_ID, Vector2i(0, 0), TILE_DIRT)  # Place dirt below grass
			else:
				tilemap.set_cell(Vector2i(x, y), TILE_AIR)  # Air above ground
