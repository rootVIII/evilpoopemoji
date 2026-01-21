extends CharacterBody3D

const SPEED = 5.5
var values : Array[String] = ["xx", "xxxxx", "x", "xxx"]

func bubble_sort() -> void:
	var is_sorted: bool = false
	while not is_sorted:
		is_sorted = true
		for index in range(1, len(values)):
			if values[index - 1] > values[index]:
				var tmp : String = values[index - 1]
				values[index - 1] = values[index]
				values[index] = tmp
				is_sorted = false

func sum_int(digit : int) -> int:
	var total : int = 0
	while digit > 0:
		total += digit % 10
		digit = floor(digit / 10)
	return total

func get_values() -> Array[String]:
	return values

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	var res1 : Array[String] = get_values()
	print(res1)
	bubble_sort()
	res1 = get_values()
	print(res1)
	var res2 = sum_int(1234)
	print(res2)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.5
		$Camera3D.rotation_degrees.x -= event.relative.y * 0.2
		$Camera3D.rotation_degrees.x = clamp(
			$Camera3D.rotation_degrees.x, -80, 80
		)
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	var input_direction_2d = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	var input_direction_3d = Vector3(
		input_direction_2d.x, 0.0, input_direction_2d.y
	)
	var direction = transform.basis * input_direction_3d
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	velocity.y -= 20 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10.0
	elif Input.is_action_just_released("jump") and velocity.y > 0:
		velocity.y = 0
	move_and_slide()
