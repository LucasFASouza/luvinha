extends Node2D

var timer: Timer = null
@onready var msg: Label = $Msg

func _ready():
	timer = Timer.new()
	timer.wait_time = 6
	timer.one_shot = true
	add_child(timer)
	
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))


func show_message(lives):
	timer.stop()
	
	if lives == 3:
		msg.text = "O procedimento você não leu, e a luva errada você usou!"
	elif lives == 2:
		msg.text = "O risco você não percebeu, e um acidente aconteceu!"

	self.visible = true
	timer.start()


func _on_timer_timeout():
	self.visible = false
