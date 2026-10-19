class_name Editor
extends Control

const DURATION_OF_DAY: float = 10.0;

@onready var shop := %Shop
@onready var placer: Placer = %Placer

var current_balance := preload("res://shop/entries/saucer.tres").price + 800:
	set(value):
		current_balance = value
		if is_node_ready():
			shop.update_available_balance(value)
var last_purchase : ShopEntry = null

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
	
	%Shop.remove_from_inventory(entry)
	shop.interactable = false
	current_balance -= entry.price
	last_purchase = entry
	placer.start(entry)

func _on_placement_finished(_placed: Node2D) -> void:
	shop.interactable = true

func _refund_stock(entry: ShopEntry):
	var stock = ShopEntryQuantity.new()
	stock.entry = last_purchase
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
