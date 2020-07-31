# Class for the chessboard
class Board
  attr_accessor :squares
  def initialize
    @squares = Array.new(8) {Array.new(8) {nil}}
  end

  def get_square(x, y)
    if @squares[7-y][x]
      @squares[7-y][x]
    else
      @squares[7-y][x] = Square.new(x, y, nil)
    end
  end

  def get_piece(x,y)
    @squares[7-y][x].piece
  end

  def insert_square(x, y, parent)
    if @squares[7-y][x] != nil 
      return @squares[7-y][x]
    end
    @squares[7-y][x] = Square.new(x, y, parent)
    if parent
      parent.children << @squares[7-y][x]
    end
    return @squares[7-y][x]
  end
end

# Class for a square on the chess board, has a location and holds a piece.
class Square
  attr_reader :x, :y
  attr_accessor :piece, :parent, :children
  def initialize(x, y, parent)
    @x = x
    @y = y
    @piece = nil
    @parent = parent
    @children = []
  end

  def to_s
    "[#{@x}, #{@y}]"
  end
end

# Ancestor class for various chess pieces.
class Piece
  attr_reader :directions, :dy, :dx

  def initialize(square)
    if square
      @loc = [square.x, square.y]
    else
      temp_square = board.insert_square(0, 0, nil)
      @loc = [temp_square.x, temp_square.y]
    end
    @dx = [1, 1, -1, -1, -2, 2, -2, 2]
    @dy = [-2, 2, -2, 2, 1, 1, -1, -1]
  end

  # def possible_moves(x_loc = @loc[0], y_loc = @loc[1])
  #   poss_moves = @@directions.map do |direction|
  #     [(direction[0] * @move1) + x_loc, (direction[1] * @move2) + y_loc]
  #   end
  #   poss_moves += @@directions.map do |direction|
  #     [(direction[0] * @move2) + x_loc, (direction[1] * @move1) + y_loc]
  #   end
  #   poss_moves.filter {|move| move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7}
  # end

  def knight_moves(first, last)
    visited = []
    queue = []
    queue << $board.insert_square(first[0], first[1], nil)
    path = []
    until queue.empty?
      checker = queue.shift
      visited << [checker.x, checker.y]
      if [checker.x, checker.y] == last
        final_checker = checker
      else
        directions = (@dx.zip(@dy).map {|x, y| [x + checker.x, y + checker.y]}).filter do |x, y|
          x <= 7 && x >= 0 && y >= 0 && y <= 7 && !visited.include?([x, y])
        end
        queue += directions.map {|direction| $board.insert_square(direction[0], direction[1], checker)}
      end
    end
    until final_checker.parent.nil?
      path << [final_checker.x, final_checker.y]
      final_checker = final_checker.parent
    end
    path << first
    p path
    p "You made it in #{path.length - 2} moves, here's your path:"
    return path.to_s.gsub("]," , "] =>").slice(1..-2)
  end
end

# Knight class, has specific moveset 
class Knight < Piece
  def initialize(square)
    super(square)
    @loc = [square.x, square.y]
    @move1 = 2
    @move2 = 1
    @maxmove = 3
  end
end

$board = Board.new

knight = Knight.new($board.get_square(0, 0))

p knight.knight_moves([3, 3], [4, 3])