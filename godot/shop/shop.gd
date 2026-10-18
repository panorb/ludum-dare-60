extends PanelContainer

# editor.gd (addition)
const SHOP_ITEM := preload("res://shop/item/shop_item.tscn")

@export var shop_entries: Array[ShopEntry] = []

@onready var items: GridContainer = %Items


func _ready() -> void:
	# placer.placement_cancelled.connect(_on_placement_cancelled)
	for entry in shop_entries:
		var tile: ShopItem = SHOP_ITEM.instantiate()
		items.add_child(tile)  # add first, so the % nodes are ready
		tile.setup(entry)
		tile.pressed.connect(_on_item_pressed)

func _on_item_pressed(entry: ShopEntry):
	%Marquee.celebrate_purchase()
