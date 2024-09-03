
// Project: BlackJack 
// Created: 23-07-04

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "BlackJack" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 0, 1, 0, 1 ) // allows only landscape and landscape upside down
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )


//need to add high bet low bet button, possibly more if counting methods use more than 2 levels of betting
	// need to eventually program on going statistics, organize history, 3 Deck styles * 7 possible players * 8 count styles
	// need to come up with better formula for ai players
	// need to create function to call window and run through 1-4 sprite possibilities
	

	

global card_width as float
card_width = GetDeviceWidth() / 14
global card_height as float
card_height = GetDeviceHeight() / 8 //will actually be an calculation turned integer
global card_angles as float[]
card_angles = [10, 40, 65, 90, 115, 140, 170, 90]
global hidden_dealer_card as integer
global flipped_dealer_card as integer

type player_hands     // create hand data storage
	hand_total as integer    //need to convert to an array to accomadate for programming for split
	hand_count as integer    //need to convert to an array to accomadate for programming for split
	bust_status as integer    //need to convert to an array to accomadate for programming for split		BUST STATUS MAY BE UNNESSECARY		
	black_jack_status as integer    //need to convert to an array to accomadate for programming for split
	hand_aces as integer    //need to convert to an array to accomadate for programming for split
	win_status as string		//need to convert to an array to accomadate for programming for split
	split_status as integer	//need to convert to an array to accomadate for programming for split  /// MAY STAY AS INTEGER NON ARRAY
	
	hit_status as integer
	
	player_seat as integer
	auto_mode as string
	
	player_name as string

		// eventually add spot for loading each card drawn for statistics

endtype
	
global all_players_hands as player_hands[]  /// create array to hold all hands






global center_x as float 
center_x = GetDeviceWidth() / 2
global center_y as float
center_y = GetDeviceHeight() / 2
global ellipses_y as float
ellipses_y = GetDeviceHeight() / 2 - GetDeviceHeight() / 8




global left_x as float
left_x = .25 * GetDeviceWidth()// button x,y positions, compact for saving space
global right_x as float
right_x = .75 * GetDeviceWidth()
global players_y as float
players_y = .125 * GetDeviceHeight()
global seat_y as float
seat_y = .25 * GetDeviceHeight()
global decks_y as float
decks_y = .375 * GetDeviceHeight()
global style_y as float
style_y = .5 * GetDeviceHeight()
global method_y as float
method_y = .625 * GetDeviceHeight()
global menu_button_y as float
menu_button_y = .875 * GetDeviceHeight()
	

global menu_button_width as float
menu_button_width = GetDeviceWidth() / 11// Menu Button size
global menu_button_height as float
menu_button_height = GetDeviceHeight() / 13
	


	// Calculate Game button positions as a percentage of screen size need to adjust
global game_button_left as float
game_button_left = GetDeviceWidth() * .01
global game_button_up as float
game_button_up = GetDeviceHeight() * .2
global game_button_right as float
game_button_right = GetDeviceWidth() * .99
global game_button_down as float
game_button_down = GetDeviceHeight() * .9


global title_phase as integer[]	
global game_phase as integer[]	
global hit_phase as integer[]
global hand_phase as integer	[]

global players as integer = 1  //default value for rotation and settings
global user_seat as integer = 1 
global decks as integer = 1
global style as string[]
style = ["Assisted", "Counter", "Savant", "Computer"]   // may add  in multiple choice, fill in blank options
global method as string[]
method = ["Hi-Lo", "KO", "Hi-Opt I", "Hi-Opt II", "Zen", "Omega II", "Red 7", "Halves"]
	
global current_drawn as integer[52]	 //deck management
global deal_history as string[]
global card_total as integer
global cut as integer
global total_hands as integer


global hi_lo_count as float// count counters(yeah I did that)
global ko_count as float
global hi_opt_i_count as float
global hi_opt_ii_count as float
global zen_count as float
global omega_ii_count as float
global red_seven_count as float
global halves_count as float

global hit_button as integer
global stay_button as integer

global sleep_time as float
sleep_time = .2
global button_name as string[]	
global auto_play_button as integer[4]  //button management, may move declrations back to inside the subroutine
global exit_button as integer
global exit_check as integer = 0
global button_tracker as integer = 0
global sprite_tracker as integer = 0
global text_tracker as integer = 0
global auto_play_options as string[]
auto_play_options = ["Standard", "Conservative", "Aggressive", "Sporadic"] 
global auto_mode_selection as string[]
auto_mode_selection = ["Standard", "Standard", "Standard", "Standard", "Standard", "Standard", "Standard", "Aggressive"]			// need to figure out how to create, possible tranistion to numbers
global button_layer as integer[]
global sprite_layer as integer[]
global text_layer as integer[]
global game_state as string			 
		   
/// gosub Loadgame   -- no code for this yet
gosub Title
	
