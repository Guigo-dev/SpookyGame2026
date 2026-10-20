extends Node2D

var actualRoom: String
var ghostsQtd: int
var heartbeatInterval:= 5.0
var fearLevel = 1
var currentCanvasModulateColor = Color(0.349, 0.349, 0.349)
var animationIsPlaying := false
var ChanllengsCounter := 0

var mapsCamLimits := {
	"DiningRoom": [-140,-186,704,256], #Left,Top,Right,Bottom
	"LivingRoom": [-992,6,-128,512],
	"Kitchen": [-992,-538,-128,18],
	"Attic": [-820, 1025,-333,1247]
}

var mapsLightStatus := {
	"DiningRoom": false,
	"LivingRoom": false,
	"Kitchen": false,
	"Attic": false
}
