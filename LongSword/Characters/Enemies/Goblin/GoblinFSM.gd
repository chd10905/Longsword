extends FiniteStateMachine

func _init()-> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")
	
func _ready() -> void:
	set_state(states.move)
func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.chase()
		parent.move()
func _get_transition() -> int:
	match state:
		states.idle:
			# 플레이어와의 거리가 범위를 벗어나면 move 상태로 전환
			if parent.distance_to_player > parent.MAX_DISTNACE_TO_PLAYER or parent.distance_to_player < parent.MIN_DISTNACE_TO_PLAYER:
				return states.move
		states.move:
			# 플레이어와의 거리가 허용 범위 안에 있으면 idle 상태로 전환
			if parent.distance_to_player >= parent.MIN_DISTNACE_TO_PLAYER and parent.distance_to_player <= parent.MAX_DISTNACE_TO_PLAYER:
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.move
	
	return -1
	
func _enter_state(_previous_state: int , new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")

