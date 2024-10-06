extends Node2D

# Terrain generation settings
const WORLD_WIDTH = 200   # Width of the world in tiles
const WORLD_HEIGHT = 100  # Height of the world in tiles
const TERRAIN_HEIGHT = 50 # The base height of the terrain
const SCALE = 10.0        # Noise scale for terrain variation
const DIRT_LAYER = 5      # Depth of dirt above stone
const ORE_FREQUENCY = 0.1 # Ore spawn frequency
const CHUNK_SIZE = 16
const TILE_SIZE = 16  # Assuming each tile is 16x16 pixels
@export var chunk_load_radius = 2  # Number of chunks to load around the player
@export var seed: int
@export var player: CharacterBody2D
@export var new_chunk_load = false

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
	generate_seed()
	if new_chunk_load:
		var player_position = player.position  # Replace with actual player position
		generate_terrain_around_player(player_position)
	else:
		generate_terrain()
	
func _process(delta: float):
	if(new_chunk_load):
		var player_position = player.position  # Replace with actual player position
		generate_terrain_around_player(player_position)

# Function to generate the terrain
func generate_terrain():
	noise.seed = seed
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
				
# Function to generate a single chunk of terrain
func generate_chunk(chunk_pos: Vector2i):
	var start_x = chunk_pos.x * CHUNK_SIZE
	var start_y = chunk_pos.y * CHUNK_SIZE
	
	for x in range(start_x, start_x + CHUNK_SIZE):
		var height = TERRAIN_HEIGHT + int(noise.get_noise_2d(x / SCALE, 0) * 10)
		for y in range(start_y, start_y + CHUNK_SIZE):
			if y == height:
				tilemap.set_cell(Vector2i(x, y), SOURCE_ID, Vector2i(0, 0), TILE_GRASS)
			elif y > height and y > height - DIRT_LAYER:
				tilemap.set_cell(Vector2i(x, y), SOURCE_ID, Vector2i(0, 0), TILE_DIRT)
			else:
				tilemap.set_cell(Vector2i(x, y), TILE_AIR)

# Function to generate terrain around player
func generate_terrain_around_player(player_position: Vector2):
	var player_chunk_x = int(player_position.x / (CHUNK_SIZE * TILE_SIZE))
	var player_chunk_y = int(player_position.y / (CHUNK_SIZE * TILE_SIZE))

	for chunk_x in range(player_chunk_x - chunk_load_radius, player_chunk_x + chunk_load_radius + 1):
		for chunk_y in range(player_chunk_y - chunk_load_radius, player_chunk_y + chunk_load_radius + 1):
			generate_chunk(Vector2i(chunk_x, chunk_y))

func generate_seed():
	seed = randi()