Title:
	game_state = "title"
		
	start_layer(button_layer, button_tracker)		
	
	start_layer(text_layer, text_tracker)
	



				/// buttons to adjust the game style --------------NEED TO SET BUTTONS TEXT TO COLOR OF IMAGES, WILL NEED TO EXPAND BUTTON INPUT
	left_players_button as integer 
	left_players_button = add_button(left_x, players_y, menu_button_width, menu_button_height, "left arrow", "left_arrow_up.png", "left_arrow_down.png", title_phase)
	right_players_button as integer
	right_players_button = add_button(right_x, players_y ,menu_button_width, menu_button_height, "right arrow", "right_arrow_up.png", "right_arrow_down.png", title_phase)
	left_seat_button as integer
	left_seat_button = add_button(left_x, seat_y, menu_button_width, menu_button_height, "left seat", "left_arrow_up.png", "left_arrow_down.png", title_phase)
	right_seat_button as integer
	right_seat_button  = add_button(right_x, seat_y,menu_button_width, menu_button_height, "right seat", "right_arrow_up.png", "right_arrow_down.png", title_phase)
	left_decks_button as integer 
	left_decks_button = add_button(left_x, decks_y, menu_button_width, menu_button_height, "left decks", "left_arrow_up.png", "left_arrow_down.png", title_phase)
	right_decks_button as integer 
	right_decks_button = add_button(right_x, decks_y, menu_button_width, menu_button_height, "right decks", "right_arrow_up.png", "right_arrow_down.png", title_phase)
	left_style_button as integer 
	left_style_button = add_button(left_x, style_y, menu_button_width, menu_button_height, "left style", "left_arrow_up.png", "left_arrow_down.png", title_phase)
	right_style_button as integer 
	right_style_button = add_button(right_x, style_y, menu_button_width, menu_button_height, "right style", "right_arrow_up.png", "right_arrow_down.png", title_phase)
	left_method_button as integer 
	left_method_button = add_button(left_x, method_y, menu_button_width, menu_button_height, "left method", "left_arrow_up.png", "left_arrow_down.png", title_phase)
	right_method_button as integer
	right_method_button = add_button(right_x, method_y, menu_button_width, menu_button_height, "right method", "right_arrow_up.png", "right_arrow_down.png", title_phase)
	
			/// Menu buttons
	settings_button as integer
	settings_button = add_button(left_x, menu_button_y, menu_button_width, menu_button_height, "Settings", "settings_up.png", "settings_down.png",title_phase)
	start_game_button as integer
	start_game_button = add_button(center_x, menu_button_y, menu_button_width, menu_button_height,"Start", "start_button_up.png", "start_button_down.png", title_phase)
	history_button as integer
	history_button = add_button(right_x, menu_button_y, menu_button_width, menu_button_height, "History", "history_up.png", "history_down.png", title_phase)
	
	exit_button = add_button(game_button_right, game_button_up, menu_button_width, menu_button_height, "exit", "exit_up.png", "exit_down.png", title_phase)
	//add exit buttons

																			
		//create prite to backdrop current menu settings for game
	
	global player_text as integer
	player_text = add_text(str(players) + " Players", Round((left_x + right_x) / 2), players_y)
	global seat_text as integer
	seat_text = add_text("Seat " + str(user_seat), Round((left_x + right_x) / 2) , seat_y)
	global deck_text as integer
	deck_text = add_text("Home Play", Round((left_x + right_x) / 2) , decks_y) 
	global style_text as integer
	style_text = add_text(style[0], Round((left_x + right_x) / 2) , style_y)
	global method_text as integer
	method_text = add_text(method[0], Round((left_x + right_x) / 2) , method_y)

	


	repeat
   		sync()
		
		button_pressed as string	
		button_pressed = check_button_press()   ////button_sleep(sleep_time)	  Experiment with check buttons press to not loop instance	
			
		if button_pressed = "Start" or button_pressed = "Settings" or button_pressed = "History"
			exit
		endif
	until exit_check
	
	if exit_check   // need to update logic so you'll exit to title and them have to exit main menu to end	
		End
	else
		gosub Title	
	endif	

return
	


Game:	
	game_state = "game"

	start_layer(button_layer, button_tracker)
	///add_sprite()	-- background mayabe gosub load board if we do three different kinds
		
	auto_play_button = add_sticky_button(game_button_left, game_button_up, menu_button_width, menu_button_height,"autoplay", "autoplayup.png", "autoplaydown.png", game_phase)
	exit_button = add_button(game_button_right, game_button_up, menu_button_width, menu_button_height, "exit", "exit_up.png", "exit_down.png", game_phase)		
		
	repeat 			 
			
		sync()				
		check_button_press()   ////button_sleep(sleep_time)	  Experiment with check buttons press to not loop instance	
		
		gosub Shuffle	//until exit triggered 
						
	until exit_check
	
		
	//delete_button_layer(1)    ---- moved to inside exit button
	//delete_image_phase(game_phase) // Delete menu images for game phase
	//sync()
return

Shuffle:  // Denotes on full deal out of the cards, one shoe

	game_state = "shuffle"
	
	card_total = 0   //reset to blank shuffle
	hi_lo_count = 0// start count counters(yeah I did that)
	ko_count = 0 
	hi_opt_i_count = 0
	hi_opt_ii_count = 0
	zen_count = 0
	omega_ii_count = 0
	red_seven_count = 0
	halves_count = 0		
	total_hands = 0
	
	cut = Random(Round(.55 * decks * 52), Round(.85 * decks * 52))	
	
	gosub Reset_drawn
		
	while card_total < cut and exit_check = 0
		
		check_button_press()   ////button_sleep(sleep_time)	  Experiment with check buttons press to not loop instance
		sync()
		
		gosub Hand	  		   		   		
	
	endwhile
		
 	gosub Load_history

return
	
Reset_drawn:  // possibly change to function, pass array as ref to save on global variables

	for card = 0 to 51
		if exit_check
			exit
		else
			check_button_press()
			sync()
		endif	
			
		current_drawn[card] = 0
	next card
return		
				
