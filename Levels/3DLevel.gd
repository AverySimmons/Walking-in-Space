extends Node3D

const PLANET_NUM : int = 40
const INNER_SPAWN_RADIUS : float = 500
const OUTER_SPAWN_RADIUS : float = 1000
const MIN_VELOCITY : float = 50
const MAX_VELOCITY : float = 100
const MIN_SIZE : float = 2
const MAX_SIZE : float = 30
const BASE_MASS : float = 300
const PLANET_MIN_SPACING : float = 100
const PLAYER_GRAV_WAIT : float = 1
const EXPLOSION_DISTANCE : float = 2000

@onready var planets = $Planets
@onready var player = $"Player Controller"
@onready var origin = $SpawnOrigin
@onready var trails = $Trails
@onready var floors = $Floor
@onready var env = $WorldEnvironment
@onready var music = $AudioStreamPlayer

@onready var planet_scene = preload("res://Entities/planet.tscn")
@onready var trail_scene = preload("res://Helper/trail.tscn")
@onready var floor_scene = preload("res://Helper/floor_segment.tscn")
@onready var explosion_scene = preload("res://Entities/explosion.tscn")

var rng = RandomNumberGenerator.new()
var player_gravity : bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawnFloors()
	manageEvents()

func _physics_process(_delta):
	planetPhysics()
	if player_gravity: setPlayerDown()
	checkToggleMouse()

func spawnFloors() -> void:
	var offset : float = 88
	for i in range(5):
		var forward_floor = floor_scene.instantiate()
		floors.add_child(forward_floor)
		forward_floor.global_position = origin.global_position + Vector3.FORWARD * offset
		offset += 60

func manageEvents() -> void:
	await get_tree().create_timer(10).timeout
	music.playing = true
	var t = create_tween()
	t.tween_property(music, "volume_db", -5, 39)
	await t.finished
	triggerPlanets()
	await get_tree().create_timer(16).timeout
	spawnExplosion()

func triggerPlanets() -> void:
	for i in range(PLANET_NUM):
		spawnPlanet()
	var t = create_tween()
	t.tween_property(player, "global_position", player.global_position + Vector3.UP * 7, PLAYER_GRAV_WAIT)
	t.tween_property($Stars, "mesh:material:albedo_color:a", 1, PLAYER_GRAV_WAIT)
	await t.finished
	player_gravity = true
	for f in floors.get_children():
		f.disableWalls()
	$ExtraWall.collision_layer = 0

func spawnPlanet() -> void:
	var distance
	var spawn_dir
	var clear = false
	while not clear:
		spawn_dir = randomDirection()
		spawn_dir.y += 0.5
		spawn_dir = spawn_dir.normalized()
		distance = rng.randf_range(INNER_SPAWN_RADIUS, OUTER_SPAWN_RADIUS)
		clear = true
		var loc = player.global_position + distance * spawn_dir
		for planet in planets.get_children():
			if loc.distance_to(planet.global_position) < PLANET_MIN_SPACING: clear = false
	var speed = rng.randf_range(MIN_VELOCITY, MAX_VELOCITY)
	var vel_dir = randomDirection()
	vel_dir -= spawn_dir.dot(vel_dir) / spawn_dir.length_squared() * spawn_dir
	var size = rng.randf_range(MIN_SIZE, MAX_SIZE)
	var color = Color(randf_range(0.5, 1.5), randf_range(0.5, 1.5), randf_range(0.5, 1.5))
	var new_planet = planet_scene.instantiate()
	new_planet.starting_velocity = vel_dir * speed
	new_planet.scale = Vector3(size, size, size)
	new_planet.mass = size * BASE_MASS
	new_planet.setColor(color)
	planets.add_child(new_planet)
	new_planet.global_position = player.global_position + spawn_dir * distance
	

func planetPhysics() -> void:
	for planet in planets.get_children():
		for target in planet.get_node("GravityArea").get_overlapping_bodies():
			if planet == target: continue
			planet.vel += calculatePlanetForce(planet, target)

func setPlayerDown() -> void:
	var new_down = Vector3.ZERO
	for planet in planets.get_children():
		new_down += calculatePlanetForce(player, planet)
	player.setDownDirection(new_down)

func checkToggleMouse() -> void:
	if Input.is_action_just_pressed("debug"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func calculatePlanetForce(start, target) -> Vector3:
	return start.position.direction_to(target.position) * target.mass / start.position.distance_squared_to(target.position)

func randomDirection() -> Vector3:
	rng = RandomNumberGenerator.new()
	return Vector3(rng.randf() - 0.5, rng.randf() - 0.5, rng.randf() - 0.5).normalized()

func spawnTrail(pos : Vector3, bas : Basis) -> void:
	var new_trail = trail_scene.instantiate()
	trails.add_child(new_trail)
	new_trail.global_position = pos
	new_trail.transform.basis = bas

func spawnExplosion() -> void:
	var expl = explosion_scene.instantiate()
	add_child(expl)
	expl.global_position = player.global_position + -player.basis.z * EXPLOSION_DISTANCE
