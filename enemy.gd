extends CharacterBody2D


const SPEED = 70.0
const JUMP_VELOCITY = -400.0
@onready var HealthBar: ProgressBar = $ProgressBar
@onready var Player: Node2D = get_tree().get_first_node_in_group("Player")
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var anim: AnimationPlayer = $AnimationPlayer


var maxHealth: float = 100
var health: int = 100
var Dir
var isAttacking: bool = false
var Damage: int = 25

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Player:
		Dir = global_position.direction_to(Player.global_position)
		moveToPlayer()
		EnemyDir()
		playAnim()
		if isAttacking:
			Attack()
	
func TakeDamage(damage: int) -> void:
	health -= damage
	var value: float = (health/maxHealth) * 100
	HealthBar.value = value
	print("Sisa health: " + str(health) + "\nPercentage: " + str(value))
	
	if health <= 0:
		queue_free()

func moveToPlayer():
	if !isAttacking:
		velocity.x = Dir.x * SPEED
		move_and_slide()
	
func EnemyDir():
	if !isAttacking:
		if Dir.x > 0 :
			sprite.scale.x = -1
		elif Dir.x < 0:
			sprite.scale.x = 1
	
func playAnim():
	if !isAttacking:
		if velocity.x == 0:
			sprite.play("default")
		else :
			sprite.play("Walk")


func _on_detection_body_entered(body: Node2D) -> void:
	if !isAttacking and body.is_in_group("Player"):
		isAttacking = true

func Attack():
	if isAttacking:
		anim.play("Attack")

func _on_detection_body_exited(body: Node2D) -> void:
	if isAttacking and body.is_in_group("Player"):
		isAttacking = false


func _on_attack_body_entered(body: Node2D) -> void:
	if isAttacking and body.has_method("TakeDamage"):
		body.TakeDamage(Damage)