Hand:
	game_state = "hand"

 	///////////////////Problem with hand totals, problem with reaching cut

	blank_hand as player_hands
	start_layer(sprite_layer, sprite_tracker)

	total_hands = total_hands + 1
	
	
	for added_player = 0 to players
		if exit_check
			exit
		else
			check_button_press()
			sync()
		endif
		
		all_players_hands.insert(blank_hand)
		all_players_hands[added_player].hand_total = 0
		all_players_hands[added_player].hand_count = 0
		all_players_hands[added_player].hand_aces = 0
		all_players_hands[added_player].bust_status = 0
		all_players_hands[added_player].black_jack_status = 0
		all_players_hands[added_player].player_seat = i + 1
		all_players_hands[added_player].hit_status = 0
		 // might move to if statement if I want dealer/user auto mode to be static
		
		if added_player = players
			all_players_hands[added_player].auto_mode = auto_mode_selection[7] 
			all_players_hands[added_player].player_name = "Dealer"
			all_players_hands[added_player].win_status = " is under 22"			
		elseif added_player = user_seat - 1
			all_players_hands[added_player].auto_mode = auto_mode_selection[added_player] 
			all_players_hands[added_player].player_name = "User"
		else
			all_players_hands[added_player].auto_mode = auto_mode_selection[added_player] 
			all_players_hands[added_player].player_name = "Player " + str(added_player + 1)
		endif	
	next added_player

			
	deal_round as integer // distinguish first from second card dealt, trigger while end
	deal_round = 0	
	current_player as integer			
	current_player = 0	

	game_state = "deal"		
						
	while deal_round < 2 and exit_check = 0 // deal one card at a time twice for initial hand
	

		
		
		check_button_press()	
		sync()
		
		while current_player < players + 1 and exit_check = 0 //switch player and check which player it is, extra for dealer. 
			
			check_button_press()
			sync()		
					
			if exit_check = 0
				deal_history.insert(all_players_hands[current_player].player_name + "'s Hand, Card " + str(deal_round + 1))
				deal(current_player, hand_phase)	
				/// Need to check for split and implement, easiest way to reference first card drawn
				
			endif
			
			
			
			
			current_player = current_player + 1
			
		endwhile
		current_player = 0
		deal_round = deal_round + 1

	endwhile


	if all_players_hands[players].hand_total = 21 and exit_check = 0 // check dealer hand for natural black jack and trigger ending hand
		all_players_hands[players].black_jack_status = 1
		deal_history.insert(all_players_hands[players].player_name + " got natural Black Jack, hand ended.")
	endif
		
	for current_player = 0 to players - 1 // run through players hit/stay  ------ Need to indent and place inside if statement making sure exit wasn't pressed

		if exit_check
			exit
		else
			check_button_press() 
			sync()						
		endif

		if all_players_hands[current_player].hand_total = 21 and exit_check = 0     // Add to black_jack_status for eventual statistics, place before override to calculate whether or not hit_status happens
			deal_history.insert(all_players_hands[current_player].player_name + " got Black Jack")
			all_players_hands[current_player].black_jack_status = 1
			continue				
		endif
			
		if all_players_hands[players].black_jack_status and exit_check = 0 //override hand on dealer Black Jack
			continue	
		endif	


		if exit_check
			exit 
		elseif current_player = user_seat - 1  //player move
			
			if total_hands = 5
				total_hands = 0
				count_check()
			endif	
			
			check_button_press() 
			sync()
			
			//
			//gosub questions
			//


			//check splitting for user, user gets choice if split status then split, reset split status, possibly create temp hands outside of  all_players_hands, create pop up window
			// and when finished replace with bunched up pile of cards 
			
			while all_players_hands[current_player].hand_total < 21 and exit_check = 0
				
				check_button_press()
				sync() 

				if auto_play_button[1] and exit_check = 0
					
					game_state = "autoplay hit status"

					check_hit_status(current_player)
	
					if all_players_hands[current_player].hit_status and exit_check = 0
						deal(current_player, hand_phase)
						continue		
					else
						exit									
					endif																	
					
				elseif exit_check = 0
					
					game_state = "player hit status"
					
					start_layer(button_layer, button_tracker)
					hit_button = add_button(game_button_right, game_button_down, menu_button_width, menu_button_height, "hit", "hit_up.png", "hit_down.png", hit_phase)
					stay_button = add_button(game_button_left, game_button_down, menu_button_width, menu_button_height, "stay", "stay_up.png", "stay_down.png", hit_phase)
					check_button_press()
					sync()
										
					button_pressed = ""			
											
					while button_pressed = "" and exit_check = 0						
						
						button_pressed = check_button_press() //button_sleep(sleep_time)	
						sync()

					endwhile 

					
					
					
					
					if all_players_hands[current_player].hit_status and exit_check = 0
						deal_history.insert("User hits")
						deal(current_player, hand_phase)
						continue
					elseif exit_check = 0
						deal_history.insert("User stays")	
						exit
					else
						exit
					endif
						
				endif
   	 									
			endwhile												
																									
		elseif exit_check = 0   // non player go 

			if exit_check = 0
				
				game_state = "ai hit status"				

				check_hit_status(current_player)	
			endif

			while all_players_hands[current_player].hit_status and exit_check = 0    //add if exit, auto pressed possibly, in and outside while statement
				
				check_button_press()   ////button_sleep(sleep_time)	  Experiment with check buttons press to not loop instance	
				sync()
			
				if exit_check = 0
					deal(current_player, hand_phase)
					
					check_hit_status(current_player)
				endif
			
			endwhile
			
		endif		
	next current_player
	
	if exit_check = 0
		game_state = "dealer hit status"
		
		// enter in dealer move, unveal card, hide flipped card
		SetSpriteVisible(hidden_dealer_card, 0)		
		SetSpriteVisible(flipped_dealer_card, 1) // flip dealer card
		check_button_press()
		sync()
	
		check_hit_status(players)  // check dealer hit status
	
		while all_players_hands[players].hit_status and exit_check = 0
			
			check_button_press()   ////button_sleep(sleep_time)	  Experiment with check buttons press to not loop instance	
			sync()
			
			deal(players, hand_phase)
			
			check_hit_status(players)
		endwhile	
	
		if all_players_hands[players].hand_total > 21 and exit_check = 0
			all_players_hands[players].win_status = " busted"
			deal_history.insert(all_players_hands[players].player_name + all_players_hands[players].win_status)
		endif	
	endif
	
	
	/// switch if and for to combo while
	
	game_state = "win check"
	
	for current_player = 0 to players - 1   // check win, need to edit so it displays on top of original two cards in the center.
		
	
	
		check_button_press()
		sync() 
	
		if exit_check
			exit
		endif
						
		shifted_placement as integer
		shifted_placement = current_player + floor((7 - players)/2) // shifted place to calculate players to center of table for aethstetic 
		x as float
		x = center_x * cos(card_angles[shifted_placement]) + center_x // Add center_x to translate from origin to screen center
		y as float
		y = ellipses_y * sin(card_angles[shifted_placement]) + center_y // Negative because screen y is flipped. Add center_y to translate from origin to screen center

	
		if all_players_hands[current_player].hand_total > 21
