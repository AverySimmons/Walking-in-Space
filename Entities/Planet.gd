extends CharacterBody3D

@export var mass : float = 5
@export var starting_velocity : Vector3 = Vector3.ZERO

@onready var vel = starting_velocity

func _ready():
	var t = create_tween()
	t.tween_property($CollisionShape3D/MeshInstance3D, "mesh:material:emission_energy_multiplier", 0.4, 0.2)
	flicker()

func _physics_process(_delta):
	velocity = vel
	move_and_slide()
	var col = get_last_slide_collision()
	if col:
		vel = col.get_normal() * vel.length()

func setColor(color : Color) -> void:
	$CollisionShape3D/MeshInstance3D.mesh.material.albedo_color = color
	$CollisionShape3D/MeshInstance3D.mesh.material.emission = color

func flicker() -> void:
	for i in range(8):
		await get_tree().create_timer(0.02).timeout
		visible = false
		await get_tree().create_timer(0.02).timeout
		visible = true
