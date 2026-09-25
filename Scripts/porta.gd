extends StaticBody2D

@export var Area1 : Area2D
@export var Area2: Area2D
var tween: Tween

func interact():
	if tween:
		return
	var tween = create_tween()
	tween.tween_property(self,"rotation",deg_to_rad(-90),2)
	tween.tween_interval(3)
	tween.tween_property(self,"rotation",0,2)
