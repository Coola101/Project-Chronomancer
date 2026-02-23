extends Area3D

@export var text: String = ""

@onready var note = load("res://scenes/prefabs/note_ui.tscn")
# Called when the node enters the scene tree for the first time.

func do_interaction():
	var canvas = get_tree().get_root().get_child(0).get_node("CanvasLayer")
	
	var instance = note.instantiate()
	instance.get_child(1).text = text
	canvas.add_child.call_deferred(instance)
	
