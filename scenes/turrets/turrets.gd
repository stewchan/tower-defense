extends Node2D


var enemy_array = []
var built = false


func _ready():
	if built:
		var radius = 0.5 * GameData.tower_data[get_name()]["range"]
		$Range/CollisionShape2D.get_shape().radius = radius


func _physics_process(_delta):
	turn()


func turn():
	var enemy_position = get_global_mouse_position()
	$Turret.look_at(enemy_position)


func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent()) # Replace with function body.
	print(enemy_array)

func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
	
