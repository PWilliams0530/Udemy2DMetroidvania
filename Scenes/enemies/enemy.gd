extends CharacterBody2D


var moving_left = true
var speed = 15
var gravity = 30
var health = 3

func _ready():
	$anim.play("Idle")

func _physics_process(delta):
	Move()
	floor_detect()

func Move():
	if moving_left:
		velocity.x = speed
	else:
		velocity.x = -speed
	move_and_slide()
	
	if health <= 0:
		velocity.x = 0
		$anim.play("Dead")
		await $anim.animation_finished
		queue_free()
	
func floor_detect():
	if !$RayCastY.is_colliding() && is_on_floor():
		moving_left  = !moving_left
		scale.x = -scale.x
	elif !$RayCastX.is_colliding() && is_on_wall():
		moving_left  = !moving_left
		scale.x = -scale.x
	
func _on_hitbox_area_entered(area):
	if area.name == "Sword":
		print(health)
		health -= 1
