@tool
extends EditorPlugin

var inspector_plugin

func _enter_tree():
	inspector_plugin = preload("res://addons/diablo_particles/inspector_plugin/diablo_inspector.gd").new()
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)
