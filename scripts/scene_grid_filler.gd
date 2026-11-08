@tool
extends EditorScript

const FOLDER_PATH := "res://scenes/grid/"
var game_controller_path := "res://scenes/game_controller.tscn"

func _run() -> void:
	var packed_scene = load(game_controller_path)
	if not packed_scene:
		print("Failed to load game controller scene!")
		return
		
	var game_controller = packed_scene.instantiate()
	var updated_grid = game_controller.scene_grid.duplicate(true) if game_controller.scene_grid else {}
	
	var dir = DirAccess.open(FOLDER_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				file_name = dir.get_next()
				continue
				
			if file_name.ends_with(".tscn"):
				var full_path = FOLDER_PATH + file_name
				var scene = load(full_path)
				
				if scene:
					var instance = scene.instantiate()
					if instance and "coordinates" in instance:
						var coords = instance.coordinates
						
						var name = file_name.get_basename()
						
						updated_grid[coords] = [name, full_path]
						
						print("Mapped: ", coords, " -> ", name)
					instance.queue_free()
					
			file_name = dir.get_next()
			
	game_controller.scene_grid = updated_grid
	packed_scene.pack(game_controller)
	ResourceSaver.save(packed_scene, game_controller_path)
	game_controller.queue_free()
	
	EditorInterface.reload_scene_from_path(game_controller_path)
	print("Success! Scene grid updated with clean names.")
