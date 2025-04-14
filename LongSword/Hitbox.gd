extends Area2D
class_name Hitbox
export(int) var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
export(int) var knockback_force: int = 300
# 첫 타격 직후 공격을 끄고 싶으면 주석 해제 -> 난이도 하락

# var body_inside: bool = false

onready var collision_shape: CollisionShape2D = get_child(0) #충돌 모양 저장
#onready var timer: Timer = Timer.new()

func _init()->void:
	var __ = connect("body_entered",self,"_on_body_entered")
	# __ = connect("body_exited",self,"_on_body_exited")
func _ready() -> void:
	assert(collision_shape != null)
	#timer.wait_time =1
	#add_child(timer)
func _on_body_entered(body: PhysicsBody2D) -> void:
	#body_inside =true
	#timer.start()
	#while body_inside:
	#	_collide(body)
	#	yield(timer,"timeout")
	_collide(body) # 히트
func _on_body_exited(_body: KinematicBody2D) -> void:
	#body_inside = false
	#timer.stop()
	pass # 주석 해제시 이부분 삭제
	
func _collide(body: KinematicBody2D) -> void: 
	if body == null or not body.has_method("take_damage"):
		queue_free() # body 가 없거나 데미지 함수가 없으면 삭제
	else:
		body.take_damage(damage, knockback_direction,knockback_force)
