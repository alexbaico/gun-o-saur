extends Area2D

var damage = 20

func _on_SkillshotImpactArea_body_entered(body):
	if damage > 0 && body.has_method('receive_damage'):
		#calcular distancia al centro, arriba, abajo, etc
		body.receive_damage(damage)
	get_parent().queue_free()
