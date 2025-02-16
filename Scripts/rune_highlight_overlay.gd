@tool
extends XRToolsHighlightMaterial

## Called when the pickable highlight changes
func _on_highlight_updated(_pickable: Variant, enable: bool) -> void:
	# Set the materials
	if _highlight_mesh_instance:
		if enable:
			_highlight_mesh_instance.set_surface_override_material(0, highlight_material)
		else:
			_highlight_mesh_instance.set_surface_override_material(0, _original_materials[0])
