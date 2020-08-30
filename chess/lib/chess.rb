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
      unfiltered = @possible_moves.map do |move|
        [ALPHABETPADDED[move[0] + ALPHABETPADDED.index(@square.loc[0])], move[1] + @square.loc[1]]
      end
    else
      unfiltered = (1..8).map do |number|
        @possible_moves.map do |move|
          move.map{|submove| submove * number}
        end
      end
      unfiltered = unfiltered.flatten(1)
      unfiltered = unfiltered.map do |move|
        [ALPHABETPADDED[move[0] + ALPHABETPADDED.index(@square.loc[0])], move[1] + @square.loc[1]]
      end
    end
    filtered = unfiltered.filter do |move|
      ALPHABET.include?(move[0]) && move[1] >= 1 && move[1] <= 8
    end
    print filtered
    filtered.to_set
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