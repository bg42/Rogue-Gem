# This class holds the methods responsible for generating and displaying the grid.
class Grid 

	# The grid is an 18x80 rectangle, with 2 lines for messages on top and 3 message lines on bottom.
	def initialize 
		@@v_row = []
		18.times { @@v_row << [] }  
		@@v_row.each do
		|x|  80.times { x << "." } 
		end
		@@message_box = []
	end	

	# This method prints the grid, as well as the message box. If the message box is empty, the box is filled with a newline
	def output
		if @@message_box.length < 5 
			(5 - @@message_box.length).times { @@message_box << "\n" }
		end
		puts @@message_box[0] 
		puts @@message_box[1]
		puts @@v_row.join 
		puts @@message_box[2]
		puts @@message_box[3]
		puts @@message_box[4]
	end 
	
	# Regenerates the grid with a new background. This method can be expanded or customized to produce more complicated backgrounds.
	def re_init(y)
		@@v_row.clear
		18.times { @@v_row << [] }  
		@@v_row.each do
		|x|  80.times { x << "#{y}" } 
		end
	end 
	
	# Allows access to message box from outside the class.
	def message_box
		@@message_box 
	end 
	
end 

# All game-world objects inherit from this class.
class Sprite < Grid 
	
	def initialize  
		@position = ""
	end 	
	
	# This method changes the character at point x, y to the value of z. Axes start at 0 in numbering.
	def fly(x,y,z) #remeber these start with 0 in numbering!! 
		@@v_row[y][x].sub!("#{@@v_row[y][x]}", "#{z}") #find the point, and then replace with object's symbol. #FIXME Fix'd 12/16
		@position = x, y
	end	
	
	# Returns location as array.
	def location?
		@position
	end	
end

# This method generates the player character, and has methods for their movement.
class Player < Sprite 
	attr_accessor :name, :hit_points, :level, :inventory
	
	# Establishes values for the player's symbol, name, race, inventory, HP, position, and other common fantasy RPG elements. 
	def initialize 
		@floor = "."
		@name = ""
		@symbol = "" 
		@race = ""
		@inventory = [] 
		@hit_points = 0 
		@position = "" 
		@level = 1 
	end
	
    # This method allows the user to move the player by only pressing the WASD keys. If it detects the player is at the edge of the map, an exit sequence is called.	
	def walk  
		case Win32API.new("crtdll", "_getch", [], "L").Call.chr.downcase
		when '~' #~ is exit key
			exit 
		when 'w'  		
			if @position[1] == 0
				exit_grid 	
			else
				fly(@position[0], @position[1], "#{@floor}")									
				fly(@position[0], @position[1] - 1, "#{@symbol}")
			end 
		when 's'	
			if @position[1] == 17	
				exit_grid 									
			else 
				fly(@position[0], @position[1], "#{@floor}")
				fly(@position[0], @position[1] + 1, "#{@symbol}")
			end
		when 'a' 	
		    if @position[0] == 0
				exit_grid
			else
				fly(@position[0], @position[1], "#{@floor}") 
				fly(@position[0] - 1, @position[1], "#{@symbol}")
			end
		when 'd' 	
			if @position[0] == 79	
				exit_grid 	
			else
				fly(@position[0], @position[1], "#{@floor}")
				fly(@position[0] + 1, @position[1], "#{@symbol}")	
			end
		end
	end
	
	# This method controls the player's movement to another map, and calls the generation of the new map.
	def exit_grid 
		@@message_box[0] = "Are you sure you want to leave this area? [Y]es/[N]o" #FIXME #FIXME
		@@message_box[1] = "\n"
		#--
		#So newest messages are at beginning 
		#show grid with new messages
		#++
		output
		@@message_box[0] = "Message Here!" 
		@@message_box[1] = "Message Here! "
		if Win32API.new("crtdll", "_getch", [], "L").Call.chr.downcase == 'y'  #If they decide to exit
			@floor = "#{rand(33..63).chr}"
			re_init(@floor) #change floor tile
			fly(@position[0], @position[1], "#{@floor}") 
			fly((@position[0] - 5).abs, (@position[1] - 15).abs, "#{@symbol}")	
		end 
	end 
	
	# Introduction for new character, can be changed to fit other games.	
	def spawn 
		puts "Greetings, adventurer! What is your name?" 
		@name = gets.chomp
		puts "What race will you be? [E]lven [H]uman [D]warven"
		case gets.chomp.downcase 
			when "d" 
				@race = "Dwarf" 
				@inventory = ["Axe", "Plate Armor"]
				@hit_points = 14
				@symbol = "@"
			when "h" 
				@race = "Human"
				@inventory = ["Mace", "Chainmail"]
				@hit_points = 12 
				@symbol = "@"
			when "e" 
				@race = "Elf" 
				@inventory = ["Sword", "Scale Armor"]
				@hit_points = 10 
				@symbol = "@"
		end
		fly(5, 5, @symbol)
	end	
end 