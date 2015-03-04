class Hangman
	attr_accessor :chosen_letters
	def initialize
		file = File.new("dictionary.txt", "r")
		dictionary = []
		file.readlines.each do |line|
			if (line.chomp.length >= 5 && line.length<=12)
				dictionary << line
			end
		end
		@guesses_left = 6
		@word = dictionary[rand(dictionary.length)].chomp.upcase
		@chosen_letters = []
		@filtered_word = ""
		while @filtered_word.length < @word.length
			@filtered_word += "_"
		end
		play_game
	end
	
	def print_board
		puts ""
		@filtered_word.each_char do |letter|
			print letter + " "
		end
		puts ""
		puts "GUESSES LEFT: #{@guesses_left}"
	end
	
	def play_game
			print_board
			puts "Please guess a letter"
			guess = gets.chomp
			letter = guess.upcase
			verify_letter(letter)
			check_letter(letter)
	end
	
	def verify_letter(letter)
		until letter =~ /[A-Z]/
			puts "Please select a letter"
			letter = gets.chomp
		end
		
		while @chosen_letters.include? letter
			puts "You have already selected that letter. Please select another"
			letter = gets.chomp
		end
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
			puts "You have won!"
		end
	end
end

game = Hangman.new