class_name Editor
extends Control

const DURATION_OF_DAY: float = 10;

@onready var shop := %Shop
@onready var placer: Placer = %Placer

var current_balance := preload("res://shop/entries/saucer.tres").price + 50:
	set(value):
		current_balance = value
		if is_node_ready():
			shop.update_available_balance(value)
var last_purchase_value := 0

func _ready() -> void:
	shop.start_day.connect(_on_start_day)
	shop.item_pressed.connect(_on_shop_item_pressed)
	placer.placement_finished.connect(_on_placement_finished)
	placer.placement_cancelled.connect(_on_placement_cancelled)
	placer.part_sold.connect(_on_part_sold)
	current_balance = current_balance

func _on_start_day():
	# Replace shop with info display
	%Shop.visible = false;
	%DayInfo.visible = true;
	
	# Run engine Faster	
	Engine.time_scale = 1.5

	# Reset AI (excitement)
	%AIController.reset();

	# Activate AI disable user_input
	%AIController.active = true;
	%PlayableMachine.active = false;

	# ??
	%AIController.start();
	
	# Start day timer
	## Create timer with duration of day
	self.get_tree().create_timer(DURATION_OF_DAY) \
		## call end day method
		.timeout.connect(_on_end_day)
	
func _on_end_day():
	# Replace shop with info display
	%DayInfo.visible = false;
	%Shop.visible = true;
	
	# Activate user input disable AI
	%AIController.active = false;
	%PlayableMachine.active = true;

	# Run engine normal
	Engine.time_scale = 1.0

	# ??
	%AIController.stop();

func _on_shop_item_pressed(entry: ShopEntry) -> void:
	if placer.is_placing() or current_balance < entry.price:
		return
	shop.interactable = false
	current_balance -= entry.price
	last_purchase_value = entry.price
	placer.start(entry.scene, entry.price)

func _on_placement_finished(_placed: Node2D) -> void:
	shop.interactable = true

func _on_placement_cancelled() -> void:
	current_balance += last_purchase_value  # refund
	shop.interactable = true

func _on_part_sold(refund: int) -> void:
	current_balance += refund
