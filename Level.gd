extends Node2D

onready var _spawners = [$Spawner, $Spawner2, $Spawner3, $Spawner4, $Spawner5]
onready var _score_label = $UI/Score 

var _score = 0
var _rng = RandomNumberGenerator.new()
var _alphabet = ['A', 'I', 'U', 'E', 'O']
var _already_spawned = [false, false, false, false, false]
var _spawned_enemy = []
var _spawned_here = [null, null, null, null, null]
var _enemy_path = "res://Object/Enemy.tscn"
var _enemy_speed = 100
var _time_pass = 0
var _spawn_interval = 3
var _spawn_limit_increase_interval = 30
var _spawn_interval_decrease_interval = 20
var _enemy_speed_increase_interaval = 10
var _spawn_limit = 1


func _ready():
	_rng.randomize()


func _unhandled_key_input(event):
	var key_pressed = OS.get_scancode_string(
		event.get_scancode_with_modifiers()
	)
	for enemy in _spawned_enemy:
		if enemy.get_command_label() == key_pressed:
			enemy.shouted(25)


func _on_SpawnTimer_timeout():
	_time_pass += 1
	if _time_pass % _spawn_interval == 0:
		for n in range(0, _spawn_limit):
			spawn()
	if _time_pass % _spawn_interval_decrease_interval == 0:
		if _spawn_interval > 1:
			_spawn_interval -= 1
	if _time_pass % _enemy_speed_increase_interaval == 0:
		if _enemy_speed < 200:
			_enemy_speed += 50
	if _time_pass % _spawn_limit_increase_interval == 0:
		if _spawn_limit < 3 :
			_spawn_limit += 1


func _on_Hitbox_body_entered(body):
# 	enemy_death(body.get_command_label())
	var alphabet = body.get_command_label()
	var removed_index = 0
	var empty_spawner_index = null
	for enemy in _spawned_enemy:
		if enemy.get_command_label() == alphabet:
			empty_spawner_index = _spawned_here.find(enemy)
			_spawned_enemy.remove(removed_index)
			_spawned_here[empty_spawner_index] = null
			_already_spawned[_alphabet.find(alphabet)] = false
			enemy.queue_free()
		removed_index += 1


func spawn():
	var enemy = null
	var spawner_choice = null
	var alphabet_choice = null
	if _spawned_here.find(null) != -1:
		while true:
			spawner_choice = _rng.randi_range(0, 4)
			if _spawned_here[spawner_choice] == null:
				enemy = load(_enemy_path).instance()
				add_child(enemy)
				enemy.set_global_position(
					_spawners[spawner_choice].get_global_position()
				)
				enemy.set_speed(_enemy_speed)
				while true:
					alphabet_choice = _rng.randi_range(0, 4)
					if _already_spawned[alphabet_choice]:
						continue
					else:
						enemy.set_command_label(_alphabet[alphabet_choice])
						_spawned_enemy.append(enemy)
						_already_spawned[alphabet_choice] = true
						break
				_spawned_here[spawner_choice] = enemy
				break
			else:
				continue


func spawn_on_everywhere():
	var enemy = null
	var choice = null
	var index = 0
	for spawner in _spawners:
		enemy = load(_enemy_path).instance()
		add_child(enemy)
		enemy.set_global_position(spawner.get_global_position())
		while true:
			choice = _rng.randi_range(0, 4)
			if _already_spawned[choice]:
				continue
			else:
				enemy.set_command_label(_alphabet[choice])
				_spawned_enemy.append(enemy)
				_already_spawned[choice] = true
				break
		_spawned_here[index] = enemy
		index += 1


func enemy_death(alphabet):
	var removed_index = 0
	var empty_spawner_index = null
	for enemy in _spawned_enemy:
		if enemy.get_command_label() == alphabet:
			empty_spawner_index = _spawned_here.find(enemy)
			_spawned_enemy.remove(removed_index)
			_spawned_here[empty_spawner_index] = null
			_already_spawned[_alphabet.find(alphabet)] = false
			enemy.queue_free()
			_score += 1
			_score_label.text = str(_score)
		removed_index += 1
