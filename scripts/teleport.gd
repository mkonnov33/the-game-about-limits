extends Area2D

@export var pathToScene : String

func _on_body_entered(_body: Node2D) -> void:
	Global.game_controller.change_2D_scene(pathToScene)
