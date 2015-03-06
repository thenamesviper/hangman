require "yaml"

class Hangman
	attr_reader :chosen_letters, :word, :guesses_left, :filtered_word, :game_name
	def initialize(name)
		file = File.new("dictionary.txt", "r")
		dictionary = []
		file.readlines.each do |line|
			if (line.chomp.length >= 5 && line.length<=12)
				dictionary << line
			end
		end
		@game_name = name
		@guesses_left = 6
		@word = dictionary[rand(dictionary.length)].chomp.upcase
		@chosen_letters = []
		@filtered_word = ""
		while @filtered_word.length < @word.length
			@filtered_word += "_"
		end
		puts self.instance_variables
		play_game
	end
	
	def print_board
		puts ""
		@filtered_word.each_char do |letter|
			print letter + " "
		end
		puts ""
		puts "GUESSES LEFT: #{@guesses_left}"
		puts ""
		puts "SELECTED LETTERS: #{@chosen_letters.sort.join(" ")}"
	end
	
	def play_game
			print_board
			puts self.chosen_letters
			puts "Please guess a letter"
			guess = gets.chomp
			letter = guess.upcase
			if letter == "SAVE"
				save_game
				puts "GAME SAVED"
				play_game
			end
			letter = verify_letter(letter)
			check_letter(letter)
	end
	
	
	private
	def save_game
		save_data = YAML::dump(self)
		Dir.mkdir("saves") unless Dir.exists? "saves"
		File.open("saves/#{game_name}.yaml", "w") { |file| file.write(save_data) }
	end
	
	def verify_letter(letter)
		verified_letter = letter = input_is_letter(letter)
		verified_letter = letter_not_chosen(verified_letter)
	end
	
	def input_is_letter(input)
		fixed_letter = input
		while !(fixed_letter =~ /[A-Z]/)
			puts "Please select a letter"
			fixed_letter = gets.chomp.upcase
		end
		fixed_letter
	end
	
	def letter_not_chosen(letter)
		fixed_letter = letter
		while @chosen_letters.include? fixed_letter
			puts "You have already selected that letter. Please select another"
			fixed_letter = gets.chomp.upcase
		end
		fixed_letter = input_is_letter(fixed_letter)
	end

	def check_letter(letter)
		i = 0
		guessed_a_letter = false
		while i<@word.length
			if letter == @word[i]
				@filtered_word[i] = letter
				guessed_a_letter = true
			end
			i += 1
		end
		@chosen_letters << letter
		if !guessed_a_letter
			@guesses_left -= 1
		end
		if !game_ended
			play_game
		else
			victory_message
		end
	end
	
	def game_ended
		over = false
		if @guesses_left == 0
			over = true
		elsif @filtered_word == @word
			over = true
		end
		over
	end		
	
	def victory_message
		if @guesses_left == 0
			puts "You have lost. The correct answer was '#{@word}'"
		else
			print_board
			puts "'#{@word}' is correct! You have won!"
		end
	end
end

class Save
	
end

def create_game
	puts "Please enter a game name. If you have a saved game, it will be loaded"
	game_name = gets.chomp
	#Load game
	if File.exist?("saves/#{game_name}.yaml")
		puts "HI"
		resume_game = (YAML::load_file("saves/#{game_name}.yaml"))
		resume_game.play_game
	else 
		Hangman.new(game_name)
	end
end
	

create_game
