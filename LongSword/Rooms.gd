extends Navigation2D

const SPAWN_ROOMS: Array  = [preload("res://Rooms/SpawnRoom0.tscn")]
const INTERMEDIATE_ROOMS: Array = [preload("res://Rooms/Room0.tscn"),preload("res://Rooms/Room1.tscn"),preload("res://Rooms/Room2.tscn")]
const END_ROOMS: Array = [preload("res://Rooms/EndRoom0.tscn")]

const TILE_SIZE: int  = 16
const FLOOR_TILE_INDEX: int = 0
const RIGHT_WALL_INDEX: int = 14
const LEFT_WALL_INDEX: int = 13

export(int) var num_levels: int = 10

onready var player: KinematicBody2D = get_parent().get_node("Player")

func _ready()->void:
	_spawn_rooms()
	
func _spawn_rooms() -> void:
	var previous_room: Node2D
	
	for i in num_levels:
		var room: Node2D
		
		if i == 0: # 시작 방이ㅣ 경우
			room = SPAWN_ROOMS[randi() % SPAWN_ROOMS.size()].instance()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1:
				room = END_ROOMS[randi() % END_ROOMS.size()].instance()
			else:
				room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instance()
			var previous_room_tilemap : TileMap = previous_room.get_node("TileMap") # 이전방의 타일을 가져옴
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")# 이전 방의 문
			var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP * 2 #문위치에서 타일맵 상의 출구 위치 계산
			
			var corridor_height: int = randi() % 5 + 2 # 복도 길
			for y in corridor_height:# 복도 생성
				previous_room_tilemap.set_cellv(exit_tile_pos+Vector2(-2,-y),LEFT_WALL_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos+Vector2(-1,-y),FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos+Vector2(0,-y),FLOOR_TILE_INDEX)
				previous_room_tilemap.set_cellv(exit_tile_pos+Vector2(1,-y),RIGHT_WALL_INDEX)
			var room_tilemap: TileMap = room.get_node("TileMap")
			# 방위치 계산 이전 방의 충구와 복도의 길이를 기준
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.world_to_map(room.get_node("Entrance/Position2D2").position).x * TILE_SIZE
		add_child(room) # 방 자식노드 추가
		previous_room = room # 이전방이 현재 방의로 업데이트
