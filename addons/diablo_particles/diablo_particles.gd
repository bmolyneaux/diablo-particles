@tool
extends GPUParticles3D
class_name DiabloParticles
## A streamlined particle system for creating effects that multiply panning
## textures. Enable the plugin to get previews of the texture and panning in the
## inspector.

enum DisplayMode {
	## The color of the object is blended over the background based on the
	## object's alpha value.
	MIX,
	## The color of the object is added to the background and the alpha channel is
	## used to mask out the background. This is effectively a hybrid of the blend
	## mix and add modes, useful for effects like fire where you want the flame to
	## add but the smoke to mix. Make sure that all textures are imported with
	## premultiplied alpha enabled - or if using procedural textures, ensure that
	## the alpha is reflected in the color.
	PREMULTIPLIED_ALPHA,
	## Additive blending.
	ADD,
	## Simple low opacity billboards for debugging the particle process material.
	DEBUG
}
## Whether to render the particles with the mix blend mode or the premultiplied
## alpha blend mode.
@export var display_mode: DisplayMode = DisplayMode.MIX:
	set(value):
		if display_mode != value and self.draw_pass_1:
			self.draw_pass_1.material = null
		display_mode = value
		_update_parameters()

## Multiplication factor for the color value. Used to recover lost brightness
## from multiplying textures.
@export_range(0.5, 4, 0.5, "suffix:x", "or_greater") var color_boost := 1.0:
	set(value):
		color_boost = value
		_update_parameters()
## Multiplication factor for the alpha value. Used to reverse darkening caused
## by multiplying texture alphas. An ideal value is typically the number of
## textures you are using with alpha content.
@export_range(0.5, 4, 0.5, "suffix:x", "or_greater") var alpha_boost := 1.0:
	set(value):
		alpha_boost = value
		_update_parameters()

@export_category("Texture 1")
@export var texture1: Texture2D:
	set(value):
		texture1 = value
		notify_property_list_changed()
		_update_parameters()
## Scale factor applied to UVs and to the pan speed.
@export_range(0.25, 4, 0.05, "suffix:x", "or_greater", "or_less") var uv_scale1 := 1.0:
	set(value):
		uv_scale1 = value
		_update_parameters()
## The pan speed in the U direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_u1 := 0.0:
	set(value):
		pan_speed_u1 = value
		_update_parameters()
## The pan speed in the V direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_v1 := 0.0:
	set(value):
		pan_speed_v1 = value
		_update_parameters()

@export_category("Texture 2")
@export var texture2: Texture2D:
	set(value):
		texture2 = value
		notify_property_list_changed()
		_update_parameters()
## Scale factor applied to UVs and to the pan speed.
@export_range(0.25, 4, 0.05, "suffix:x", "or_greater", "or_less") var uv_scale2 := 1.0:
	set(value):
		uv_scale2 = value
		_update_parameters()
## The pan speed in the U direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_u2 := 0.0:
	set(value):
		pan_speed_u2 = value
		_update_parameters()
## The pan speed in the V direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_v2 := 0.0:
	set(value):
		pan_speed_v2 = value
		_update_parameters()

@export_category("Texture 3")
@export var texture3: Texture2D:
	set(value):
		texture3 = value
		notify_property_list_changed()
		_update_parameters()
## Scale factor applied to UVs and to the pan speed.
@export_range(0.25, 4, 0.05, "suffix:x", "or_greater", "or_less") var uv_scale3 := 1.0:
	set(value):
		uv_scale3 = value
		_update_parameters()
## The pan speed in the U direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_u3 := 0.0:
	set(value):
		pan_speed_u3 = value
		_update_parameters()
## The pan speed in the V direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_v3 := 0.0:
	set(value):
		pan_speed_v3 = value
		_update_parameters()

@export_category("Texture 4")
@export var texture4: Texture2D:
	set(value):
		texture4 = value
		notify_property_list_changed()
		_update_parameters()
## Scale factor applied to UVs and to the pan speed.
@export_range(0.25, 4, 0.05, "suffix:x", "or_greater", "or_less") var uv_scale4 := 1.0:
	set(value):
		uv_scale4 = value
		_update_parameters()
## The pan speed in the U direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_u4 := 0.0:
	set(value):
		pan_speed_u4 = value
		_update_parameters()
## The pan speed in the V direction. Value will be scaled by the scale factor.
@export_range(0, 1, 0.01, "suffix:/s", "or_greater", "or_less") var pan_speed_v4 := 0.0:
	set(value):
		pan_speed_v4 = value
		_update_parameters()

var _default_texture : Texture2D = _get_default_texture()

## Signal to the inspector plugin that a parameter changed so the texture
## preview can be updated.
signal parameter_changed


func _validate_property(property: Dictionary) -> void:
	if property.name in ["uv_scale1", "pan_speed_u1", "pan_speed_v1"]:
		if texture1 == null:
			property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["uv_scale2", "pan_speed_u2", "pan_speed_v2"]:
		if texture2 == null:
			property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["uv_scale3", "pan_speed_u3", "pan_speed_v3"]:
		if texture3 == null:
			property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["uv_scale4", "pan_speed_u4", "pan_speed_v4"]:
		if texture4 == null:
			property.usage = PROPERTY_USAGE_NO_EDITOR


func _get_default_texture() -> Texture2D:
	var texture = GradientTexture1D.new()
	texture.width = 1
	texture.gradient = Gradient.new()
	texture.gradient.remove_point(0)
	return texture


func _update_texture(i : int) -> void:
	var tex_param = "tex" + str(i)
	var tex_val = get("texture" + str(i))
	if not tex_val:
		tex_val = _default_texture

	var material = self.draw_pass_1.material

	material.set_shader_parameter(tex_param, tex_val)

	var scale_param = "scale" + str(i)
	var scale_val = get("uv_scale" + str(i))
	material.set_shader_parameter(scale_param, scale_val)

	var speed_param = "speed" + str(i)
	var speed_val = Vector2(get("pan_speed_u" + str(i)), get("pan_speed_v" + str(i)))
	material.set_shader_parameter(speed_param, speed_val)
	
	material.set_shader_parameter("color_boost", color_boost)
	material.set_shader_parameter("alpha_boost", alpha_boost)


func _update_parameters() -> void:
	if not self.draw_pass_1:
		self.draw_pass_1 = QuadMesh.new()
	
	if not self.draw_pass_1.material:
		var material = ShaderMaterial.new()
		match(display_mode):
			DisplayMode.MIX:
				material.shader = preload("res://addons/diablo_particles/shaders/diablo_mix.gdshader")
				self.draw_pass_1.material = material
			DisplayMode.PREMULTIPLIED_ALPHA:
				material.shader = preload("res://addons/diablo_particles/shaders/diablo_premultiplied_alpha.gdshader")
				self.draw_pass_1.material = material
			DisplayMode.ADD:
				material.shader = preload("res://addons/diablo_particles/shaders/diablo_add.gdshader")
				self.draw_pass_1.material = material
			DisplayMode.DEBUG:
				material.shader = preload("res://addons/diablo_particles/shaders/diablo_debug.gdshader")
				self.draw_pass_1.material = material
	
	for i in range(1, 5):
		_update_texture(i)
	
	if self.process_material:
		self.process_material.anim_offset_min = 0.0
		self.process_material.anim_offset_max = 1.0

	parameter_changed.emit()


func _init() -> void:
	# TODO: Only in the editor
	_update_parameters()
