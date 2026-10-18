extends Control

var current_balance := preload("res://shop/entries/saucer.tres").price:
	set(value):
		current_balance = value
		%Shop.update_available_balance(value)
	

func _ready() -> void:
	%Shop.item_pressed.connect(_on_shop_item_pressed)
	current_balance = current_balance

func _on_shop_item_pressed(entry: ShopEntry):
	if current_balance >= entry.price:
		current_balance -= entry.price
		%Placer.start(entry.scene)
