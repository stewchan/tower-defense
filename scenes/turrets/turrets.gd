extends Node2D

var type
var enemy_array = []
var built = false
var enemy
var ready := true
var category

onready var animation_player = $AnimationPlayer

func _ready():
	if built:
		var radius = 0.5 * GameData.tower_data[type]["range"]
		$Range/CollisionShape2D.get_shape().radius = radius


func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		if not animation_player.is_playing():
			turn()
		if ready:
			fire()
	else:
		enemy = null


func turn():
	$Turret.look_at(enemy.position)


func fire():
	ready = false
	if category == "Projectile":
		fire_gun()
	elif category == "Missile":
		fire_missile()
	enemy.on_hit(GameData.tower_data[type]["damage"])
	yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout")
	ready = true


func fire_gun():
	$AnimationPlayer.play("Fire")

func fire_missile():
	pass


func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]


func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent()) # Replace with function body.
	print(enemy_array)

func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
	
