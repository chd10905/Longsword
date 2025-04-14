extends KinematicBody2D
class_name Character , "res://Art/v1.1 dungeon crawler 16X16 pixel pack/heroes/knight/knight_idle_anim_f0.png"

const FRICTION: float = 0.15 # 마찰력 

export(int) var hp: int = 2 setget set_hp
signal hp_changed(new_hp) # 채력 바뀌면 hp_changed 호출


export(int) var accerelation: int = 40 # 가속
export(int) var max_speed: int = 100 # 최대 속도

onready var state_machine: Node = get_node("FiniteStateMachine") # 상태머신
onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")

var mov_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO	

func _physics_process(_delta: float)-> void:
	velocity = move_and_slide(velocity) # 속도 만큼 이동 
	velocity = lerp(velocity,Vector2.ZERO,FRICTION) # 마찰력 효과

func move() -> void:
	mov_direction = mov_direction.normalized() # 방향 정규화
	velocity += mov_direction * accerelation
	velocity = velocity.clamped(max_speed) # 최대속도 조절
	
func take_damage(dam: int,dir: Vector2,force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		
		self.hp -= dam
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 2
			
		
		
func set_hp(new_hp: int) -> void:
	hp = new_hp
	emit_signal("hp_changed",new_hp)
