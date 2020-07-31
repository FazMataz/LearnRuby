# frozen_string_literal: true

# Class for the board that players play in
class Board
  def initialize
    @table = Array.new(3) { Array.new(3) }
  end

  public

  def move(x_coordinate, y_coordinate, player)
    play_x = x_coordinate - 1
    play_y = 3 - y_coordinate
    return false if @table[play_y][play_x] || (player != "X" && player != "O")

    @table[play_y][play_x] = player
  end

  private
  
  def check_winner()
    if @table[0] == 
  end
end

# Class for each player
class Player
  def initialize(mark)
    @score = 0
    @mark = mark unless mark != "X" && mark != "O"
  end

  def play(board, x_coordinate, y_coordinate)
    if board.move(x_coordinate, y_coordinate, @mark) == false
      puts "You can't make that move, that place is already occupied!"
      false
    else
      puts ""
    end
  end
end

new_board = Board.new
p new_board

player1 = Player.new("X")
player1.play(new_board, 1, 2)
player2 = Player.new("O")
player2.play(new_board, 1, 2)
p new_board