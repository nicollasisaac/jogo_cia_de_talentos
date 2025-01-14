extends KinematicBody2D
# "speed" é a velocidade do personagem, e speedauto é a velocidade da animação do personagem / "Speed" is the character speed and "speedauto" is the speed of the character automovement.
var speedAutoClaudia = 0

# Velocity é uma variável que armazena a velocidade atual do objeto na direção x. / Velocity is the actual velocity of the object on direction x." é uma variável que armazena a velocidade atual do objeto na direção x 
var velocityClaudia = Vector2()

# Etapa atual do movimento / Movement current step.
var stepClaudia = 1

# Referência ao AnimationPlayer / AnimationPlayer Reference
var animation_playerClaudia = null

# Chamar animação. / Call animation.
func _ready():
	animation_playerClaudia = get_node("anim")
	if not animation_playerClaudia:
		print("AnimationPlayer não encontrado")
		

#Função para a movimentação do personagem. / Character movement function.
func _physics_process(delta):
	_set_animation()
	if Global.npc_thomas_active == true:
		stepClaudia = 1
		Global.npc_thomas_active = false
		
	# Calcular a direção do movimento baseada no passo("step") atual. / Calculates direction based on current step.
	var direction = Vector2()
	
	if stepClaudia == 1 && Global.show_dialog3 == true:
		direction = Vector2(512 - position.x, 0)
		if abs(direction.x) < speedAutoClaudia * delta:
			direction.x = 512 # Parar no x = 513
			stepClaudia = 0
	
	if Global.show_dialog3 == false && position.x <= 514:
		Global.show_desicion = true
			
	# Normalizar a direção para obter a velocidade / Normalize direction to obtain speed
	velocityClaudia = direction.normalized() * speedAutoClaudia

	# Executar o movimento com move_and_slide / Runs movement with move_and_slide.
	move_and_slide(velocityClaudia, Vector2(0, -1))
	
# set_animation permite é uma função para controlar as animações. / set_animationpermite is a function to control animations. 
func _set_animation():
	var anim = "idle"
	
	# Ativar devidas animações durante movimentação do personagem. / Activates correct animation during character movement.
	if velocityClaudia.x > 0: 
		anim = "andandoladod"
	elif velocityClaudia.x < 0: 
		anim = "andandoladoe"
	elif velocityClaudia.y < 0:
		anim = "andandocima"
	elif velocityClaudia.y > 0:
		anim = "andandobaixo"
	else:
		anim = "idle"
	
	if $anim.assigned_animation != anim:
		$anim.play(anim)
