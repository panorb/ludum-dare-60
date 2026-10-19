class_name AIController
extends Node2D

const MIN_PLUNGER_CHARGE_TIME: float = 0.5;
const MAX_PLUNGER_CHARGE_TIME: float = 1.6;

const DEFAULT_EXCITEMENT: float = 5.0;
const DEFAULT_TOTAL_EXCITEMENT: float = 0.0;

signal excitement_change(excitement: int)
signal total_excitement_change(excitement: int)

@onready var right_flipper_trigger := $RightFlipperTrigger
@onready var left_flipper_trigger := $LeftFlipperTrigger
@onready var plunger_trigger := $PlungerTrigger
@onready var playfield = %PinballMachine
@onready var between_game_timer := $BetweenGameTimer
@onready var sim_day := $SimDayTimer

@export var active := false

var _excitement : float = DEFAULT_EXCITEMENT :
	get:
		return _excitement;
	set(excitement):
		_excitement = excitement
		self.excitement_change.emit(self._excitement)

var _total_excitement : float = DEFAULT_TOTAL_EXCITEMENT :
	get:
		return _total_excitement;
	set(total_excitement):
		_total_excitement = total_excitement;
		self.total_excitement_change.emit(self._total_excitement)

const _excitement_half_life := 20 # how many seconds it takes for excitement to half
const _repetition_half_life := 50 # how many seconds it takes for repeated excites to restore by half
const _repetition_strength := 1.0 # how bad reperition is, multiplier

func _ready() -> void:
	right_flipper_trigger.body_entered.connect(_flipper_right_press)
	right_flipper_trigger.body_exited.connect(_flipper_right_release)
	left_flipper_trigger.body_entered.connect(_flipper_left_press)
	left_flipper_trigger.body_exited.connect(_flipper_left_release)
	plunger_trigger.body_entered.connect(_flipper_charge_press)
#	plunger_trigger.body_exited.connect(_flipper_charge_release)
	playfield.excitement.connect(_exciting_event)
	playfield.game_over.connect(_on_game_over)
	between_game_timer.timeout.connect(_on_restart)

# Integer is score value of PinballMachinePart
var exposure:Dictionary[int, float]

func _exciting_event(value) -> void:
	var familiarity = exposure.get(value, 0.0)
	var impact = value/(1+_repetition_strength*familiarity)
	_excitement += impact
	_total_excitement += impact
	exposure[value] = exposure.get(value, 0.0) + 1.0

func _on_game_over(score, is_highscore) -> void:
	if is_highscore:
		_exciting_event(score)
	between_game_timer.wait_time = 0.1
	between_game_timer.start()

func _on_restart():
	between_game_timer.stop()
	if not active:
		playfield.reset()
		return
	playfield.start()

var total := 0.0 # TODO remove this, it is just for printing every 2 seconds

func _process(delta: float) -> void:
	if active:
		_excitement *= 2**(-delta/_excitement_half_life)
		var memory_decay = 2**(-delta/_repetition_half_life)
		for category in exposure:
			exposure[category] *= memory_decay
		#print(_excitement)
		total += delta # TODO remove this, it is just for printing every 2 seconds
		if total > 2.0:
			total -= 2.0
			print(_excitement, " ", _total_excitement)

func start() -> void:
	playfield.start()
	# TODO display something about people playing the game over the day. Maybe have a clock that speeds through the day?

func stop() -> void:
	active = false

func reset(excitement: float = DEFAULT_EXCITEMENT, total_excitement: float = DEFAULT_TOTAL_EXCITEMENT) -> void:
	self._excitement = excitement;
	self._total_excitement = total_excitement;

func _flipper_right_press(body) -> void:
		if not active:
			return
		playfield.flip_right_press()
		_exciting_event(0.5)

func _flipper_right_release(body) -> void:
		if not active:
			return
		playfield.flip_right_release()

func _flipper_left_press(body) -> void:
		if not active:
			return
		playfield.flip_left_press()
		_exciting_event(0.5)

func _flipper_left_release(body) -> void:
		if not active:
			return
		playfield.flip_left_release()

func _flipper_charge_press(body) -> void:
	if self.active:
		# Calculate timer for plunger to release by random time
		var plunger_charge_time := randf_range(MIN_PLUNGER_CHARGE_TIME, MAX_PLUNGER_CHARGE_TIME);
		# Get Timer wirh random plunge time
		self.get_tree().create_timer(plunger_charge_time) \
			# After change time is over release plunger
			.timeout.connect(func(): playfield.plunger_release());
		# Charge plunger
		playfield.plunger_charge()

		print("Charge plunger with: " + str(plunger_charge_time) + "s" )
