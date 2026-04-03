extends Interactable

@export var color_name: String = "blue" 
@export var block_color: Color = Color.BLUE

var prompt_message: String = "Press [E] to pick up block"
@onready var mesh = $MeshInstance3D

func _ready():
	var mat = StandardMaterial3D.new()
	mat.albedo_color = block_color
	mesh.material_override = mat

func interact():
	var player = get_tree().get_first_node_in_group("Player")
	if player and player.has_method("pick_up_block"):
		player.pick_up_block(color_name, block_color)
		queue_free()
