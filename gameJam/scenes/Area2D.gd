extends Area2D



func _on_Area2D_area_entered(area):
	get_parent().hit()
