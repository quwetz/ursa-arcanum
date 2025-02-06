class_name CheatController
extends Node

var amplify: AmplifySupport
var bounce: BounceSupport
var chain: ChainSupport
var faster: FasterSupport
var fork: ForkSupport
var pierce: PierceSupport

func _init():
	Globals.cheat_controller = self

func _process(delta):
	if Input.is_action_just_pressed("Amplify"):
		amplify.toggle_effect()
	if Input.is_action_just_pressed("Bounce"):
		bounce.toggle_effect()
	if Input.is_action_just_pressed("Chain"):
		chain.toggle_effect()
	if Input.is_action_just_pressed("Faster"):
		faster.toggle_effect()
	if Input.is_action_just_pressed("Fork"):
		fork.toggle_effect()
	if Input.is_action_just_pressed("Pierce"):
		pierce.toggle_effect()
