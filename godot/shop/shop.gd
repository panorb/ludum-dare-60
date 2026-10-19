extends PanelContainer

signal start_day()

# editor.gd (addition)
const SHOP_ITEM := preload("res://shop/item/shop_item.tscn")

@export var shop_inventory: Array[ShopEntryQuantity] = []

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
	
	_update_shop_inventory()
	# placer.placement_cancelled.connect(_on_placement_cancelled)

func add_to_inventory(stock: Array[ShopEntryQuantity]):
	for new in stock:
		var found = false
		
		for item in shop_inventory:
			if item.entry == new.entry:
				item.quantity += new.quantity
				found = true
		
		if not found:
			shop_inventory.append(new)
	
	_update_shop_inventory()

func remove_from_inventory(to_remove: ShopEntry):
	var index_to_delete : int = -1
	
	for i in len(shop_inventory):
		var item = shop_inventory[i]
		if item.entry == to_remove:
			item.quantity -= 1
			if item.quantity <= 0:
				index_to_delete = i
	
	if index_to_delete != -1:
		shop_inventory.remove_at(index_to_delete)
	
	_update_shop_inventory()
	

func _update_shop_inventory():
	for i in len(shop_inventory):
		var entry = shop_inventory[i]
		
		var tile: ShopItem = null
		if i < items.get_child_count():
			tile = items.get_child(i)
		else:
			tile = SHOP_ITEM.instantiate()
			items.add_child(tile)  # add first, so the % nodes are ready
			tile.pressed.connect(_on_item_pressed)
		
		tile.setup(entry, i % 2 == 1)
	
	for i in range(len(shop_inventory), items.get_child_count()):
		var tile = items.get_child(i)
		tile.will_be_deleted = true
		tile.queue_free()
	


func _set_interactable(value: bool):
	for item in items.get_children():
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
	for i in len(shop_inventory):
		var stock = shop_inventory[i]
		var item = items.get_child(i)
		item.is_active = stock.entry.price <= balance

func _on_item_pressed(entry: ShopEntry):
	%SoundMoneyCash.play()
	%Marquee.celebrate_purchase()
	item_pressed.emit(entry)
