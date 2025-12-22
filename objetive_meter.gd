extends ProgressBar

# Definimos los niveles de 20 en 20
var niveles = [20, 40, 60, 80, 100]

func _ready() -> void:
	# 1. Configuración básica de la barra
	min_value = 0
	max_value = 100
	value = 0
	fill_mode = FillMode.FILL_BOTTOM_TO_TOP # Hacerla vertical
	
	# 2. Esperar un frame para que Godot calcule los tamaños finales
	await get_tree().process_frame
	
	# 3. Colocar los marcadores en su sitio
	_organizar_marcadores()

func _organizar_marcadores():
	# Buscamos el contenedor de los marcadores
	# Asegúrate de que el nombre coincida con tu nodo (ej: "Markers")
	var contenedor = get_node_or_null("Markers")
	
	if not contenedor:
		print("Error: No encontré el nodo 'Markers' dentro de la barra")
		return

	# Aseguramos que el contenedor ocupe toda la barra
	contenedor.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	for valor in niveles:
		# Buscamos cada línea y cada texto por su nombre
		var rect = contenedor.get_node_or_null("Marker" + str(valor))
		var texto = contenedor.get_node_or_null("Label" + str(valor))
		
		# Calculamos la posición (0.0 es arriba, 1.0 es abajo)
		var ratio = valor / 100.0
		var pos_y = 1.0 - ratio
		
		# Posicionar la línea (ColorRect)
		if rect:
			rect.anchor_left = 0.0
			rect.anchor_right = 1.0
			rect.anchor_top = pos_y
			rect.anchor_bottom = pos_y
			rect.offset_top = -1
			rect.offset_bottom = 1
			rect.offset_left = 0
			rect.offset_right = 0
			
		# Posicionar el número (Label)
		if texto:
			texto.anchor_left = 1.0 # Pegado a la derecha de la barra
			texto.anchor_right = 1.0
			texto.anchor_top = pos_y
			texto.anchor_bottom = pos_y
			texto.offset_left = 10  # Separación de la barra
			texto.offset_top = -10 # Centrado vertical con la línea

# Función para que llames desde tu juego cuando ganes puntos
func sumar_progreso(puntos: int):
	var nuevo_valor = value + puntos
	# Animación suave para que la barra suba
	var tween = create_tween()
	tween.tween_property(self, "value", nuevo_valor, 0.5).set_trans(Tween.TRANS_CUBIC)
