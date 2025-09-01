@tool
extends EditorInspectorPlugin

const TEXTURE_PREVIEW_SCENE = preload("res://addons/diablo_particles/inspector_plugin/diablo_texture_preview.tscn")


func _can_handle(object: Object) -> bool:
	return true
	
	
func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	var script = object.get_script()
	if not script:
		return false

	if object.get_script().get_global_name() != "DiabloParticles":
		return false
	
	if name not in ["texture1", "texture2", "texture3", "texture4"]:
		return false
	
	var texture = object.get(name)
	
	if not texture:
		return false
	
	var i = name[name.length()-1]
	
	var texture_preview = TEXTURE_PREVIEW_SCENE.instantiate()
	texture_preview.texture = texture
	texture_preview.speed = Vector2(object.get("pan_speed_u" + i), object.get("pan_speed_v" + i))
	texture_preview.uv_scale = object.get("uv_scale" + i)
	add_custom_control(texture_preview)
	
	var update_texture_preview = func():
		if not texture_preview:
			print("texture_preview is null")
			return
		texture_preview.texture = object.get(name)
		texture_preview.speed = Vector2(object.get("pan_speed_u" + i), object.get("pan_speed_v" + i))
		texture_preview.uv_scale = object.get("uv_scale" + i)
	object.parameter_changed.connect(update_texture_preview)
	var disconnect_update_texture_preview = func():
		object.parameter_changed.disconnect(update_texture_preview)
	texture_preview.tree_exiting.connect(disconnect_update_texture_preview)
	
	return false
