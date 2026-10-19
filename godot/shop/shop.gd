extends PanelContainer

signal start_day()

# editor.gd (addition)
const SHOP_ITEM := preload("res://shop/item/shop_item.tscn")

@export var shop_entries: Array[ShopEntry] = []

@onready var items: GridContainer = %Items
@onready var start_day_button : Button = %StartDayButton;

signal item_pressed(entry: ShopEntry)
var display_balance = 0:
	set(value):
		%CoinsValue.text = str(value)
		display_balance = value
var coin_display_tween : Tween = null
var interactable := true:
	set = _set_interactable

func _ready() -> void:
	# If start day button is pressed send start_day signal
	self.start_day_button.pressed.connect(func(): start_day.emit());
	
	# placer.placement_cancelled.connect(_on_placement_cancelled)
	for i in len(shop_entries):
		var entry = shop_entries[i]
		
		var tile: ShopItem = SHOP_ITEM.instantiate()
		items.add_child(tile)  # add first, so the % nodes are ready
		tile.setup(entry, i % 2 == 1)
		tile.pressed.connect(_on_item_pressed)

func _set_interactable(value: bool):
	print("woah")
	for i in len(shop_entries):
		var item = items.get_child(i)
		item.interactable = value
	interactable = value
	

func update_available_balance(balance: int):
	_update_item_purchasability(balance)
	
	if coin_display_tween:
		coin_display_tween.kill()
	coin_display_tween = get_tree().create_tween()
	
	var time_for_transition : float = abs(balance - display_balance) * 0.01
	time_for_transition = min(time_for_transition, 3.0)
	coin_display_tween.tween_property(self, "display_balance", balance, time_for_transition) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

func _update_item_purchasability(balance: int):
	for i in len(shop_entries):
		var entry = shop_entries[i]
		var item = items.get_child(i)
		item.is_active = entry.price <= balance

func _on_item_pressed(entry: ShopEntry):
	%Marquee.celebrate_purchase()
	item_pressed.emit(entry)
