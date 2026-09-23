extends StaticBody2D

var was_eaten = false

func interact():
	
	was_eaten = true
	$Sprite2D.hide()
