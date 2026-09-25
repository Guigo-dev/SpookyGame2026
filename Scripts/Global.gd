extends Node2D

var actualRoom: String

var mapsCamLimits := {
	"DiningRoom": [-148,-184,692,256], #Left,Top,Right,Bottom
	"LivingRoom": [-1012,-512,-140,512]
}

var mapsLightStatus := {
	"DiningRoom": false,
	"LivingRoom": false
}
