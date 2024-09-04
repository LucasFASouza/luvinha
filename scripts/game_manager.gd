extends Node

var spawn_timer: Timer
const GLOVE = preload("res://scenes/glove.tscn")
const ENEMY = preload("res://scenes/enemy.tscn")

@onready var ballon: Node2D = %Ballon
@onready var player: CharacterBody2D = %Player
@onready var game_over: Control = $"../GameOver"

var score = 0
@onready var score_label: Label = $Score

var lives = 3
@onready var lives_label: Label = $Lives

var level_timer: float = 0
var seconds: int = 0
var seconds_left: int = 0
const MAX_SECONDS: int = 30
@onready var time_label: Label = %Time

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)
	spawn_timer.start()
	

func _process(delta: float) -> void:
	if lives > 0:
		level_timer += delta
		seconds = fmod(level_timer, 60)
		seconds_left = MAX_SECONDS - seconds

		time_label.text = str(seconds_left)

		if seconds_left <= 10:
			time_label.set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))

			if seconds_left == 0:
				spawn_timer.stop()
				player.queue_free()
				game_over.finish_game(score)
				lives = 0


func _on_spawn_timer_timeout():
	if lives > 0:
		var random_x = randf_range(-72, 72)
		
		var instance: Node2D
		if randi() % 5 < 4:
			instance = ENEMY.instantiate()
		else:
			instance = GLOVE.instantiate()
		
		instance.set_game_manager(self)	
		instance.position = Vector2(random_x, -100)
		instance.rotation_degrees = randf_range(-45, 45) 
			
		add_child(instance)


func add_or_subtract_points(amount):
	if lives > 0:
		score += amount
		score_label.text = str(score)


func remove_life():
	if lives > 0:
		player.get_hit()
		lives -= 1
		lives_label.text = str(lives)
		
		if lives > 0:
			ballon.show_message(lives)	
		else:
			game_over.finish_game(-1)
			player.queue_free()
