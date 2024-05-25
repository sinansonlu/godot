extends Node2D

var rng = RandomNumberGenerator.new()

var x = 0
var y = 0
var xx = 0
var yy = 0
var skor = 0

var basiliX = 0
var basiliY = 0

var kareBoyutu = 20

var ilerlemeYonu = 0 # 0: sağ, 1: aşağı, 2: sola, 3: yukarı
var ilerlemeIstegi = 0

var zaman = 0.3
var zamanMak = 0.3

var yemAraligi = 2
var yemAraligiMak = 2

var harita = []
var gen = 25
var yuk = 22 

var oyunDevam = true
var sonrakiTiktaUza = false

var xs = []
var ys = []
var uzanti = 0
	
func takip_et():
	if sonrakiTiktaUza:
		if uzanti == 0:
			xs[uzanti] = x
			ys[uzanti] = y
		else:
			xs[uzanti] = xs[uzanti-1]
			ys[uzanti] = ys[uzanti-1]
	
	if uzanti:
		harita[xs[uzanti-1] + ys[uzanti-1] * gen] = 0
	
	for u in range(uzanti-1,-1,-1):
		if(u == 0):
			xs[u] = x
			ys[u] = y
		else:
			xs[u] = xs[u-1]
			ys[u] = ys[u-1]
			
	if uzanti:
		harita[xs[0] + ys[0] * gen] = 3
		
	if sonrakiTiktaUza:
		uzanti += 1
		sonrakiTiktaUza = false
	pass

func _ready():
	xs.resize(gen * yuk)
	ys.resize(gen * yuk)
	
	xs.fill(-1)
	ys.fill(-1)
	
	harita.resize(gen * yuk)
	harita.fill(0)
	
	# duvarları doldur
	for i in gen:
		harita[i] = 1
	for i in gen:
		harita[i + gen * (yuk - 1)] = 1
		
	for j in yuk:
		harita[j * gen] = 1
	for j in yuk:
		harita[j * gen + (gen - 1)] = 1
	
	x = 4
	y = 4
	xx = x
	yy = y
	pass
	
func yemKoy():
	var ind = rng.randi_range(0, gen * yuk)
	if(harita[ind] == 0):
		harita[ind] = 2
	pass

func _process(delta):
	if oyunDevam:
		zaman -= delta
		yemAraligi -= delta
		
		if yemAraligi <= 0:
			yemAraligi = yemAraligiMak
			yemKoy()
		
		if(zaman <= 0):
			zaman = zamanMak - (zamanMak * uzanti / 100)
			
			# oyunu ilerletmek için iyi bir zaman
			match ilerlemeYonu:
				0:
					xx = x + 1
				1:
					yy = y + 1
				2:
					xx = x - 1
				3:
					yy = y - 1

			match harita[xx + yy * gen]:
				0:
					takip_et()
					x = xx
					y = yy
				1:
					oyunDevam = false
				2:
					harita[x + y * gen] = 0
					sonrakiTiktaUza = true
					takip_et()
					x = xx
					y = yy
					skor += 1
					yemKoy()
				3:
					oyunDevam = false
					
			queue_redraw()
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_LEFT:
				ilerlemeIstegi = 2
			elif event.keycode == KEY_RIGHT:
				ilerlemeIstegi = 0
			elif event.keycode == KEY_UP:
				ilerlemeIstegi = 3
			elif event.keycode == KEY_DOWN:
				ilerlemeIstegi = 1
			elif event.keycode == KEY_R:
				# resetle
				harita.fill(0)
				
				# duvarları doldur
				for i in gen:
					harita[i] = 1
				for i in gen:
					harita[i + gen * (yuk - 1)] = 1
					
				for j in yuk:
					harita[j * gen] = 1
				for j in yuk:
					harita[j * gen + (gen - 1)] = 1
				
				x = 4
				y = 4
				ilerlemeYonu = 0
				ilerlemeIstegi = 0
				uzanti = 0
				
				skor = 0
				oyunDevam = true
			
			if(abs(ilerlemeYonu - ilerlemeIstegi) == 1 or abs(ilerlemeYonu - ilerlemeIstegi) == 3):
				ilerlemeYonu = ilerlemeIstegi
	pass
	
func _draw():
	for i in gen:
		for j in yuk:
			match harita[i + j * gen]:
				1:
					draw_rect(Rect2(i * kareBoyutu, j * kareBoyutu, kareBoyutu, kareBoyutu), Color.RED)
				2:
					draw_rect(Rect2(i * kareBoyutu, j * kareBoyutu, kareBoyutu, kareBoyutu), Color.GREEN)
				3:
					draw_rect(Rect2(i * kareBoyutu, j * kareBoyutu, kareBoyutu, kareBoyutu), Color.GRAY)					
	
	draw_rect(Rect2(x * kareBoyutu, y * kareBoyutu, kareBoyutu, kareBoyutu), Color.WHITE)
	
	if oyunDevam:
		draw_string(ThemeDB.fallback_font, Vector2(gen * kareBoyutu, 20), "Skor: " + str(skor),
				HORIZONTAL_ALIGNMENT_CENTER, 90, 22)
	else:
		draw_string(ThemeDB.fallback_font, Vector2(gen * kareBoyutu, 20), "Bitti! (R)",
				HORIZONTAL_ALIGNMENT_CENTER, 90, 22)
	pass
