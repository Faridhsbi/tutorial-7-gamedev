extends Node3D

@export var sceneName: String = "Level"

@onready var door_closed = $doorway
@onready var door_open = $doorwayOpen
@onready var wall_collider = $doorway/StaticBody3D/CollisionShape3D
@onready var magic_particles: GPUParticles3D = $GPUParticles3D 
@onready var portal_mesh: MeshInstance3D = $doorwayOpen/ExitZone/PortalMesh
@onready var locked_label: Label = get_tree().get_first_node_in_group("Player").get_node("HUD/LockedLabel")

var is_open: bool = false

func _ready():
	door_closed.visible = true
	door_open.visible = false

	if wall_collider:
		wall_collider.set_deferred("disabled", false)
	
	if magic_particles:
		magic_particles.emitting = false
		
	if portal_mesh:
		portal_mesh.visible = false

func open_door():
	if not is_open:
		is_open = true
		
		door_closed.visible = false
		door_open.visible = true
		
		if wall_collider:
			wall_collider.set_deferred("disabled", true)
			
		if magic_particles:
			magic_particles.emitting = true
		if portal_mesh:
			portal_mesh.visible = true
			
		print("Door Opened!")
		
func show_locked_message():
	locked_label.text = "LOCKED"
	await get_tree().create_timer(2.0).timeout
	locked_label.text = ""
	
func interact():
	var player = get_tree().get_first_node_in_group("Player")
	
	if player.coins_collected >= player.max_coins:
		open_door()
	else:
		show_locked_message()

func _on_exit_zone_body_entered(body):
	if is_open and body.is_in_group("Player"):
		print("Pemain masuk zona!")
		
		if sceneName != "":
			var next_level_path = "res://scenes/" + sceneName + ".tscn"
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("PERINGATAN: sceneName belum di-isi di Inspector!")
