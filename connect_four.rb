
# clears the command prompt screen
class System
	def self.clear
		puts "\e[H\e[2J"
	end
end

class Board

	attr_accessor :player_turn, :board

	def initialize
		# makes a blank 7x7 array of zeroes
		@board = []
		7.times{@board << Array.new([0] * 7)}
		# 1 = player one
		# 2 = player two
		@player_turn = 1
	end

	# TODO test if place piece is valid 

	def place_piece(selected_col)
		# this is to set it so if that if the
		# user selects, say, column 1, the selected
		# col will be index 0
		selected_col -= 1
		bottom_row = 6
		bottom_row.downto(0) do |row|
			if @board[row][selected_col] == 0
				@board[row][selected_col] = @player_turn
				break
			end
		end
	end

	def draw_board
		# draws numbers up top
		puts '| ' + (1..7).to_a.join(' | ') + ' |'

		length_of_board = 29
		puts '~' * length_of_board

		@board.each do |row|
			replaced_row = row.map do |e| 
				# this turns the zeroes into the array into
				# blank spaces
				# if there is a 1 it turns that into an X
				# and if there is a 2 it turns that into 0
				e = e.zero? ? ' ' : e == 1 ? 'X' : '0'
			end
			puts '| ' + replaced_row.join(' | ') + ' |'
		end
	end

	def is_legal_move?(selected_col)
		if selected_col < 1 || selected_col > 7
			return false
		end
		# checks the top of the column and if the top
		# of the column is not zero then that column
		# is full
		return false if @board[0][selected_col-1] != 0
		true
	end

	def game_over?
		@board.each_with_index do |row, row_index|
			row.each_with_index do |piece, col_index|
				if piece == 1 || piece == 2
					if is_game_over_given_row_and_col(row_index, col_index)
						return true
					end
				end
			end
		end
		false
	end

	# checks top row for any zeroes
	# (aka blank spaces). If the top
	# row has no blank spots, the game
	# is tied
	def is_tie_game?
		!@board[0].include?(0)
	end

	private

	def is_game_over_given_row_and_col(row, col)
		(-1..1).each do |change_in_row|
			(-1..1).each do |change_in_col|
				# is_game_over_given_change 
				# takes the position of the
				# row and col and branches it out in all
				# directions with the change_in_row/col
				# numbers
				if !(change_in_row.zero? && change_in_col.zero?) && 
					 is_game_over_given_change(row, col, 
										 change_in_row, change_in_col)
					return true
				end
			end
		end
		false
	end

	def is_game_over_given_change(row, col,
																change_in_row, change_in_col)
		4.times do
			return false if out_of_bounds?(row, col)
			return false if @board[row][col] != @player_turn
			row += change_in_row
			col += change_in_col
		end
		true
	end

	def out_of_bounds?(row, col)
		if row > 6 || row < 0 || col > 6 || col < 0
			return true
		else return false
		end
	end

end


def get_user_input(board)
	puts "Enter which column you would like to place: "
	placement = gets.chomp.to_i
	while !board.is_legal_move?(placement)
		placement = gets.chomp.to_i
	end
	return placement
end

def start_game(board)
	board.draw_board
	while true
		puts "Player #{board.player_turn}'s turn"
		placement = get_user_input(board)
		board.place_piece(placement)
		System.clear
		board.draw_board
		break if board.game_over? || board.is_tie_game?
		board.player_turn = board.player_turn == 1 ? 2 : 1
	end
	puts_end_results(board)
end

def puts_end_results(board)
	if board.game_over?
		puts "Player #{board.player_turn} won"
	else
		puts "Tie game"
	end
end

System.clear
board = Board.new
start_game(board)