require "set"
ALPHABET = "abcdefgh"
ALPHABETPADDED = "zzzzzzzzzzzzabcdefghzzzzzzzzzzz"

class Board
  attr_reader :grid
  def initialize
    @grid = Hash.new(nil)
    (0..8).each do |v|
      ALPHABET.each_char do |c|
        @grid[[c, v]] = Square.new(c, v, nil, nil, self)
      end
    end
  end

  def setpiece(c, v, piece, color)
    @grid[[c, v]].genpiece(piece, color)
  end

  def move(c1, v1, c2, v2)
    piece = @grid[[c1, v1]].piece
    @grid[[c1, v1]].clear
    @grid[[c2, v2]].setpiece(piece)
  end

  def possible_moves(c, v)
    piece = @grid[[c, v]].piece
    piece.possible_moves
  end
end

class Square
  attr_reader :board, :piece, :loc
  def initialize(c, v, piece = nil, color = nil, board = nil)
    @loc = [c, v]
    @board = board
    if piece.nil?
      return
    end

    genpiece(piece, color)
  end

  def genpiece(piece, color)
    case piece
    when "King"
      @piece = King.new(self, color)
    when "Queen"
      @piece = Queen.new(self, color)
    when "Rook"
      @piece = Rook.new(self, color)
    when "Bishop"
      @piece = Bishop.new(self, color)
    when "Knight"
      @piece = Knight.new(self, color)
    when "Pawn"
      @piece = Pawn.new(self, color)
    end
  end

  def clear
    @piece = nil
  end

  def setpiece(piece)
    piece.change_location(self)
    @piece = piece
  end
end

class Piece
  attr_reader :color
  def initialize(square, color)
    @square = square
    @possible_moves = Set[]
    @distance_lim = true
    case color.downcase
    when "black" || "b"
      @color = "black"
    when "white" || "w"
      @color = "white"
    else
      raise StandardError.new "Invalid color."
    end
  end

  def to_s
    @symbol
  end

  def change_location(square)
    @square = square
  end

  def possible_moves
    if @distance_lim
      moves = @possible_moves.filter_map do |move|
        move_converted = [ALPHABETPADDED[move[0] + ALPHABETPADDED.index(@square.loc[0])], move[1] + @square.loc[1]]
        if ALPHABET.include?(move_converted[0]) && move_converted[1] >= 1 && move_converted[1] <= 8
          if @square.board.grid[move_converted].piece.nil?
            move_converted
          elsif @square.board.grid[move_converted].piece.color != @color
            move_converted
          else
            nil
          end
        end
      end
    else
      moves = @possible_moves.map do |move|
        stop = false
        (1..8).filter_map do |number|
          if stop
            nil
          end
          scaledmove = move.map{|submove| submove * number}
          newmove = [ALPHABETPADDED[scaledmove[0] + ALPHABETPADDED.index(@square.loc[0])], scaledmove[1] + @square.loc[1]]
          if @square.board.grid.key?(newmove) && !@square.board.grid[newmove].piece.nil?
            if @square.board.grid[newmove].piece.color == @color
              print "Found a same color object in #{newmove}!"
              stop = true
              nil
            else
              print "Found a different color object in #{newmove}, preventing further moves"
              stop = true
              newmove
            end
          else
            newmove if ALPHABET.include?(newmove[0]) && newmove[1] >= 1 && newmove[1] <= 8 && !stop
          end
        end
      end
      moves = moves.flatten(1).compact
    end
    moves.to_set
  end
end

class King < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1]]
    @distance_lim = true
    case color.downcase
    when "white" || "w"
      @symbol = "♔"
    when "black" || "b"
      @symbol = "♚"
    end
  end

end

class Queen < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[1, 0], [0, 1], [1, 1], [-1, 0], [0, -1], [-1, -1], [-1, 1], [1, -1]]
    @distance_lim = false
    case color.downcase
    when "white" || "w"
      @symbol = "♕"
    when "black" || "b"
      @symbol = "♛"
    end
  end
end

class Rook < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[0, 1], [1, 0], [0, -1], [-1, 0]]
    @distance_lim = false
    case color.downcase
    when "white" || "w"
      @symbol = "♖"
    when "black" || "b"
      @symbol = "♜"
    end
  end
end

class Knight < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[2, 1], [1, 2], [2, -1], [-1, 2], [-2, -1], [-1, -2], [-2, 1], [1, -2]]
    @distance_lim = true
    case color.downcase
    when "white" || "w"
      @symbol = "♘"
    when "black" || "b"
      @symbol = "♞"
    end
  end
end

class Bishop < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[1, 1], [-1, 1], [1, -1], [-1, -1]]
    @distance_lim = false
    case color.downcase
    when "white" || "w"
      @symbol = "♗"
    when "black" || "b"
      @symbol = "♝"
    end
  end
end

class Pawn < Piece
  def initialize(square, color)
    super(square, color)
    @possible_moves = Set[[0, 1]]
    @distance_lim = true
    case color.downcase
    when "white" || "w"
      @symbol = "♙"
    when "black" || "b"
      @symbol = "♟︎"
    end
  end
end