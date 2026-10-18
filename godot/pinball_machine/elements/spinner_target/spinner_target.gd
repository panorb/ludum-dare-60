extends Element

@onready var spinner := $Spinner

var _accumulated_angle: float
var _angle: float

func _ready() -> void:
	_angle = global_rotation

func _physics_process(delta: float) -> void:
	var current_angle: float = spinner.global_rotation

	# Handle crossing the -PI / +PI boundary.
	var angle_change: float = wrapf(
		current_angle - _angle,
		-PI,
		PI
	)
	_angle = current_angle

	_accumulated_angle += angle_change

	while _accumulated_angle >= TAU:
		_accumulated_angle -= TAU
		# todo score

	while _accumulated_angle <= -TAU:
		_accumulated_angle += TAU
		# todo score