/*lose*/	add_sprite(x, y, card_width, card_height, card_angles[shifted_placement] + 90, "lose.png", hand_phase)  // switch in busted. png
			all_players_hands[current_player].win_status = " busted"
		elseif all_players_hands[players].hand_total > 21 or all_players_hands[current_player].hand_total > all_players_hands[players].hand_total //if dealer busts or has less than player
/*win*/ 	add_sprite(x, y, card_width, card_height, card_angles[shifted_placement] + 90, "win.png", hand_phase)
			all_players_hands[current_player].win_status =  " wins"
		elseif all_players_hands[current_player].hand_total = all_players_hands[players].hand_total
/*tie*/		add_sprite(x, y, card_width, card_height, card_angles[shifted_placement] + 90, "tie.png", hand_phase)
			all_players_hands[current_player].win_status =  " ties"
		else
/*lose*/	add_sprite(x, y, card_width, card_height, card_angles[shifted_placement] + 90, "lose.png", hand_phase)
			all_players_hands[current_player].win_status = " loses"
		endif		
		
		check_button_press() 
		sync()
		
		deal_history.insert(all_players_hands[current_player].player_name + all_players_hands[current_player].win_status)
		
		button_sleep(2 * sleep_time)  								
																							
	next current_player


	button_sleep(8 * sleep_time) //definitely switch to timer function so buttons are pushable
	
	all_players_hands_length as integer
	all_players_hands_length = all_players_hands.length
	for removed_hand = 0 to all_players_hands_length
		
		check_button_press()
		sync() 
		
		all_players_hands.remove()
	next removed_hand	
		//add win statistic for each, only total player, dealer, and total ai players together
			

	delete_sprite_layer(1)	
	delete_image_phase(hand_phase)					
return		

	
		
/////////FUNCTIONS///////////////////
				
						
function rotate_left_string(input_array ref as string[])  // rotate any size array with right most value being chopped of and being moved to the left
	input_array.insert(input_array[input_array.length - 1], 0)
	input_array.remove()  // may need to modify ref to copy function if it doesn't compile, one line up
endfunction
	
function rotate_right_string(input_array ref as string[])  // rotate any size afrray with right most value being chopped of and being moved to the left
	input_array.insert(input_array[0])   // may need to modify ref to copy function if it doesn't compile, one line up
	input_array.remove(0)
endfunction
	
//----start/end layers
function start_layer(layer ref as integer[], tracker as integer)
	layer.insert(tracker)
endfunction

function delete_image_phase(image_phase ref as integer[])
	
	image_phase_length = image_phase.length 
	
	for removed_image = image_phase_length to 0 step -1
		
		check_button_press()
		sync() 
		
		DeleteImage(image_phase[image_phase.length])
		image_phase.remove()
	next removed_image

endfunction
			
function delete_button_layer(layers_removed as integer)
	
	buttons_removed as integer
					
	for removed_button = button_layer[button_layer.length - layers_removed + 1] + 1 to button_tracker
		
  		DeleteVirtualButton(removed_button)
  		button_name.remove()
  		buttons_removed = buttons_removed + 1
  	next removed_button
  	
  	button_tracker = button_tracker - buttons_removed
  	
  	for removed_layer = 1 to layers_removed
  		
  		button_layer.remove()
	next removed_layer
	
	sync()
endfunction
	
function delete_sprite_layer(layers_removed as integer)
	
	sprites_removed as integer
	sprites_removed = 0

    for removed_sprite = sprite_layer[sprite_layer.length -layers_removed + 1] + 1 to sprite_tracker
    	
    	check_button_press()
    	sync() 
    	
  		DeleteSprite(removed_sprite)
  		sprites_removed = sprites_removed + 1
  	next removed_sprite

	sprite_tracker = sprite_tracker - sprites_removed

	for removed_layer = 1 to layers_removed
		
		sprite_layer.remove()
		
		check_button_press()
		sync() 
		
  		
	next removed_layer 	
	
endfunction	

function delete_text_layer(layers_removed as integer)
	
	removed_texts as integer
	removed_texts = 0

    for text_removed = text_layer[text_layer.length - layers_removed + 1] + 1 to text_tracker 
    	
  		DeleteText(text_removed)
  		removed_texts = removed_texts + 1
  	next text_removed
  	
  	text_tracker = text_tracker - removed_texts

	for removed_layer = 1 to layers_removed
		
  		text_layer.remove()
	next removed_layer 	
	sync()
endfunction	


//-----manipulate buttons and sprites
	
function add_button(button_x as float, button_y as float, button_width as float, button_height as float, button_text as string, button_image_up as string, button_image_down as string, image_phase ref as integer[])

	button_tracker = button_tracker + 1

	AddVirtualButton(button_tracker, button_x, button_y, button_width)
	SetVirtualButtonSize(button_tracker, button_width, button_height)
	button_name.insert(button_text)  
	
	image_holder as integer
	image_holder = LoadImage(button_image_up)
	image_phase.insert(image_holder)
	SetVirtualButtonImageUp(button_tracker, image_holder)
	
	image_holder = LoadImage(button_image_down)
	image_phase.insert(image_holder)
	SetVirtualButtonImageDown(button_tracker,image_holder)
