extends CPUParticles3D

const LIFETIME : float = 6

func _ready():
	await get_tree().create_timer(LIFETIME).timeout
	kill()

func kill() -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "color", Color("2d2d2d00"), 1)
	await t.finished
	queue_free()
