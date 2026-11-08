extends Node

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	print_debug(current_scene)

func switch_scene(sceneToLoad : PackedScene):
	if sceneToLoad != null:
		call_deferred("_deffered_switch_scene", sceneToLoad)
	else:
		print_debug("The sceneToLoad is somehow null")

func _deffered_switch_scene(sceneToLoad : PackedScene):
	current_scene.free()
	current_scene = sceneToLoad.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
