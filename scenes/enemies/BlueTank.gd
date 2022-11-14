extends PathFollow2D


var speed = 150
var hp = 50

onready var health_bar = $HealthBar


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
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		self_destruct()


func self_destruct():
	queue_free()
