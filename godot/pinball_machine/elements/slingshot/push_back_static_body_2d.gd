
class_name PushBackStaticBody2D 

extends StaticBody2D

signal body_entered(body:Node2D)

func on_bump(body: Node2D) -> void:
	self.body_entered.emit(body)
