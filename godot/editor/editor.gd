extends Control


func _ready() -> void:
	%Shop.item_pressed.connect(_on_shop_item_pressed)

func _on_shop_item_pressed(entry: ShopEntry):
	%Placer.start(entry.scene)
