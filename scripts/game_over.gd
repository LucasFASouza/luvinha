extends Control

@onready var final_message: Label = $Mensagem
@onready var title: Label = $"Titulo"


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func finish_game(score: int) -> void:
	self.visible = true
	if score > 0:
		title.text = "Parabéns!"
		final_message.text = "Você leu os procedimentos e se protegeu corretamente.\n\n Você conseguiu pegar " + str(score) + " luvas!"
	else:
		title.text = "Game Over"
		final_message.text = "No jogo outras chances você pode ter, mas na vida real isso não vai acontecer!\n\nLeia os procedimentos, utilize as luvas e proteja suas mãos."
