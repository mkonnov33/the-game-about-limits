extends Area2D

@export var direction := Vector2.ZERO

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D) -> void:
	print("going in " + str(direction))
	Global.game_controller.change_2D_grid_scene(direction)
