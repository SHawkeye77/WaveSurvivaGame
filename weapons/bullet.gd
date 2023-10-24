extends Node2D

@onready var world = get_tree().get_first_node_in_group("world")
@export var direction = Vector2.ZERO
@export var damage = Global.BULLET_DAMAGE

func _ready():
	world.playGunShot()

func _process(delta):
	# Move the bullet
	position += delta * direction * Global.BULLET_SPEED
	
	# Removing the bullet if it goes off the screen
	if (position.x < 0 or position.x > get_viewport_rect().size.x or 
		position.y < 0 or position.y > get_viewport_rect().size.y):
		self.queue_free()

# Run when the bullet hits an enemy
func enemy_hit():
	self.queue_free()


func _on_body_entered(body):
	# Removing the bullet if it hits something
	if (body.name == "TileMap" ||           # Only hits tilemap if it hits a tile that has a physics layer (the box)
		body.has_method("iAmMysteryBox") ||              # Mystery box
		body.has_method("iAmFireRateIncreaseBox") ||     # Fire rate increase box
		body.has_method("iAmBulletAmountIncreaseBox")):  # Bullet amount increase box
		self.queue_free()
