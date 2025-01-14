extends ColorRect

# Define a variável dialogPath que será usada para obter o arquivo JSON que contém o diálogo que precisamos / Sets the variable dialogPath used to obtain the JSON file which contains the dialog.
export var dialogPath = ""

# Define a velocidade do texto que será usada / Sets text speed.
export(float) var textSpeed = 0.05

var dialog
var phraseNum = 0

# Texto encerrado / Text finished.
var finished = false

func _ready():
	# Define o tempo de espera do timer com a velocidade do texto / Sets timer wait time with text speed.
	$Timer.wait_time = textSpeed
	
	# Obtém o diálogo / Obtains dialog
	dialog = getDialog()
	
	# Garante que a função getDialog funcionou / Ensures getDialog function worked
	assert(dialog, "Diálogo não encontrado")
	
	# Inicia a próxima frase / Starts next phrase
	nextPhrase()
	
func _process(delta):
	# Verificando se o jogador pressionou a tecla "enter" / Check if wnter key is pressed.
	if Global.final_dialogo == false:
		if Input.is_action_just_pressed("ui_accept") :
			if finished:
				# Exibindo a próxima frase /  Display the next sentence
				nextPhrase()
				$AudioStreamPlayer.play()
			# Se o texto ainda não terminou, o jogador pode pular para o fim do diálogo pressionando "enter"
			else:
				$Text.visible_characters = len($Text.text)
	
	
func getDialog() -> Array:
	var f = File.new()
	
	# Verificando se o arquivo especificado existe / Checks if specified file exists.
	assert(f.file_exists(dialogPath), "Caminho do arquivo não existe")
	
	# Abrindo o arquivo especificado / Opens specified file.
	f.open(dialogPath, File.READ)
	
	# Obtendo os dados do arquivo em formato de texto / Obtains file data in text format.
	var json = f.get_as_text()
	
	# Convertendo o texto em uma variável utilizável (neste caso, uma matriz) / Converts text in usable variable.
	var output = parse_json(json)
	
	# Verificando se a variável de saída é uma matriz, caso contrário, retornando uma lista vazia. / Checks if the output variable is an array, if not, returns an empty list.
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return[]
		
func nextPhrase() -> void:
	# Verificando se todas as frases do diálogo foram exibidas / Checks if all dialog phrases were displayed.
	if phraseNum >= len(dialog):
		Global.icone_mesa = true
		Global.desbloquear_movimentos()
		Global.final_dialogo1()
		queue_free()
		return
	
	finished = false
	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	# Exibindo a frase letra por letra com um tempo de espera / Displays phrase letter by letter with a wait time.
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer,"timeout")
	
	finished= true
	
	phraseNum += 1
	return
	
