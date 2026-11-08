extends CharacterBody2D

const tile_size := Vector2(16, 16)

@export var tween_speed := 0.185

@onready var sprite = $Sprite2D

var sprite_node_position_tween : Tween

#func _enter_tree() -> void:
	#if (sprite != null):
		#sprite.position = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if !sprite_node_position_tween or !sprite_node_position_tween.is_running():
		if Input.is_action_pressed("move_up") and !$Up.is_colliding():
			move(Vector2.UP)
		elif Input.is_action_pressed("move_down") and !$Down.is_colliding():
			move(Vector2.DOWN)
		elif Input.is_action_pressed("move_right") and !$Right.is_colliding():
			move(Vector2.RIGHT)
		elif Input.is_action_pressed("move_left") and !$Left.is_colliding():
			move(Vector2.LEFT)
	
func move(direction: Vector2):
	global_position += direction * tile_size
	sprite.global_position -= direction * tile_size
	
	if sprite_node_position_tween:
		sprite_node_position_tween.kill()
	_tween_sprite_position()

func update_sprite_position():
	if sprite_node_position_tween and sprite_node_position_tween.is_running():
		sprite_node_position_tween.kill()
	call_deferred("_tween_sprite_position")
	#sprite.set_deferred("position", Vector2.ZERO)

func _tween_sprite_position(_tween_speed = tween_speed):
	sprite_node_position_tween = create_tween()
	sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_position_tween.tween_property(sprite, "global_position", global_position, _tween_speed).set_trans(Tween.TRANS_SINE)

#func set_raycast_masks(mask: int):
	#$Up.collision_mask = mask
	#$Down.collision_mask = mask
	#$Right.collision_mask = mask
	#$Left.collision_mask = mask
