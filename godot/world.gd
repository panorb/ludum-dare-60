class_name World

extends Node

const GAME_SCENE := preload("res://game.tscn");

var current_scene_node: Node;
var current_scene : Resource:
	set(new_scene_ressource):
		if self.current_scene_node:
			self.current_scene_node.queue_free();

		var next_scene_node
		match new_scene_ressource:
			GAME_SCENE:
				var game_scene := GAME_SCENE.instantiate();
				self.add_child(game_scene);
				next_scene_node = game_scene;
				
		self.current_scene_node = next_scene_node;

func _ready() -> void:
	self.current_scene = GAME_SCENE

func _on_intro_finisched():
	self.current_scene = GAME_SCENE;
