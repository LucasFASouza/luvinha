extends CharacterBody2D

const SPEED = 130.0
var stunned = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var timer: Timer = null

func _ready():
	timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	add_child(timer)
	
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))


func _physics_process(_delta: float) -> void:
	if !stunned:
		var direction := Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()


func get_hit():
	if (!stunned):
		animated_sprite.play("hit")
		stunned = true
		timer.start() 


func _on_timer_timeout():
	animated_sprite.play("idle")
	stunned = false
