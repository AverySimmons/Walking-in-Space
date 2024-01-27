extends Node3D

@onready var flicker_sound = $CSGMesh3D3/MeshInstance3D/LightFlicker
@onready var buzz_sound = $CSGMesh3D3/MeshInstance3D/LightBuzz

func _ready():
	visible = false

func flicker() -> void:
	for i in range(6):
		await get_tree().create_timer(0.02).timeout
		visible = false
		await get_tree().create_timer(0.02).timeout
		visible = true

func _on_area_3d_body_entered(_body):
	if not visible:
		playSound()
		flicker()

func playSound() -> void:
	flicker_sound.playing = true
	await flicker_sound.finished
	buzz_sound.playing = true
