extends GridContainer

@export var ammo_gem_scene: PackedScene
signal madeAmmo(ammo);

const ROWS = 5
const COLS = 5

var tiles = []
var selected: Node = null

func create_board():
	if len(tiles) > 0:
		for child in get_children():
			child.queue_free()
	tiles = []
	columns = COLS
	for r in range(ROWS):
		var row = []
		for c in range(COLS):
			var tile = ammo_gem_scene.instantiate()
			tile.connect(
				"isClicked",
				Callable(self, "_on_tile_clicked")
			)
			add_child(tile)
			row.append(tile)
		tiles.append(row)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_board()
	pass # Replace with function body.

func _on_tile_clicked(tile) -> void:
	if selected == null:
		tile.highlight()
		selected = tile
		return
	else:
		selected.highlight()
		swap(tile)
		selected=null
	pass
	
func swap(tile) -> void:
	swapTwoTiles(tile,selected);
	var matches = check_for_matches();
	remove_matches(matches);
	refill_grid()
	pass

func swapTwoTiles(x,y):
	var temp_at = x.ammoType;
	x.change_ammo_type(y.ammoType)
	y.change_ammo_type(temp_at)
	
func check_for_matches() -> Array:
	var matches = [];
	var ammo = [];

		# check horizontal matches
	for r in range(ROWS):
		var run_type = null
		var run_start = 0
		var run_len = 0
		
		for c in range(COLS):
			var t = tiles[r][c].ammoType
			if t == run_type:
				run_len += 1
			else:
				if run_len >= 3:
					ammo.append({"type":run_type,"power":run_len});
					for i in range(run_start, run_start + run_len):
						matches.append({"r": r, "c": i})
				run_type = t
				run_start = c
				run_len = 1
		if run_len >= 3:
			ammo.append({"type":run_type,"power":run_len});
			for i in range(run_start, run_start + run_len):
				matches.append({"r": r, "c": i})
	
		# check vertical matches
	for c in range(COLS):
		var run_type = null
		var run_start = 0
		var run_len = 0
		
		for r in range(ROWS):
			var t = tiles[r][c].ammoType
			if t == run_type:
				run_len += 1
			else:
				if run_len >= 3:
					ammo.append({"type":run_type,"power":run_len});
					for i in range(run_start, run_start + run_len):
						matches.append({"r": i, "c": c})
				run_type = t
				run_start = r
				run_len = 1
		if run_len >= 3:
			ammo.append({"type":run_type,"power":run_len});
			for i in range(run_start, run_start + run_len):
				matches.append({"r": i, "c": c})

	madeAmmo.emit(ammo)
	# remove duplicates between 2 searches
	var uniq = {}
	var out = []
	for p in matches:
		var key = str(p['r']) + "." + str(p['c'])
		if not uniq.has(key):
			uniq[key] = true
			out.append(p)
	print(out)
	return out
	
func remove_matches(matches):
	# delete matches tiles
	for p in matches:
		var r = p['r']
		var c = p['c']
		tiles[r][c].change_ammo_type("empty")

func refill_grid():
	for c in range(COLS):
		for r in range(ROWS):
			var i = COLS-c-1;
			var j = ROWS-r-1;
			if tiles[i][j].ammoType == "empty":
				#print("found Empty at ",i,j)
				if i > 0:
					#print("Swapping ",tiles[i][j].ammoType,i,j," and ",tiles[i-1][j].ammoType,i-1,j)
					swapTwoTiles(tiles[i][j],tiles[i-1][j])
				else:
					tiles[i][j].change_ammo_type("random");
					#print("We need to create new at ",i,j);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
