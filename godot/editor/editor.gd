class_name Editor
extends Control

var current_balance := preload("res://shop/entries/saucer.tres").price + 50:
	set(value):
		current_balance = value
		%Shop.update_available_balance(value)
var last_purchase_value := 0

func _ready() -> void:
	%Shop.item_pressed.connect(_on_shop_item_pressed)
	%Placer.placement_cancelled.connect(_on_placement_cancelled)
	current_balance = current_balance

func _on_shop_item_pressed(entry: ShopEntry):
	if current_balance >= entry.price:
		%Shop.interactable = false
		current_balance -= entry.price
		%Placer.start(entry.scene)
		last_purchase_value = entry.price

func _on_placement_cancelled():
	current_balance += last_purchase_value # Refund!
	%Shop.interactable = true
