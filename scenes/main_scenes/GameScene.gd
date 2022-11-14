extends Node2D

onready var map_node = $Map1

var build_mode := false
var build_valid := false
var build_location: Vector2
var build_type: String
var build_tile

var current_wave := 0
var enemies_in_wave := 0


func _ready():
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	

func _process(_delta):
	if build_mode:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode:
		cancel_build_mode()
	elif event.is_action_released("ui_accept") and build_mode:
		verify_and_build()


"""""""""""""""
Wave Functions
"""""""""""""""

func start_next_wave():
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2), "timeout")
	spawn_enemies(wave_data)

func retrieve_wave_data() -> Array:
	var wave_data = [["BlueTank", 0.7], ["BlueTank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data: Array):
	for i in wave_data:
		var new_enemy = load("res://scenes/enemies/" + i[0] + ".tscn").instance()
		map_node.get_node("Path").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]), "timeout")


"""""""""""""""
Build Functions
"""""""""""""""

func verify_and_build():
	if build_valid:
		# TODO: Test to verify that player has enough cash
		var new_tower = load("res://scenes/turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)
		cancel_build_mode()

		# TODO: Deduct cash from player
		# TODO: update cash label


func cancel_build_mode():
	build_mode = false
	build_valid = false
	$UI/TowerPreview.free()


func initiate_build_mode(tower_type: String):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1"
	$UI.set_tower_preview(build_type, get_global_mouse_position())
	build_mode = true


func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var tower_exclusion = map_node.get_node("TowerExclusion")
	var current_tile = tower_exclusion.world_to_map(mouse_position)
	var tile_position = tower_exclusion.map_to_world(current_tile)

	if tower_exclusion.get_cellv(current_tile) == -1:
		$UI.update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		$UI.update_tower_preview(tile_position, "adff4545")
		build_valid = false
