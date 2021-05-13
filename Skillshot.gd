extends Node2D

onready var SkillshotBehaviour = $SkillshotBehaviour
onready var SkillshotImpactArea = $SkillshotImpactArea

func _ready():
	#por ahi pasar esto a variables exportables para config por inspector?
	SkillshotBehaviour.mass = 2.0
	SkillshotImpactArea.damage = 20
	
func get_skillshot_behaviour():
	return SkillshotBehaviour
	
