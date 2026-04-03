extends Interactable

@export var door_target_name: String = "Purple" # Nama yang muncul saat didekati
@export var required_colors: Array[String] = ["red", "blue"] # Resep warna

@onready var hint_label: Label3D = $HintLabel3D 
@onready var proximity_area: Area3D = $ProximityArea
@onready var locked_label: Label = get_tree().get_first_node_in_group("Player").get_node("HUD/LockedLabel")

var prompt_message: String = "Press [E] to open door"

func _ready():
	hint_label.visible = false
	hint_label.text = door_target_name
	
	proximity_area.body_entered.connect(_on_proximity_entered)
	proximity_area.body_exited.connect(_on_proximity_exited)

# Fungsi Sensor Jarak Dekat (Munculkan Label Warna)
func _on_proximity_entered(body):
	if body.is_in_group("Player"):
		hint_label.visible = true

func _on_proximity_exited(body):
	if body.is_in_group("Player"):
		hint_label.visible = false

func interact():
	var player = get_tree().get_first_node_in_group("Player")
	
	var player_inv = player.current_blocks.duplicate()
	var req_inv = required_colors.duplicate()
	
	player_inv.sort()
	req_inv.sort()
	
	if player_inv == req_inv:
		get_tree().change_scene_to_file("res://scenes/WinScreen.tscn") 
	else:
		show_wrong_answer()

func show_wrong_answer():
	locked_label.text = "WRONG ANSWER!"
	locked_label.modulate = Color.RED
	
	await get_tree().create_timer(1).timeout
	
	get_tree().reload_current_scene()
