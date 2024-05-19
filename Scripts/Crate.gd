extends StaticBody2D

var health = 3

func _on_hitbox_area_entered(area):
	if area.name == "Sword":
		health -= 1
		$anim.play("Hurt")
		await $anim.animation_finished
		$anim.play("Active")
	if health <= 0:
		$anim.play("Destroyed")
		await $anim.animation_finished
		queue_free()
