extends Node

var spawn_timer: Timer
const GLOVE = preload("res://scenes/glove.tscn")
const ENEMY = preload("res://scenes/enemy.tscn")
var enemy_count: int = 0

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
const MAX_SECONDS: int = 60
@onready var time_label: Label = %Time


func _ready():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)
	_start_spawn_timer()
	

func _process(delta: float) -> void:
	if lives > 0:
		level_timer += delta
		seconds_left = MAX_SECONDS - level_timer
		print(seconds_left)

		time_label.text = str(seconds_left)

		if seconds_left <= 10:
			time_label.set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))

		if seconds_left <= 0:
			print("ACABOU")
			spawn_timer.stop()
			player.queue_free()
			game_over.finish_game(score)
			lives = 0


func _on_spawn_timer_timeout():
	if lives > 0:
		var random_x = randf_range(-72, 72)
		
		var instance: Node2D
		if enemy_count < 4:
			instance = ENEMY.instantiate()
			enemy_count += 1
		else:
			instance = GLOVE.instantiate()
			enemy_count = 0
		
		instance.set_game_manager(self)	
		instance.position = Vector2(random_x, -100)
		instance.rotation_degrees = randf_range(-45, 45) 
			
		add_child(instance)
		_start_spawn_timer()


func _start_spawn_timer():
	if lives > 0:
		var time_fraction = float(seconds_left) / MAX_SECONDS
		var min_interval = 0.2
		var max_interval = 1.5
		var base_interval = lerp(min_interval, max_interval, time_fraction)
		
		var random_variation = randf_range(-0.1, 0.2)
		var interval = base_interval + random_variation
		
		interval = clamp(interval, min_interval, max_interval)
		
		spawn_timer.wait_time = interval
		spawn_timer.start()


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
