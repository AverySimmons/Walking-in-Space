extends CharacterBody3D

const WALK_SPEED : float = 4
const SPACE_WALK_SPEED : float = 8

const MOUSE_SENSE : float = 0.01
const CAMERA_BOT_CLAMP : float = deg_to_rad(-80)
const CAMERA_TOP_CLAMP : float = deg_to_rad(80)
const TRAIL_SPACING : float = 2

@onready var cam = $Camera3D

@onready var last_trail_point : Vector3 = global_position

var trail_timer : float = 0
var grav_tween : Tween
var player_grav_adjusted : bool = false

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouseLook(event.relative.x, event.relative.y)

func _physics_process(delta):
	keyboardMovement(delta)
	move_and_slide()

func _process(_delta):
	if get_parent().player_gravity: checkSpawnTrail()

func mouseLook(inX : float, inY : float) -> void:
	updateCamera(inX * MOUSE_SENSE, inY * MOUSE_SENSE)

func updateCamera(x : float, y : float) -> void:
	rotate_object_local(Vector3.UP, -x)
	cam.rotation.x -= y
	cam.rotation.x = clamp(cam.rotation.x, CAMERA_BOT_CLAMP, CAMERA_TOP_CLAMP)

func keyboardMovement(_delta) -> void:
	var input = Input.get_vector("left", "right", "forward", "backward")
	var in_vect = Vector3(input.x, 0, input.y).normalized()
	in_vect = basis * in_vect
	velocity = in_vect * (SPACE_WALK_SPEED if get_parent().player_gravity else WALK_SPEED)

func setDownDirection(vect : Vector3) -> void:
	var new_basis = basis
	new_basis.y = - vect.normalized()
	new_basis.x -= (new_basis.y.dot(basis.x) / new_basis.y.length_squared()) * new_basis.y
	new_basis.x = new_basis.x.normalized()
	new_basis.z -= (new_basis.y.dot(basis.z) / new_basis.y.length_squared()) * new_basis.y
	new_basis.z -= (new_basis.x.dot(new_basis.z) / new_basis.x.length_squared()) * new_basis.x
	new_basis.z = new_basis.z.normalized()
	if grav_tween:
		grav_tween.kill()
	grav_tween = create_tween()
	grav_tween.tween_property(self, "basis", new_basis, basis.y.distance_to(new_basis.y) / 2)
	#basis = new_basis

func checkSpawnTrail() -> void:
	var bot_pos = global_position +  basis * Vector3.DOWN * ($CollisionShape3D.shape.height / 2)
	if bot_pos.distance_to(last_trail_point) > TRAIL_SPACING:
		get_parent().spawnTrail(bot_pos, basis)
		last_trail_point = bot_pos
