class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)
signal killed

@export var speed = 300
@export var rate_of_fire := 0.25

@onready var muzzle = $Muzzle

var laser_scene = preload("res://Scenes/laser.tscn")

var shoot_cd := false

@warning_ignore("unused_parameter")

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _input(event):
	if Input.is_action_pressed("shoot"):
		if event is InputEventMouseMotion:
			if event.get_relative().x > 0:
				#print("Moving right")
				var direction : Vector2 = (get_global_mouse_position() - global_position)
				if direction.length() > 100:
					direction = direction.normalized() * speed
				velocity = direction
				move_and_slide()
				global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
				
			if event.get_relative().x < 0:
				#print("Moving left")
				var direction : Vector2 = (get_global_mouse_position() - global_position)
				if direction.length() > 100:
					direction = direction.normalized() * speed
				velocity = direction
				move_and_slide()
				global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
				
			if event.get_relative().y > 0:
				#print("Moving down")
				var direction : Vector2 = (get_global_mouse_position() - global_position)
				if direction.length() > 100:
					direction = direction.normalized() * speed
				velocity = direction
				move_and_slide()
				global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
				
			if event.get_relative().y < 0:
				#print("Moving up")
				var direction : Vector2 = (get_global_mouse_position() - global_position)
				if direction.length() > 100:
					direction = direction.normalized() * speed
				velocity = direction
				move_and_slide()
				global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)	

func _physics_process(_delta):
	
	var direction = Vector2(Input.get_axis("move_left",
	 "move_right"), Input.get_axis("move_up", "move_down"))
	#print(direction)
	velocity = direction * speed
	move_and_slide()
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)

func die():
	killed.emit()
	queue_free()
