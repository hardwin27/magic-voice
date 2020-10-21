extends KinematicBody2D

onready var _command_label = $Command
onready var _sprite = $Sprite
onready var _explosion = $Explosion
onready var _anim_player = $AnimationPlayer


var _drop_speed = Vector2(0, 100)
var _health = 100


func _physics_process(delta):
	_drop_speed = move_and_slide(_drop_speed, Vector2.UP)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Explode":
		queue_free()


func set_command_label(alphabet):
	_command_label.text = alphabet


func get_command_label():
	return _command_label.text


func set_speed(speed):
	_drop_speed.y = speed


func shouted(damage):
	_health -= damage
	if _health <= 0:
		get_parent().enemy_death(get_command_label())
		_drop_speed = Vector2(0, 0)
		_anim_player.play("Explode")
