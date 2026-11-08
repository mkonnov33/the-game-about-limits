class_name GameController extends Node

@export var world_2D: Node2D
@export var gui: Control

var current_2D_scene: Node
var current_gui_scene: Node

var scene_cache: Dictionary = {} # Store loaded scenes by path

var preloaded_scenes: Dictionary = {}
var player: CharacterBody2D

@export var scene_grid: Dictionary = {}
var current_coordinate: Vector2 = Vector2(100, 100)
var value_to_find: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_controller = self
	
	# Filling preloaded scenes
	for child: Node2D in world_2D.get_children():
		if child.name != "Player" and child.name != "Camera2D":
			current_2D_scene = child
		preloaded_scenes[child.name] = child
	player = preloaded_scenes["Player"]
	
	value_to_find = [current_2D_scene.scene_file_path.get_file().get_basename(), current_2D_scene.scene_file_path]
	
	current_coordinate = scene_grid.find_key(value_to_find)
	
	if current_gui_scene and current_gui_scene.scene_file_path:
		scene_cache[current_gui_scene.scene_file_path] = current_gui_scene
	if current_2D_scene and current_2D_scene.scene_file_path:
		scene_cache[current_2D_scene.scene_file_path] = current_2D_scene

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			var scene_path := current_gui_scene.scene_file_path
			current_gui_scene.queue_free() # Removes node entirely
			scene_cache.erase(scene_path)
		elif keep_running:
			current_gui_scene.visible = false # Keeps in memory and runnings
		else:
			gui.remove_child(current_gui_scene) # Keeps in memory, does not run
	
	var new_node: Node
	if scene_cache.has(new_scene):
		new_node = scene_cache[new_scene]
		if new_node.get_parent() == null:
			gui.add_child(new_node)
		new_node.visible = true
	else:
		new_node = load(new_scene).instantiate()
		scene_cache[new_scene] = new_node
		gui.add_child(new_node)
	
	current_gui_scene = new_node

func change_2D_scene(new_scene: String, delete: bool = true, keep_running: bool = false, direction_to_move: Vector2 = Vector2.UP) -> void:
	world_2D.remove_child(player)
	if current_2D_scene != null:
		if delete:
			var scene_path := current_2D_scene.scene_file_path
			current_2D_scene.queue_free() # Removes node entirely
			scene_cache.erase(scene_path)
		elif keep_running:
			current_2D_scene.visible = false # Keeps in memory and runnings
		else:
			world_2D.remove_child(current_2D_scene) # Keeps in memory, does not run
	
	var new_node: Node
	if scene_cache.has(new_scene):
		new_node = scene_cache[new_scene]
		if new_node.get_parent() == null:
			world_2D.add_child(new_node)
		new_node.visible = true
	else:
		new_node = load(new_scene).instantiate()
		scene_cache[new_scene] = new_node
		world_2D.call_deferred("add_child", new_node)
		
	player.position.y = -player.position.y + (16*sign(player.position.y))
	#player.collision_layer = 2
	world_2D.call_deferred("add_child", player)
	player.update_sprite_position()
	print("Moving in " + str(direction_to_move))
	#player.call_deferred("move", direction_to_move)
	#player.set_deferred("collision_layer", 1)
	
	if scene_grid.find_key(new_node.scene_file_path):
		current_coordinate = scene_grid.find_key(new_node.scene_file_path)
	current_2D_scene = new_node

func change_2D_grid_scene(direction: Vector2, delete: bool = true, keep_running: bool = false) -> void:
	current_coordinate += direction
	if scene_grid.has(current_coordinate):
		change_2D_scene(scene_grid[current_coordinate][1], delete, keep_running, direction)
	else:
		current_coordinate -= direction
		var format_string = "Scene in direction %v doesn't exist"
		print(format_string % direction)
