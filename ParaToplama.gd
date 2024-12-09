extends Node2D

var bizim_adam:CharacterBody2D

var puan = 0
var zaman = 0
var can = 100

var paralar = []

var etiket:Label
var etiket2:Label

func _ready() -> void:
	bizim_adam = CharacterBody2D.new()
	
	# şekil oluşturma
	var sekil:CollisionShape2D = CollisionShape2D.new()
	var kare:RectangleShape2D = RectangleShape2D.new()
	kare.size = Vector2(128,128)
	sekil.shape = kare
	bizim_adam.add_child(sekil)
	
	# sprite oluşturma
	var gorsel:Sprite2D = Sprite2D.new()
	gorsel.texture = load("res://icon.svg")
	bizim_adam.add_child(gorsel)
	
	bizim_adam.position = Vector2(get_window().size.x/2,get_window().size.y/2)
	gorsel.z_index = 1
	add_child(bizim_adam)
	
	etiket = Label.new()
	etiket.position = Vector2(50,50)
	etiket.text = "0"
	etiket.z_index = 2
	add_child(etiket)
	
	etiket2 = Label.new()
	etiket2.position = Vector2(50,70)
	etiket2.text = "100"
	etiket2.z_index = 2
	add_child(etiket2)
	
	pass

func area2d_ekle(x,y,baglanacak_fonksiyon,renk):
	var para_alani = Area2D.new()
	
	var sekil = CollisionShape2D.new()
	var kare:RectangleShape2D = RectangleShape2D.new()
	kare.size = Vector2(128,128)
	sekil.shape = kare
	para_alani.add_child(sekil)
	
	var gorsel:Sprite2D = Sprite2D.new()
	gorsel.texture = load("res://icon.svg")
	gorsel.modulate = renk
	para_alani.add_child(gorsel)
	
	para_alani.position = Vector2(x,y)
	para_alani.body_entered.connect(baglanacak_fonksiyon.bind(para_alani))
	para_alani.scale = Vector2(0.5,0.5)
	add_child(para_alani)
	paralar.append(para_alani)
	pass
	
func _paraya_degdi(ice_giren,kendisi):
	kendisi.queue_free()
	paralar.erase(kendisi)
	puan += 10
	etiket.text = str(puan)
	pass
	
func _para_hasar_verdi(ice_giren,kendisi):
	kendisi.queue_free()
	paralar.erase(kendisi)
	can -= 10
	etiket2.text = str(can)
	pass

var hiz_miktari = 500

func _physics_process(delta: float) -> void:
	var hiz = Vector2(0,0)
	if(Input.is_action_pressed("ui_left")):
		hiz.x = -1
	elif(Input.is_action_pressed("ui_right")):
		hiz.x = 1
	if(Input.is_action_pressed("ui_up")):
		hiz.y = -1
	elif(Input.is_action_pressed("ui_down")):
		hiz.y = 1
	bizim_adam.velocity = hiz.normalized() * hiz_miktari
	bizim_adam.move_and_slide()
	pass

func _process(delta: float) -> void:
	for para in paralar:
		para.position.y += 200 * delta
	
	zaman -= delta
	if(zaman < 0):
		if(randf() < 0.5):
			area2d_ekle(randi_range(0,get_window().size.x),0,_paraya_degdi,Color.YELLOW)
		else:
			area2d_ekle(randi_range(0,get_window().size.x),0,_para_hasar_verdi,Color.RED)
		zaman = 0.4
	pass
