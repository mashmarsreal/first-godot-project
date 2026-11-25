extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -300.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: Area2D = $Sprite/Area2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var gui: Node = %GUI


var isAttacking: bool = false		
var Damage: int = 10
var Direction
var Health:int = 100
var maxHealth:float = 100


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		Jump()
		

	Direction = Input.get_axis("MoveLeft", "MoveRight")
	
	#Movement
	Move()
	
	#SpriteDir
	playerDir()
		
	#Animation
	playAnim()

	#Attacking
	if Input.is_action_just_pressed("Attack") and not isAttacking:
		Attack()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if isAttacking and body.is_in_group("Enemy"):
		body.TakeDamage(Damage)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		isAttacking = false
		
func Move():
	if Direction:
		velocity.x = Direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func Jump():
	velocity.y = JUMP_VELOCITY
	
func Attack():
	isAttacking = true
	anim.play("Attack")
	
func playAnim():
	if !isAttacking:
		if Direction == 0:
			sprite.play("default")
		else :
			sprite.play("Walk")
			
func playerDir():
	if !isAttacking:
		if Direction > 0 :
			sprite.flip_h = true
			hitbox.position.x = 4
		elif Direction < 0:
			sprite.flip_h = false
			hitbox.position.x = -4
	
func TakeDamage(damage: int):
	Health -= damage
	print("You got hit, Remaining Health: " + str(Health))
	if gui.has_method("changeVal"):
		var percentage: float = Health/maxHealth*100
		gui.changeVal(percentage)
	if Health <= 0:
		Engine.time_scale = move_toward(Engine.time_scale, 0, 0.5)
		anim.play("Dead")
		timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
