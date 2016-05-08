require 'rspec'
require_relative '../connect_four'

describe 'Board' do

	before do
		@board = Board.new
		# used to create a blank board
		@test_board = []
		7.times{@test_board << Array.new([0] * 7)}
	end

	describe 'place_piece' do
		context 'blank board' do
			before do
				@test_board[6][1] = 1
				@board.place_piece(2)
			end

			it 'allows first player to place in second column' do
				expect(@board.board).to eq(@test_board)
			end
		end

		context 'with a second player represented by 2' do
			before do
				@test_board[6][1] = 1
				@test_board[5][1] = 2
				@board.place_piece(2)
				@board.place_piece(2)
			end

			it 'should allow player two to place in second column' do
				expect(@board.board).to eq(@test_board)
			end
		end

		context 'piece stacks on top of another piece' do
			before do
				# places two pieces on top of each other
				# on the test board
				@test_board[6][1] = 1
				@test_board[5][1] = 2
				@board.place_piece(2)
				@board.place_piece(2)
			end

			it 'should stack piece on top of already placed piece' do
				expect(@board.board).to eq(@test_board)
			end
		end

		context 'tries to place piece on top of full column' do
			before do
				# stacks the 1 piece fully in the 3rd column
				@board.board.each{|row| row[2] = 1}
				@board.place_piece(3)
				@test_board.each{|row| row[2] = 1}
			end

			it 'should not change board when player places on full column' do
				expect(@board.board).to eq(@test_board)
			end
		end
	end

	describe 'game_over?' do

		context 'not game over' do

			it 'should not have game over with a blank board' do
				expect(@board.game_over?).to eq(false)
			end
		end

		context 'is a horizontel win' do
			before do
				# puts 4 pieces on the bottom left
				# of the board
				bottom_row = 6
				(0..3).each do |index|
					@board.board[bottom_row][index] = 1
				end
			end

			it 'should give game over' do
				expect(@board.game_over?).to eq(true)
			end
		end

		context 'is a verticle win' do
			before do
				# puts 4 pieces vertically in the
				# first column
				left_side = 0
				(3..6).each do |index|
					@board.board[index][left_side] = 1
				end
			end

			it 'should give game over' do
				expect(@board.game_over?).to eq(true)
			end
		end

		context 'is a diagonal win' do
			# fills up a diagonal starting from
			# column 4 and going to the first
			# column
			before do
				6.downto(3) do |row|
					# makes col 3, 2, 1, and 0
					col = row - 4
					@board.board[row][col] = 1
				end
			end

			it 'should have game over' do
				expect(@board.game_over?).to eq(true)
			end
		end
	end
end