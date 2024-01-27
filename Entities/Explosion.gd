extends MeshInstance3D

const GROW_ACC = 0.5

var grow = 0

func _ready():
	await get_tree().create_timer(4).timeout
	$ExplosionSound.playing = true

func _process(delta):
	grow += GROW_ACC * delta
	scale += Vector3.ONE * grow

func _on_area_3d_body_entered(_body):
	await get_tree().create_timer(1.3).timeout
	get_tree().quit()
