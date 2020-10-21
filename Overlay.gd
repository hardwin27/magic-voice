extends Control

onready var _scene_tree = get_tree()

var _can_pause = true


func _ready():
	_can_pause = true
	_scene_tree.paused = false
	visible = false
	get_node("Pause").visible = false
	get_node("Pause2").visible = false
	get_node("GameOver").visible = false
	get_node("YourScore").visible = false
	get_node("Score").visible = false
	get_node("Reload").visible = false


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if _can_pause:
			if _scene_tree.paused == false:
				_scene_tree.paused = true
				visible = true
				get_node("Pause").visible = true
				get_node("Pause2").visible = true
			else:
				_scene_tree.paused = false
				get_node("Pause").visible = false
				get_node("Pause2").visible = false
				visible = false
	
	if event.is_action_pressed("reload"):
		_scene_tree.reload_current_scene()


func player_end(score):
	_can_pause = false
	_scene_tree.paused = true
	visible = true
	get_node("GameOver").visible = true
	get_node("YourScore").visible = true
	get_node("Score").visible = true
	get_node("Reload").visible = true
	get_node("Score").text = str(score)
