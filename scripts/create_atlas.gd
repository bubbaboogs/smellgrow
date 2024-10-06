@tool
extends EditorScript

var images_directory = "res://sprites/tile_sprites/"
var atlas_path = "user://atlas.png"  # Changed to user:// to ensure it's writable
var atlas_size = Vector2(1024, 1024)
var padding = 2

func _run():
	print("Running atlas creator tool...")
	create_texture_atlas()

func create_texture_atlas():
	var dir = DirAccess.open(images_directory)
	
	if not dir:
		push_error("Failed to open directory: " + images_directory)
		return
	
	var image_paths = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".png"):  # Extend this for other image types
			image_paths.append(images_directory + file_name)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	if image_paths.size() == 0:
		push_error("No images found in directory: " + images_directory)
		return
	
	# Create an empty image for the atlas
	var atlas_image = Image.new()
	atlas_image.create(int(atlas_size.x), int(atlas_size.y), false, Image.FORMAT_RGBA8)
	atlas_image.fill(Color(0, 0, 0, 0))  # Set transparency
	print("Created atlas with size: ", atlas_image.get_size())
	
	var current_x = 0
	var current_y = 0
	var row_height = 0
	
	for image_path in image_paths:
		print("Loading image: ", image_path)
		var texture = load(image_path) as Texture2D
		
		if texture == null:
			push_error("Failed to load texture: " + image_path)
			continue
		
		var image = texture.get_image()  # Get Image from Texture2D
		
		if image == null or image.is_empty():
			push_error("Failed to get valid image data from: " + image_path)
			continue
		
		print("Blitting image: ", image_path, " at position (", current_x, ", ", current_y, ")")
		
		if current_x + image.get_width() + padding > atlas_size.x:
			current_x = 0
			current_y += row_height + padding
			row_height = 0
		
		if current_y + image.get_height() + padding > atlas_size.y:
			push_error("Atlas size too small to fit all images.")
			return
		
		# Blit image to atlas at current position
		atlas_image.blit_rect(image, Rect2(Vector2(0, 0), image.get_size()), Vector2(current_x, current_y))
		current_x += image.get_width() + padding
		row_height = max(row_height, image.get_height())
	
	print("Saving atlas to: ", atlas_path)
	
	# Save the atlas
	var success = atlas_image.save_png(atlas_path)
	if success == OK:
		print("Texture atlas saved to: " + atlas_path)
	else:
		push_error("Failed to save texture atlas.")
