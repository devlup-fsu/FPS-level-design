@tool

extends Area3D

@onready var mat: Material = $MeshInstance3D.mesh.material

@export var affect: float = -3:
	set(value):
		affect = value
		# print(hue_dict[color])
		if Engine.is_editor_hint():
			mat.set_shader_parameter("affect", affect)

@export var size: Vector3 = Vector3.ONE:
	set(value):
		size = value
		$MeshInstance3D.mesh.size = size
		$CollisionShape3D.shape.size = size

@export_category("check this like it's a button 🧙‍♀️😵😮🦉✅")
@export var duplicate: bool:
	set(value):
		if Engine.is_editor_hint():
			var dup = load("res://prefabs/HealHurtBlock/HealHurtVolume.tscn").instantiate()
			dup.affect = affect
			dup.size = size
			dup.transform = transform
			get_parent().add_child(dup)
			dup.set_owner(get_tree().get_edited_scene_root())
			var selection = EditorInterface.get_selection()
			selection.clear()
			selection.add_node(dup)
			dup.name = "HealHurtVolume"


# Called when the node enters the scene tree for the first time.
func _ready():
	mat.set_shader_parameter("affect", affect)
	if not Engine.is_editor_hint():
		visible = false


func _on_body_entered(body):
	body.health += affect
	body._health_changed()
