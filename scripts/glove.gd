extends Area2D

var game_manager: Node = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_picked: bool = false
var rotation_direction = sign(randf() - 0.5)
var velocity = Vector2(0, 100)

func set_game_manager(manager: Node):
	game_manager = manager
	

func _process(delta):
	if (!is_picked):
		position += velocity * delta
		self.rotation_degrees += rotation_direction
		
		if (position.y > 60):
			queue_free()


func _on_body_entered(_body: Node2D) -> void:
	game_manager.add_or_subtract_points(1)
	is_picked = true
	animation_player.play("pickup")
