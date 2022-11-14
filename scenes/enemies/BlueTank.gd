extends PathFollow2D


var speed = 150
var hp = 500

onready var health_bar = $HealthBar
onready var impact_area = $ImpactArea

var projectile_impact = preload("res://scenes/support/ProjectileImpact.tscn")


func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.set_as_toplevel(true)


func _physics_process(delta):
	move(delta)


func move(delta):
	set_offset(get_offset() + speed * delta)
	health_bar.set_position(position + Vector2(-25, -30))
	

func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		self_destruct()


func impact():
	randomize()
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var new_impact = projectile_impact.instance()
	new_impact.position = impact_location
	impact_area.add_child(new_impact)


func self_destruct():
	$KinematicBody2D.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
