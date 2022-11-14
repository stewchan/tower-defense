extends AnimatedSprite


func _ready():
	playing = true


func _on_ProjectileImpact_animation_finished():
	queue_free()