endfunction button_tracker
	
	
function add_sticky_button(button_x as float, button_y as float, button_width as float, button_height as float, button_text as string, button_image_up as string, button_image_down as string, image_phase ref as integer[])
	dim sticky_button_specs[4] as integer
	button_tracker = button_tracker + 1
	sticky_button_specs[0] = button_tracker

	AddVirtualButton(button_tracker, button_x, button_y, button_height)
	SetVirtualButtonSize(button_tracker, button_width, button_height)
	button_name.insert(button_text)

	image_phase.insert(LoadImage(button_image_up))
	sticky_button_specs[2] = image_phase[image_phase.length]
	SetVirtualButtonImageUp(button_tracker, image_phase[image_phase.length])
	image_phase.insert(LoadImage(button_image_down))
	sticky_button_specs[3] = image_phase[image_phase.length]
	SetVirtualButtonImageDown(button_tracker, image_phase[image_phase.length])
endfunction	sticky_button_specs
	
	
function add_text(text as string, text_x as float, text_y as float)
	text_tracker = text_tracker + 1
	
	CreateText(text_tracker, text)
	SetTextPosition(text_tracker, text_x, text_y)
	SetTextAlignment(text_tracker, 1)
	SetTextSize(text_tracker, 60)
endfunction	text_tracker
	
	
function press_sticky_button(sticky_button ref as integer[])

	if sticky_button[1] //toggle state
		sticky_button[1] = 0
	else
		sticky_button[1] = 1
	endif		
	
	if sticky_button[1]
		SetVirtualButtonImageUp(sticky_button[0], sticky_button[3])
		SetVirtualButtonImageDown(sticky_button[0], sticky_button[2])
	else
		SetVirtualButtonImageUp(sticky_button[0], sticky_button[2])
		SetVirtualButtonImageDown(sticky_button[0], sticky_button[3])
	endif
	sync()	
endfunction
	
	
function add_sprite(sprite_x as float, sprite_y as float, sprite_width as float, sprite_height as float, sprite_angle as float, sprite_image as string, image_phase ref as integer[])
	sprite_tracker = sprite_tracker + 1
	// Load the image
	image_phase.insert(LoadImage(sprite_image))
	// Create the sprite using the loaded image
	CreateSprite(sprite_tracker, image_phase[image_phase.length])
	// Change the sprite's position, size, angle, etc., as needed
	SetSpritePosition(sprite_tracker, sprite_x, sprite_y)
	SetSpriteSize(sprite_tracker, sprite_width, sprite_height)
	SetSpriteAngle(sprite_tracker, sprite_angle)
endfunction sprite_tracker


///	Call button functions and check button press


function button_function(button_text as string)
	if button_text = "left arrow"
		
		if players = 1  //add all buttons autoplay
			players = 7		
		else	// delete autobutton = players
			players = players - 1	
		endif
			
		if players = 1
			SetTextString(player_text, str(players) + " Player")
		else
			SetTextString(player_text, str(players) + " Players")			
		endif
			
		if user_seat > players
  			user_seat = players
  			SetTextString(seat_text, "Seat " + str(user_seat))	
   		endif		
		exitfunction
				
	endif	
	
	if button_text = "right arrow"
	
		if players = 7
			players = 1
			user_seat = 1
			SetTextString(seat_text, "Seat " + str(user_seat))
			SetTextString(player_text, str(players) + " Player")
		else
			players = players + 1
			SetTextString(player_text, str(players) + " Players")				
		endif	
		exitfunction
						
	endif	

	if button_text = "left seat"
	
		if user_seat = 1
			user_seat = players
		else
			user_seat = user_seat - 1 
		endif	
		SetTextString(seat_text, "Seat " + str(user_seat))		
		exitfunction
						
	endif	
		
	if button_text = "right seat"

		if user_seat = players
			user_seat = 1
		else
			user_seat = user_seat + 1	
		endif
		SetTextString(seat_text, "Seat " + str(user_seat))	   		
		exitfunction
								
	endif	
	
	if button_text = "left decks"

		if decks = 1
			decks = 8
			SetTextString(deck_text, "Vegas Elite")	
		elseif decks = 6
			decks = 1
			SetTextString(deck_text, "Home Play")	
		else 
				decks = 6
			SetTextString(deck_text, "Vegas Std")	
		endif
		exitfunction
			
	endif	
	
	if button_text = "right decks"

		if decks = 1
			decks = 6
			SetTextString(deck_text, "Vegas Std")
		elseif decks = 6
			decks = 8
			SetTextString(deck_text, "Vegas Elite")
		else 
			decks = 1
			SetTextString(deck_text, "Home Play")
		endif		
		exitfunction
		
	endif	
	
	if button_text = "left style"
		
		rotate_left_string(style)
		SetTextString(style_text, style[0])		
		exitfunction
				
	endif	
	
	if button_text = "right style"
		
		rotate_right_string(style)
		SetTextString(style_text, style[0])		
		exitfunction
		
	endif	
	
	if button_text = "left method"
		
		rotate_left_string(method)
		SetTextString(method_text, method[0]) 		
		exitfunction
		
	endif	
	
	if button_text = "right method"

		rotate_right_string(method)
		SetTextString(method_text, method[0]) 		
		exitfunction
								
	endif	
	
	if button_text = "Settings"
		
		delete_button_layer(1)
		delete_text_layer(1)	
		delete_image_phase(title_phase)	
		gosub Settings
		exit_check = 0
		exitfunction
		
	endif	
	
	if button_text = "Start"

		
		delete_button_layer(1)
		delete_text_layer(1)
		delete_image_phase(title_phase)				
		gosub Game
		exit_check = 0		
		exitfunction
		
	endif	
	
	if button_text = "History"
		
		delete_button_layer(1)
		delete_text_layer(1)
		delete_image_phase(title_phase)	
		gosub History
		exit_check = 0  
		exitfunction 		
		
	endif	
	
	if button_text = "autoplay"
		
		press_sticky_button(auto_play_button)
		if game_state = "player hit status"
			delete_button_layer(1)
			delete_image_phase(hit_phase)
		endif
		
		exitfunction
				
	endif	
	
	if button_text = "exit"   // may update to var that keeps track of current phase
		
		exit_check = 1
		
		if game_state = "player hit status"
			delete_button_layer(2)
			delete_image_phase(hit_phase)
			delete_image_phase(game_phase)
		elseif game_state = "title"
			delete_button_layer(1)
			delete_text_layer(1)
			delete_image_phase(title_phase)
		else			
			delete_button_layer(1)
			delete_image_phase(game_phase)
		endif
		
		

		exitfunction		
		
	endif	
	
	if button_text = "hit"
				
		all_players_hands[user_seat - 1].hit_status = 1
		hit_button = 0
		stay_button = 0	
		delete_button_layer(1)
		delete_image_phase(hit_phase)
		
		exitfunction	
	endif	
	
	if button_text = "stay"
		
		all_players_hands[user_seat - 1].hit_status = 0
		hit_button = 0
		stay_button = 0	
		delete_button_layer(1)
		delete_image_phase(hit_phase)	
		exitfunction
	endif	
	
	

