extends PanelContainer

# editor.gd (addition)
const SHOP_ITEM := preload("res://shop/item/shop_item.tscn")

@export var shop_entries: Array[ShopEntry] = []

@onready var items: GridContainer = %Items

signal item_pressed(entry: ShopEntry)


func _ready() -> void:
	# placer.placement_cancelled.connect(_on_placement_cancelled)
	for i in len(shop_entries):
		var entry = shop_entries[i]
		
		var tile: ShopItem = SHOP_ITEM.instantiate()
		items.add_child(tile)  # add first, so the % nodes are ready
		tile.setup(entry, i % 2 == 1)
		tile.pressed.connect(_on_item_pressed)

func _on_item_pressed(entry: ShopEntry):
	%Marquee.celebrate_purchase()
	item_pressed.emit(entry)
