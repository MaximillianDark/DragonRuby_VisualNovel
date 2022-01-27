$gtk.reset
#$:.unshift(File.expand_path("mygame/nokogiri/lib"))
#require 'mygame/nokogiri'
#$:.unshift(File.expand_path("mygame/rubyzip/lib"))
#require 'mygame/rubyzip'
#$:.unshift(File.expand_path("mygame/rubyXL/lib"))
#require 'mygame/rubyXL/lib/rubyXL'

class Game 

#current way of initializing the different playable characters. Can be edited by the code/player choices.
#Needs to be saved to save files between sessions
def playerList
	@player1 ||= {"name" => "Ashe", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	@player2 ||= {"name" => "Bob", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	@player3 ||= {"name" => "Cait", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	@player4 ||= {"name" => "Donna", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	@player5 ||= {"name" => "Ei", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	@player6 ||= {"name" => "Freddy", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
end

def screenLocation
	@sLLeft ||= {"name" => "Left", "x" => 100, "y" => 10}
	@sLRight ||= {"name" => "Left", "x" => 100, "y" => 10}
	@sLCenter ||= {"name" => "Left", "x" => 100, "y" => 10}
end

def gameConfig
	@max_character_length = 80
end
#user settings, also saved between sessions
def gameSettings
	@gameMode ||= 1 #No Fight Mode
	@gameLang ||= 0 #English
	@gameLangAudio ||= 0#English, only flesh out in including differnt language voicelines
end

#method which pulls the lines of the dialouge into the game from textfile
def splitTxtFiles args
	args.split("\n")#new sets on new lines
                     .reject { |line| line.start_with?('#') || line.split(' ').length == 0 } # Strip out simple comments and blank lines
                     .map { |line| line.split('#')[0] } # Strip out end of line comments
                     .map { |line| line.split("\t") } # Tokenize by splitting on tabs
end

#setup
def initialize args
	@args = args
	@args.outputs.background_color = [0, 0, 0, 255]
	@gameover = false
	@ending = false
	playerList 
	gameSettings
	gameConfig
	
	#variables for printing dialouge
	@talking = true
	@talkingpoint = 0
	@worksheet
	@worksheet_line = 5
end 
 



#uses splitTxtFiles to fill worksheet variable
#filename will need to change to make new Dialogue happen
def rpgInfo
	@worksheet = splitTxtFiles($gtk.read_file('/data/English/Dialogue.txt')).to_a
end

#renders Dialogue or worksheet intput
#args will be identifier for what conversation is going to happen
def	renderTalk

	#if "#{args.state.worksheet[0][1]}" != "jump"
		#name
		@args.outputs.labels  << [25, 234, "#{@player1["name"]}" , 2, 255, 255, 255, 255]
		#args.outputs.labels  << [25, 228, "#{playerList.(args.state.worksheet[0][0]).name}" , 2, 255, 255, 255, 255]
		###image, if included
		if @worksheet[@talkingpoint][2] != "none"
			@args.outputs.sprites << [10, 10, 180, 500, @"#{@worksheet[@talkingpoint][3]}"["x"], @"#{@worksheet[@talkingpoint][3]}"["y"]
			,"sprites/character/#{@worksheet[@talkingpoint][2]}.png"]
		end
	
		@args.outputs.sprites << [10, 10, 180, 180, "sprites/character/#{@worksheet[@talkingpoint][1]}.png"]
		###content
		long_strings_split = @args.string.wrapped_lines "#{@worksheet[@talkingpoint][4]}", @max_character_length
		@args.outputs.labels << long_strings_split.map_with_index do |s, i|
		{ x: 225, y: 175 - (i * 30), text: s, size_enum: 2, r: 255, g: 255, b: 255 }
		end
	#if "#{args.state.worksheet[0][1]}" == "jump"
		#save flag and move on to next convo
	#end
	
end

#renders tiled field or static background
#TODO
def	renderField
	#TODO print tiles
	#TODO switch backgrounds based on story
	@args.outputs.sprites << [0, 0, 1280, 720, "sprites/backgrounds/background1.png"]
end

#renders UI components
#FILLER: UI can be IMPROVED, box animations, text speed
def	renderUI
	@args.outputs.sprites  << [0, 0, 1280, 210, "sprites/ui/dialogueBox.png"]
	@args.outputs.sprites  << [10, 200, 250, 50, "sprites/ui/nameBox.png"]
	renderTalk
end 

#Input Management
#see if anyone has code for remaping or using controller 
def inputCheck
  
    #check for input
	k = @args.inputs.keyboard
	
	#When in Talking mode, Space keypress moved to next Dialogue Box
	if @talking == true
		if k.key_down.space
			@talkingpoint += 1
		end
	end
	 
	#starts over the game after died or finished
	#will change to loading last save eventually
	if @gameover || @ending
		if k.key_down.space
			$gtk.reset
		end
		return
	end
	 
	#you have died
	if @gameover
		@args.outputs.labels << [ 40, 40, "Press Space to Try again"]
		return
	end
	
	#complete the Game
	if @ending
		@args.outputs.labels << [ 40, 40, "Congrats! \n Press Space to Try Again"]
		return
	end
  end


def render 
	renderField
	renderUI
end

def tick
	rpgInfo
	inputCheck
	#render is last always
	render 
end

end

#Main, calls the Game class. 
def tick args
	args.state.game ||= Game.new args
	args.state.game.tick
end