endfunction


function check_button_press()
	button_pressed as string
	button_pressed = ""
	
	for button_id = 1 to button_tracker
	
		if GetVirtualButtonPressed(button_id) and exit_check = 0
			button_pressed = button_name[button_id - 1]
			button_function(button_pressed)	
			sync() 
			exitfunction button_pressed  // an exit may suffice but exitfunction mau be better, run less program
		endif
		
	next button_id	
	
endfunction button_pressed


function button_sleep(time as float)
	
    start_time = Timer()
	button_pressed as string
	button_pressed = ""
		
	while Timer() - start_time < time and button_pressed = ""
		button_pressed = check_button_press()
		sync() 
    endwhile

endfunction button_pressed


///Card Game Functions	
			
function check_hit_status(current_player as integer)

	select all_players_hands[current_player].auto_mode  // may add this attribute to type current_hand
			
		case "Standard"		// case for each style
	
			if all_players_hands[current_player].hand_total < 16
				deal_history.insert(all_players_hands[current_player].player_name + " hits")
				all_players_hands[current_player].hit_status = 1
			else
				deal_history.insert(all_players_hands[current_player].player_name + " stays")
				all_players_hands[current_player].hit_status = 0
			endif

		endcase 
					
		case "Conservative"
		
			if all_players_hands[current_player].hand_total < 14
				deal_history.insert(all_players_hands[current_player].player_name + " hits")
				all_players_hands[current_player].hit_status = 1
			else
				deal_history.insert(all_players_hands[current_player].player_name + " stays")
				all_players_hands[current_player].hit_status = 0
			endif
		
		endcase
				
		case "Aggressive"
			
			if all_players_hands[current_player].hand_total < 17
				deal_history.insert(all_players_hands[current_player].player_name + " hits")
				all_players_hands[current_player].hit_status = 1
			else
				deal_history.insert(all_players_hands[current_player].player_name + " stays")
				all_players_hands[current_player].hit_status = 0
			endif	
		
		endcase
			
		case "Sporadic"

			all_players_hands[current_player].hit_status = Random(0, 1)

			if all_players_hands[current_player].hit_status
				deal_history.insert(all_players_hands[current_player].player_name + " hits")
			else
				deal_history.insert(all_players_hands[current_player].player_name + " stays")
			endif
			
		endcase					

	endselect
			
