class_name Editor
extends Control

@onready var shop := %Shop
@onready var placer: Placer = %Placer

var current_balance := preload("res://shop/entries/saucer.tres").price + 50:
	set(value):
		current_balance = value
		if is_node_ready():
			shop.update_available_balance(value)
var last_purchase_value := 0


func _ready() -> void:
	shop.item_pressed.connect(_on_shop_item_pressed)
	placer.placement_finished.connect(_on_placement_finished)
	placer.placement_cancelled.connect(_on_placement_cancelled)
	placer.part_sold.connect(_on_part_sold)
	current_balance = current_balance

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
