$gtk.reset
#$:.unshift(File.expand_path("mygame/nokogiri/lib"))
#require 'mygame/nokogiri'
#$:.unshift(File.expand_path("mygame/rubyzip/lib"))
#require 'mygame/rubyzip'
#$:.unshift(File.expand_path("mygame/rubyXL/lib"))
#require 'mygame/rubyXL/lib/rubyXL'


def playerList args
	args.state.player1 = {"name" => "Ashe", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player2 = {"name" => "Bob", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player3 = {"name" => "Cait", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player4 = {"name" => "Donna", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player5 = {"name" => "Ei", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
	args.state.player6 = {"name" => "Freddy", "xp" => 100, "atk" => 10, "defense" => 10, "type" => "sword"}
end

def init args

	args.state.worksheet
	playerList args



end
 

def splitTxtFiles args
	args.split("\n")
                     .reject { |line| line.start_with?('#') || line.split(' ').length == 0 } # Strip out simple comments and blank lines
                     .map { |line| line.split('#')[0] } # Strip out end of line comments
                     .map { |line| line.split("\t") } # Tokenize by splitting on tabs
end


def rpgInfo args
	#spreadsheet reading to be implemented at a later date.
	#workbook = RubyXL.Parser.parse("data/Dialogue.xlsx")
	args.state.worksheet = splitTxtFiles($gtk.read_file('/data/Dialogue.txt')).to_a
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

#renders UI components
#FILLER: UI can be IMPROVED
def	renderUI args
	args.outputs.solids  << [0, 0, 1280, 210, 100, 100, 105]
	args.outputs.solids  << [10, 200, 250, 50, 110, 110, 115]
	renderTalk args
end

#renders Background
#TODO
def	renderField args
	#renders tiled field
	#TODO print tiles
	args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
	#renders static image
	#TODO switch backgrounds based on story
	#args.outputs.sprites << [0, 0, "sprites/backgrounds/background1"]
end

#default black background
def renderBack args
	args.outputs.solids  << [0, 0, 1280, 720, 0, 0, 0]
end





def render args
	renderBack args
	renderField args
	renderUI args
end

def tick args
	init args
	rpgInfo args
	render args
	
end