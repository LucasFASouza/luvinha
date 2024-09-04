extends Area2D

var game_manager: Node = null
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var velocity = Vector2(0, 100)
var rotation_direction = sign(randf() - 0.5)

func _ready() -> void:
	animated_sprite_2d.play(str(randi() % 4))

func set_game_manager(manager: Node):
	game_manager = manager

func _process(delta):
	position += velocity * delta
	self.rotation_degrees += rotation_direction
	
	if (position.y > 60):
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	game_manager.remove_life()
	animation_player.play("pickup")
