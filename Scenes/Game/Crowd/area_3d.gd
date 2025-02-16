class_name CrowdArea
extends Area3D

func scale_character(scale_by: float):
	owner.scale += Vector3(scale_by, scale_by, scale_by)
