extends Node

@export var ammo_gem_scene: PackedScene

var gem_board: Array[Array]
var array_size: int = 4;
var grid_offset_x: int = 80;
var grid_offset_y: int = 80;
var grid_start_x: int;
var grid_start_y: int;
var highlight_x: int = -1;
var highlight_y: int = -1;

func _calc_position_on_grid(x: int, y: int) -> Vector2:
	return Vector2(grid_start_x+grid_offset_x*(1+x),grid_start_y+grid_offset_y*(1+y))
	
func _create_gem_at(i,j) -> void:
	var gem = ammo_gem_scene.instantiate()
	gem.gridX = i;
	gem.gridY = j;
	gem.position = _calc_position_on_grid(i,j)
	gem.isClicked.connect(_show_highlight)
	gem_board[i][j] = gem;
	print("Creating an new gem of ", gem.ammoType, " at ", i,j);
	add_child(gem)
	
func _print_board() -> void:
	for i in range(array_size):
		for j in range(array_size):
			var this_gem = gem_board[i][j];
			if this_gem != null:
				print(i,j,this_gem.ammoType,this_gem.gridX,this_gem.gridY)
			else:
				print(i,j,"null");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	grid_start_x = screen_size.x / 3 # Width
	grid_start_y = screen_size.y / 5 # Height
	$Highlight.hide();
	for i in range(array_size):
		var temp_arr = [];
		for j in range(array_size):
			temp_arr.append(null)
		gem_board.append(temp_arr)
		for j in range(array_size):
			_create_gem_at(i,j)
	_print_board()
	_check_for_matches();
			
	pass # Replace with function body.

func _show_highlight(gridX: int, gridY: int) -> void:
	if highlight_x >= 0 and highlight_y >= 0:
		_swap_gems(gridX, gridY);
		return
	else:
		highlight_x = gridX;
		highlight_y = gridY;
		$Highlight.position = _calc_position_on_grid(gridX,gridY);
		$Highlight.show();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _debug_gem(g) -> void:
	print(g,g.gridX,g.gridY);

func _swap_gems(x1,y1) -> void:
	_print_board()
	var current_highlight = gem_board[highlight_x][highlight_y];
	var just_clicked = gem_board[x1][y1];
	just_clicked.position = _calc_position_on_grid(highlight_x,highlight_y);
	current_highlight.position = _calc_position_on_grid(x1,y1);
	gem_board[highlight_x][highlight_y] = just_clicked;
	gem_board[highlight_x][highlight_y].gridX = highlight_x;
	gem_board[highlight_x][highlight_y].gridY = highlight_y;
	gem_board[x1][y1] = current_highlight;
	gem_board[x1][y1].gridX = x1;
	gem_board[x1][y1].gridY = y1; 
	highlight_x = -1;
	highlight_y = -1;
	$Highlight.hide();
	_print_board()
	_check_for_matches();
	
func _swap_any_gems(x1,y1,x2,y2) -> void:
	_print_board()
	var node1 = gem_board[x1][y1];
	var node2 = gem_board[x2][y2];
	if node1 != null:
		node1.hide();
		node1.position = _calc_position_on_grid(x2,y2);
		node1.gridX = x2;
		node1.gridY = y2;
		node1.show();
	if node2 != null:
		node2.hide();
		node2.position = _calc_position_on_grid(x1,y1);
		node2.gridX = x1;
		node2.gridY = y1;
		node2.show();
	gem_board[x1][x2] = node2;
	gem_board[x2][y2] = node1;
	_print_board()
	_check_for_matches();
	
	
func _check_for_matches() -> void:
	#print("Checking for matches COL")
	#for i in range(array_size):
		#var col_check = null;
		#var col_count = 1;
		#for j in range(array_size):
			#var this_gem = gem_board[array_size-i-1][array_size-j-1]
			##print(this_gem.ammoType, col_check, col_count,i,j);
			#if col_check == this_gem.ammoType:
				#col_count+=1;
			#else:
				#if col_count > 2:
					#print(col_check, "  ", col_count);
					#replace_matches_col(i,j,col_check,col_count);
					#return
				#col_count=1
				#col_check = this_gem.ammoType;
			#if array_size == j+1:
				#if col_count > 2:
					#print(col_check, "  ", col_count);
					#replace_matches_col(i,j,col_check,col_count);
					#return

	print("Checking for matches ROW")
	for i in range(array_size):
		var row_check = null;
		var row_count = 1;
		for j in range(array_size):
			var this_gem = gem_board[array_size-j-1][array_size-i-1]
			#print(this_gem.ammoType, row_check, row_count,i,j);
			if this_gem!=null and row_check == this_gem.ammoType:
				row_count+=1;
			else:
				if row_count > 2:
					print(row_check, "  ", row_count);
					replace_matches_row(array_size-j-1,array_size-i-1,row_check,row_count);
					return
				row_count=1
				row_check = this_gem.ammoType if this_gem!=null else "null";
			if array_size == j+1:
				if row_count > 2:
					print(row_check, "  ", row_count);
					replace_matches_row(array_size-j-1,array_size-i-1,row_check,row_count);
					return

func replace_matches_col(x,y,check,count) -> void:
	print(x,y,check,count)
	for z in range(count):
		gem_board[x][array_size-1-y+count-1-z].queue_free();
		gem_board[x][array_size-1-y+count-1-z] = null;
	print("Created a Strength ",count," Ammo of Type: ",check);
	for z in range(count):
		var new_y = array_size-1-y+count-1-z;
		_create_gem_at(x,new_y);

func replace_matches_row(x,y,check,count) -> void:
	for z in range(count):
		print("Row DEBUG", x,y,z,check,count);
		var gem_to_free = gem_board[x+count-z-1][y];
		gem_board[x+count-z][y] = null;
		gem_to_free.queue_free();
	_print_board()
	print("Created a Strength ",count," Ammo of Type: ",check);
	refill_grid();
	#for z in range(count):
		#var new_x = x+count-z-1;
		#print(new_x,y);
		#_create_gem_at(new_x,y);
	#_print_board()
	#for child in get_children():
		#print(child.name)

func refill_grid() -> void:
	for i in range(array_size):
		for j in range(array_size):
			var x = array_size-i-1;
			var y = array_size-j-1; 
			if gem_board[x][y] == null:
				if y==0:
					#_create_gem_at(x,y)
					pass
				else:
					print("Swap at ",x,y," To ",x,y-1)
					_swap_any_gems(x,y,x,y-1);
