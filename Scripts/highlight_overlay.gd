@tool
extends XRToolsHighlightMaterial

# Called when the pickable highlight changes
func _on_highlight_updated(_pickable, enable: bool) -> void:
	# Set the materials
	if _highlight_mesh_instance:
		for i in range(0, _highlight_mesh_instance.get_surface_override_material_count()):
			if enable:
				_highlight_mesh_instance.set_material_overlay(highlight_material)
			else:
				_highlight_mesh_instance.set_material_overlay(_original_materials[i])
