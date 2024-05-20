extends CharacterBody2D

enum PlayerStates {MOVE, SWORD, DEAD}
var CurrentState = PlayerStates.MOVE

var speed = 200.0
#delta = 60 frames per second
var gravity = 20
var jump = 400
var pressed = 2

var health = Globals.player_lives

func _ready():
	$Sword/CollisionShape2D.disabled = true

func _physics_process(delta):
	match CurrentState:
		PlayerStates.MOVE:
			Move(delta)
		PlayerStates.SWORD:
			Sword()
		PlayerStates.DEAD:
			Dead()
		
	
	velocity.y += gravity
	move_and_slide()

func Move(delta):
	var movement = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if movement != 0.0:
		if movement > 0.0: #pressed right
			velocity.x += speed * delta
			velocity.x = clamp(speed,100,speed)
			$Sprite2D.flip_h = false
			$anim.play("Walk")
			$Sword/CollisionShape2D.position = Vector2(0,0)
		if movement < 0: #pressed right
			velocity.x -= speed * delta
			velocity.x = clamp(speed,-100,-speed)
			$Sprite2D.flip_h = true
			$anim.play("Walk")
			$Sword/CollisionShape2D.position = Vector2(-50,0)
	if movement == 0.0:
		velocity.x = 0.0
		$anim.play("Idle")
		
	if Input.is_action_just_pressed("ui_jump"):
		pressed -= 1
		
	if is_on_floor():
		pressed = 2
		
	if is_on_floor() && Input.is_action_just_pressed("ui_jump"):
		Jump()
		
	if !is_on_floor() && Input.is_action_just_pressed("ui_jump") && pressed >=1:
		Jump()
		
	if pressed <= 0:
		velocity.y = velocity.y
		
	if !is_on_floor():
		$anim.play("Jump")
		
	if !is_on_floor() && velocity.y > 10:
		$anim.play("Fall")
		
	if Input.is_action_just_pressed("ui_sword"):
		CurrentState = PlayerStates.SWORD
		velocity.x = movement
		
func Jump():
	$anim.play("Jump")
	velocity.y -= jump

func Sword():
	$anim.play("Sword")
	
	
func Dead():
	$anim.play("Dead")
	await $anim.animation_finished
	if get_tree():
		get_tree().reload_current_scene()
	Globals.player_lives = 4
	OnStateFinished()

func OnStateFinished():
	CurrentState = PlayerStates.MOVE


func _on_hitbox_body_entered(body):
	if body.name == "Enemy":
		Globals.player_lives -= 1
	if Globals.player_lives <= 0:
		CurrentState = PlayerStates.DEAD
		