endfunction
		
	
function Deal(current_player as integer, image_phase ref as integer[])   //need to add on current hand parameter
		
	drawn_suit as integer
	drawn_suit = Random(1, 4)  //draw card    
	drawn_value as integer
	drawn_value = Random(1,13)	 
	
	draw_override as integer  // override random selection to find nearest available card
	draw_override = 0
	
	while current_drawn[drawn_suit * drawn_value - 1] = decks and draw_override < 11 and exit_check = 0
		
		draw_override = draw_override + 1 
		drawn_suit = Random(1, 4)  //redraw card due to exceeding the deck limit per unique card 
		drawn_value = Random(1,13)	
		
	endwhile
	
	if draw_override = 11   //shift card due to exceeding random pull deck limit per unique card 
		
		shifter as integer
		shifter = random( 0 , 1)
		
		draw_override = 0
		
		while current_drawn[drawn_suit * drawn_value - 1] = decks and draw_override < 52 and exit_check = 0

			draw_override = draw_override + 1

			if drawn_value + (-1 ^ shifter)  = 0		
				drawn_value = 13	
				if drawn_suit = 1
					drawn_suit = 4
				else
					drawn_suit = drawn_suit - 1	
				endif				
			elseif drawn_value + (-1 ^ shifter)  = 14
			 		drawn_value = 1
			 		if drawn_suit  = 4
			 			drawn_suit = 1
			 		else
			 			drawn_suit = drawn_suit + 1
			 		endif				
			else
				drawn_value = drawn_value + (-1 ^ shifter)
			endif	 
			
		endwhile	
		
		if draw_override = 52
			gosub Reset_drawn
		endif	
		
	endif	

	current_drawn[drawn_suit * drawn_value - 1] = current_drawn[drawn_suit * drawn_value - 1] + 1	
	card_total = card_total + 1 		

		//store card in history 1-spade, 2-diamonds, 3-clubs, 4-hearts
	suit as string
	current_image as string
	
		
	Select drawn_suit 
		case 1:
			suit = "Spades"
			current_image = str(decks) + "s" + str(drawn_value) + ".png"
		endcase
		
		case 2:
			suit = "Diamonds"
			current_image = str(decks) + "d" + str(drawn_value) + ".png"
			red_seven_count = red_seven_count + 1
		endcase

		case 3:
			suit = "Clubs"
			current_image = str(decks) + "c" + str(drawn_value) + ".png"
		endcase
		
		case 4:
			suit = "Hearts"
			current_image = str(decks) + "h" + str(drawn_value) + ".png"
			red_seven_count = red_seven_count + 1
		endcase
	endselect
			
		
	all_players_hands[current_player].hand_count = all_players_hands[current_player].hand_count + 1
		
	select drawn_value
		case 1
			drawn_value = 1 
			deal_history.insert("Ace of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 11
			all_players_hands[current_player].hand_aces = all_players_hands[current_player].hand_aces + 1
			hi_lo_count = hi_lo_count - 1			
			ko_count = ko_count - 1 
			hi_opt_i_count = hi_opt_i_count - 1
			hi_opt_ii_count = hi_opt_ii_count - 2
			zen_count = zen_count - 2
			omega_ii_count = omega_ii_count - 2
			halves_count = halves_count - 1
		endcase
		
		case 2
			deal_history.insert("Two of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 2
			hi_lo_count = hi_lo_count + 1			
			ko_count = ko_count + 1 
			hi_opt_i_count = hi_opt_i_count + 1
			hi_opt_ii_count = hi_opt_ii_count + 1
			zen_count = zen_count + 1
			omega_ii_count = omega_ii_count + 1
			halves_count = halves_count + .5
		endcase
		
		case 3
			deal_history.insert("Three of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 3
			hi_lo_count = hi_lo_count + 1			
			ko_count = ko_count + 1 
			hi_opt_i_count = hi_opt_i_count + 1
			hi_opt_ii_count = hi_opt_ii_count + 1
			zen_count = zen_count + 1
			omega_ii_count = omega_ii_count + 1
			halves_count = halves_count + 1
		endcase
		
		case 4
			deal_history.insert("Four of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 4
			hi_lo_count = hi_lo_count + 1
			ko_count = ko_count + 1
			hi_opt_i_count = hi_opt_i_count + 2
			hi_opt_ii_count = hi_opt_ii_count + 2
			zen_count = zen_count + 2
			omega_ii_count = omega_ii_count + 2
			halves_count = halves_count + 1
		endcase
		
		case 5
			deal_history.insert("Five of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 5
			hi_lo_count = hi_lo_count + 1
			ko_count = ko_count + 1
			hi_opt_i_count = hi_opt_i_count + 2
			hi_opt_ii_count = hi_opt_ii_count + 2
			zen_count = zen_count + 2
			omega_ii_count = omega_ii_count + 2
			halves_count = halves_count + 1.5
		endcase
		
		case 6
			deal_history.insert("Six of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 6
			hi_lo_count = hi_lo_count + 1
			ko_count = ko_count + 1
			hi_opt_i_count = hi_opt_i_count + 1
			hi_opt_ii_count = hi_opt_ii_count + 2
			zen_count = zen_count + 2
			omega_ii_count = omega_ii_count + 1.5
			halves_count = halves_count + 1
		endcase
		
		case 7
			deal_history.insert("Seven of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 7
			//hi_lo_count zero value
			ko_count = ko_count - 1
			//hi_opt_i_count zero value
			hi_opt_ii_count = hi_opt_ii_count + 1
			zen_count = zen_count + 1
			omega_ii_count = omega_ii_count + 2
			halves_count = halves_count + .5
		endcase

		case 8
			deal_history.insert("Eight of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 8
			//hi_lo_count zero count
			//ko_count zero count
			//hi_opt_i_count zero count
			//hi_opt_ii_count zero count
			//zen_count zero count
			//omega_ii_count zero count
			//halves_count zero count
		endcase
		
		case 9
			deal_history.insert("Nine of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 9
			//hi_lo_count zero count
			//ko_count zero count
			//hi_opt_i_count zero count
			//hi_opt_ii_count zero count
			//zen_count zero count
			//omega_ii_count zero count
			halves_count = halves_count -  .5
		endcase
		
		case 10
			deal_history.insert("Ten of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 10
			hi_lo_count = hi_lo_count - 1
			ko_count = ko_count - 1
			hi_opt_i_count = hi_opt_i_count - 1
			hi_opt_ii_count = hi_opt_ii_count - 2
			zen_count = zen_count - 2
			omega_ii_count = omega_ii_count - 2
			halves_count = halves_count - 1
		endcase
							
		case 11 
			deal_history.insert("Jack of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 10
			hi_lo_count = hi_lo_count - 1
			ko_count = ko_count - 1
			hi_opt_i_count = hi_opt_i_count - 1
			hi_opt_ii_count = hi_opt_ii_count - 2
			zen_count = zen_count - 2
			omega_ii_count = omega_ii_count - 2
			halves_count = halves_count - 1			
		endcase
		
		case 12
			deal_history.insert("Queen of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 10
			hi_lo_count = hi_lo_count - 1
			ko_count = ko_count - 1
			hi_opt_i_count = hi_opt_i_count - 1
			hi_opt_ii_count = hi_opt_ii_count - 2
			zen_count = zen_count - 2
			omega_ii_count = omega_ii_count - 2
			halves_count = halves_count - 1
		endcase
			
		case 13	  
			deal_history.insert("King of " + suit)
			all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total + 10
			hi_lo_count = hi_lo_count - 1
			ko_count = ko_count - 1
			hi_opt_i_count = hi_opt_i_count - 1
			hi_opt_ii_count = hi_opt_ii_count - 2
			zen_count = zen_count - 2
			omega_ii_count = omega_ii_count - 2
			halves_count = halves_count - 1		
		endcase
		
	endselect					

	while all_players_hands[current_player].hand_total > 21 and all_players_hands[current_player].hand_aces
		
		check_button_press()
		sync()
		
		all_players_hands[current_player].hand_aces = all_players_hands[current_player].hand_aces - 1
		all_players_hands[current_player].hand_total = all_players_hands[current_player].hand_total - 10
	endwhile	

		//Render card on board  
	
		// need to calculate sprite angle
		//need to learn physics to toss cards, and toss from dealer spot to spot
		// need to add modifiers to calculate out 11 card deal, or 2 inital and 9 dealt cards
		// Set sprite, contains a modifier **floor((7 - players[0])/2)** which modifiese the players to the middle of the board for better aethstetic
	
	shifted_placement as integer
	if current_player < players
		shifted_placement = current_player + floor((7 - players)/2) // shifted place to calculate players to center of table for aethstetic 
	else
		shifted_placement = 7
	endif
	
	x as float
	x = center_x * cos(card_angles[shifted_placement]) + center_x // Add center_x to translate from origin to screen center
    y as float
    y = ellipses_y * sin(card_angles[shifted_placement]) + center_y // Negative because screen y is flipped. Add center_y to translate from origin to screen center
	dealer_y as float
	dealer_y = -ellipses_y * sin(card_angles[shifted_placement]) + center_y
	stagger as float
	stagger = .25 * card_width * (-1 ^ all_players_hands[current_player].hand_count) //shift cards left or right based of card number
	staggered_x as float
	staggered_x = x + stagger * cos(card_angles[shifted_placement] + 90) // add stagger
	staggered_y as float
	staggered_y = y + stagger * sin(card_angles[shifted_placement] + 90)
	delta_x as float
	delta_x = (all_players_hands[current_player].hand_count - 1) * (.5 * card_height) * cos(card_angles[shifted_placement])  //vertical in relation to the card which is at an angle
	delta_y as float
	delta_y = (all_players_hands[current_player].hand_count - 1) * (.5 * card_height) * sin(card_angles[shifted_placement])
	card_x as float
	card_x = staggered_x - delta_x  // add the vertical shift
	card_y as float
	card_y = staggered_y - delta_y
	dealer_card_y as float
	dealer_card_y = dealer_y + delta_y
	
	
	if current_player < players
		add_sprite(card_x, card_y, card_width, card_height, card_angles[shifted_placement] + 90, current_image, image_phase)
	else
		if all_players_hands[current_player].hand_count = 1
			deal_history.insert("Hidden Dealer Card") //dealer hidden card displayed
			
			flipped_dealer_card = add_sprite(card_x, dealer_card_y, card_width, card_height, 0, current_image, image_phase)//deal to dealer spot
			SetSpriteVisible(flipped_dealer_card, 0)					
					
			hidden_dealer_card = add_sprite(staggered_x, dealer_y, card_width, card_height, 90, str(decks) + "_card_back.png", hand_phase) // hide card drawn
			SetSpriteVisible(hidden_dealer_card, 1)

		else
			add_sprite(card_x, dealer_card_y, card_width, card_height, 0, current_image, image_phase)//deal to dealer spot
		endif	
	
	endif 
	
	check_button_press()
	sync()
	button_sleep(sleep_time * 10) // slow up deal, possibly switch to changeable variable, definitely switch to timer function so buttons are pushable
endfunction 

function count_check()
	print("Count Check")
	sync()
	sleep(2000)
	select method[0]
		case "Hi-Lo"
			print("Total Count is: " + str(card_total) + "/|\Hi-Lo Count is: " + str(hi_lo_count))
		endcase
		
		case "KO"
			print("Total Count is: " + str(card_total) + "/|\KO Count is: " + str(ko_count))
		endcase
		
		case "Hi-Opt I"
			print("Total Count is: " + str(card_total) + "/|\Hi-opt I Count is: " + str(hi_opt_i_count))
		endcase
		
		case "Hi-Opt II"
			print("Total Count is: " + str(card_total) + "/|\Hi-opt II Count is: " + str(hi_opt_ii_count))
		endcase
		
		case "Zen"
			print("Total Count is: " + str(card_total) + "/|\Zen Count is: " + str(zen_count))
		endcase
		
		case "Omega II"
			print("Total Count is: " + str(card_total) + "/|\Hi-Lo Count is: " + str(omega_ii_count))		
		endcase
		
		case "Red 7"
			print("Total Count is: " + str(card_total) + "/|\Red 7 Count is: " + str(red_seven_count))		
		endcase
		
		case "Halves"
			print("Total Count is: " + str(card_total) + "/|\Halves Count is: " + str(halves_count))
		endcase	
	endselect	
	sync()	
	sleep(2000)	
		
endfunction
Load_history:  //write history to file	  ---- NEED second history for stats for game 
//Need to edit how cards and players loaded to history so they are easily , may need to switch to numerical storage and translatte to strings when reading
	
	file_id as integer
	file_id = OpenToWrite( "history.txt", 1 ) // The second parameter (1) means the file is opened in append mode.
	
	for i = 0 to deal_history.length
		WriteLine( file_id, deal_history[i] )
	next i
	CloseFile( file_id )
return
																																						
Settings:
	
return
	
History:
	print("you're in the history routine")
	sync()
	sleep(2000)
return
	
Load_board:  /// NEED TO CHANGE TO FIT SPRITE LAYER
	// Declare a variable for the board filename
	boardFileName as string

	select decks // Load board based on the number of decks in the shuffle
        	case 1: // Set the filename for the easy game board  
       		boardFileName = "easy_board.png"
       		endcase
       		
        	case 6: // Set the filename for the medium game board
        		boardFileName = "med_board.png"
        	endcase
        	
        	case 8:  // Set the filename for the hard game board
			boardFileName = "hard_board.png"
			endcase
	endselect 

// Load the selected board as a sprite and set it as a backdrop
	boardID = LoadImage(boardFileName) // Load the image
	CreateSprite(1, boardID)  // Create a sprite with this image
	SetSpriteSize(1, 100, 100)  // Set sprite to full screen size
return
    
Load_game:
/// may need to be moved to beginning of program
return