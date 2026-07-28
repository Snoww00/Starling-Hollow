extends CharacterBody2D

var speed := 20
var direction : Vector2
var push_distance := 130
var push_direction : Vector2
var health := 4:
	set(value):
		health = value
		if health <= 0:
			speed = 0
			$CollisionShape2D.hide()
			$AnimationPlayer.play("Explode")
			await $AnimationPlayer.animation_finished
			queue_free()
@onready var player = get_tree().get_first_node_in_group('Player')

func _physics_process(_delta: float) -> void:
	direction = (player.position - position).normalized()
	velocity = direction * speed + push_direction
	move_and_slide()

func push():
	var tween = get_tree().create_tween()
	var target = (player.position - position).normalized() * -1 * push_distance
	tween.tween_property(self, "push_direction",target,0.1)
	tween.tween_property(self, "push_direction",Vector2.ZERO,0.5)



func hit(tool: Enum.Tool):
	if tool == Enum.Tool.SWORD:
		$FlashSprite2D.flash()
		push()
		health -= 1
