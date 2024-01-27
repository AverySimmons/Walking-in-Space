extends Node3D

func disableWalls() -> void:
	$Walls.collision_layer = 0
