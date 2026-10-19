class_name Editor
extends Control

const DURATION_OF_DAY: float = 10.0;
const COIN_FACTOR := 50

@onready var pinball_machine : PinballMachine = %PinballMachine;
@onready var ai_controller : AIController = %AIController;
@onready var shop := %Shop
@onready var placer: Placer = %Placer
@onready var intermission: Intermission = %Intermission;

var today : StoryDay

var todays_excitement := 0.0
var yesterdays_excitement := 20.0

var current_balance := 0:
	set(value):
		current_balance = value
		if is_node_ready():
			shop.update_available_balance(value)
var last_purchase : ShopEntry = null
@export var story_days : Array[StoryDay]

func _ready() -> void:
	shop.start_day.connect(_on_start_day)
	shop.item_pressed.connect(_on_shop_item_pressed)
	pinball_machine.score_changed.connect(_on_score_changed)
	ai_controller.excitement_change.connect(_on_excitement_change)
	ai_controller.total_excitement_change.connect(_on_total_excitement_change)
	placer.placement_finished.connect(_on_placement_finished)
	placer.placement_cancelled.connect(_on_placement_cancelled)
	placer.part_sold.connect(_on_part_sold)
	%Intermission.finished.connect(_on_intermission_finished)
	%PinballMachine.game_over.connect(_on_game_over)
	current_balance = current_balance
	
	_begin_new_day()

func _begin_new_day():
	today = story_days.pop_front()
	intermission.start(today.intro_text)

func _on_intermission_finished():
	%Shop.add_to_inventory(today.shop_restock)
	%DayInfo.title = today.title.to_upper()
	current_balance = current_balance
	
	# Replace shop with info display
	%DayInfo.visible = false;
	%Shop.visible = true;
	
	# Activate user input disable AI
	%AIController.active = false;
	%PlayableMachine.active = true;
	%PinballMachine.lenient = true;

	# Reset pinballmachine
	%PinballMachine.reset();
	_reset_placed_parts()

	# Activate highscrore
	%PinballMachine.is_highscore_active = false;

	# Run engine normal
	Engine.time_scale = 1.0

	# ??
	%AIController.stop();

func _on_game_over(score, is_highscore) -> void:
	_reset_placed_parts()

func _on_start_day():
	todays_excitement = 0.0
	# Replace shop with info display
	%Shop.visible = false;
	%DayInfo.visible = true;
	
	# Reset pinballmachine
	%PinballMachine.reset();
	_reset_placed_parts()
	
	# Activate highscrore
	%PinballMachine.is_highscore_active = true;
	
	# Run engine Faster	
	Engine.time_scale = 1.5

	# Reset AI (excitement)
	%AIController.reset();

	# Activate AI disable user_input
	%AIController.active = true;
	%PlayableMachine.active = false;
	%PinballMachine.lenient = false;

	# ??
	%AIController.start();
	
	# Calculate coins
	var today_excitement = ai_controller._total_excitement;
	
	# Start day timer
	## Create timer with duration of day
	self.get_tree().create_timer(DURATION_OF_DAY) \
		## call end day method
		.timeout.connect(_on_end_day)

func _reset_placed_parts():
	for child in %PlacedParts.get_children():
		if child.has_method("reset"):
			child.reset()

func _on_end_day():
	# Activate user input disable AI
	yesterdays_excitement = todays_excitement
	current_balance += int(yesterdays_excitement*COIN_FACTOR)
	todays_excitement = 0.0
	%AIController.active = false;
	%PlayableMachine.active = true;

	# Reset pinballmachine
	%PinballMachine.reset();
	_reset_placed_parts()

	# Activate highscrore
	%PinballMachine.is_highscore_active = false;

	# Run engine normal
	Engine.time_scale = 1.0

	# ??
	%AIController.stop();
	
	# After some seconds show next day
	self.get_tree().create_timer(2.0) \
		.timeout.connect(func():self._begin_new_day());

func _on_shop_item_pressed(entry: ShopEntry) -> void:
	if placer.is_placing() or current_balance < entry.price:
		return
	
	%Shop.remove_from_inventory(entry)
	shop.interactable = false
	current_balance -= entry.price
	last_purchase = entry
	placer.start(entry)

func _on_placement_finished(_placed: Node2D) -> void:
	shop.interactable = true

func _refund_stock(entry: ShopEntry):
	var stock = ShopEntryQuantity.new()
	stock.entry = entry
	stock.quantity = 1
	var array : Array[ShopEntryQuantity] = [stock]
	%Shop.add_to_inventory(array)

func _on_placement_cancelled() -> void:
	_refund_stock(last_purchase)
	
	current_balance += last_purchase.price  # refund
	shop.interactable = true

func _on_part_sold(entry: ShopEntry) -> void:
	_refund_stock(entry)
	
	current_balance += int(entry.price / 2.0)

func _on_score_changed(score: int):
	%ScoreValue.text = str(min(score, 99999999)).pad_zeros(8)
	
func _on_excitement_change(excitement: float):
	pass

func _on_total_excitement_change(excitement: float):
	todays_excitement = excitement
