@tool
extends Control

var texture : Texture2D:
	set(value):
		texture = value
		%RGB.texture = texture
		%A.texture = texture

var uv_scale: float:
	set(value):
		uv_scale = value
		%RGB.material.set_shader_parameter("scale", uv_scale)
		%A.material.set_shader_parameter("scale", uv_scale)

var speed: Vector2:
	set(value):
		speed = value
		%RGB.material.set_shader_parameter("speed", speed)
		%A.material.set_shader_parameter("speed", speed)


func _ready() -> void:
	%RGB.material = %RGB.material.duplicate()
	%A.material = %A.material.duplicate()
	%RGB.material.set_shader_parameter("scale", uv_scale)
	%RGB.material.set_shader_parameter("speed", speed)
	%A.material.set_shader_parameter("scale", uv_scale)
	%A.material.set_shader_parameter("speed", speed)
