$gtk.reset
#$:.unshift(File.expand_path("mygame/nokogiri/lib"))
#require 'mygame/nokogiri'
#$:.unshift(File.expand_path("mygame/rubyzip/lib"))
#require 'mygame/rubyzip'
#$:.unshift(File.expand_path("mygame/rubyXL/lib"))
#require 'mygame/rubyXL/lib/rubyXL'


#current way of initializing the different playable characters. Can be edited by the code/player choices.
#Needs to be saved to save files between sessions
def playerList args
	args.state.player1 ||= {"name" => "Ashe", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player2 ||= {"name" => "Bob", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player3 ||= {"name" => "Cait", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player4 ||= {"name" => "Donna", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player5 ||= {"name" => "Ei", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player6 ||= {"name" => "Freddy", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
end

#user settings, also saved between sessions
def gameSettings args
	args.state.gameMode ||= 1 #No Fight Mode
	args.state.gameLang ||= 0 #English
	args.state.gameLangAudio ||= 0#English, only flesh out in including differnt language voicelines
end

#setup
def init args

	args.state.worksheet
	args.state.gameover ||= false
	args.state.ending ||= false
	playerList args
	gameSettings args



end 
 
#method which pulls the lines of the dialouge into the game from textfile
def splitTxtFiles args
	args.split("\n")#new sets on new lines
                     .reject { |line| line.start_with?('#') || line.split(' ').length == 0 } # Strip out simple comments and blank lines
                     .map { |line| line.split('#')[0] } # Strip out end of line comments
                     .map { |line| line.split("\t") } # Tokenize by splitting on tabs
end


#uses splitTxtFiles to fill worksheet variable
#filename will need to change to make new Dialogue happen
def rpgInfo args
	args.state.worksheet = splitTxtFiles($gtk.read_file('/data/English/Dialogue.txt')).to_a
end

#renders Dialogue or worksheet intput
#args will be identifier for what conversation is going to happen
def	renderTalk args
	#name
	args.outputs.labels  << [25, 234, "#{args.state.player1["name"]}" , 2, 255, 255, 255, 255]
	#args.outputs.labels  << [25, 228, "#{playerList.(args.state.worksheet[0][0]).name}" , 2, 255, 255, 255, 255]
	###image, if included
	#if "#{args.state.worksheet[0][1]}" != "none"
		args.outputs.sprites << [10, 10, 180, 180, "sprites/character/#{args.state.worksheet[0][1]}.png"]
	#end
	###content
	args.outputs.labels  << [225, 175, "#{args.state.worksheet[0][3]}", 2, 255, 255, 255, 255]
	
end

##renders Background
#TODO
def	renderField args
	#renders tiled field
	#TODO print tiles
	#args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
	#renders static image
	#TODO switch backgrounds based on story
	args.outputs.sprites << [0, 0, 1280, 720, "sprites/backgrounds/background1.png"]
end

#renders UI components
#FILLER: UI can be IMPROVED
def	renderUI args
	args.outputs.sprites  << [0, 0, 1280, 210, "sprites/ui/dialogueBox.png"]
	args.outputs.sprites  << [10, 200, 250, 50, "sprites/ui/nameBox.png"]
	renderTalk args
end 



#default black background
def renderBack args
	args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
end

def inputCheck args
  
    #check for input
	k = args.inputs.keyboard
	 
	#starts over the game after died or finished
	if args.state.gameover || args.state.ending
		if k.key_down.space
			$gtk.reset
		end
		return
	end
	 
	#you have died
	if args.state.gameover
		args.outputs.labels << [ 40, 40, "Press Space to Try again"]
		return
	end
	
	#complete the Game
	if args.state.ending
		args.outputs.labels << [ 40, 40, "Congrats! \n Press Space to Try Again"]
		return
	end
	
	
	#TODO
	#Move to the next dialogue line
	if k.key_down.space
	end


  end



def render args
	renderBack args
	renderField args
	renderUI args
end

def tick args
	init args
	rpgInfo args
	inputCheck args
	render args
	
end