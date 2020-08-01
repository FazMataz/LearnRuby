class Board
  attr_reader :grid
  def initialize
    @grid = Hash.new(nil)
    (0..8).each do |v|
      "abcdefgh".each_char do |c|
        @grid[[c, v]] = Square.new(c, v)
      end
    end
  end
end

class Square
  attr_reader :piece
  def initialize(c, v, piece = nil, color = nil)
    @loc = [c, v]
    if piece.nil?
      return
    end

    @piece = piece
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
end

class Piece
  attr_reader :color
  def initialize(square, color)
    @square = square
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
end

class King < Piece
  def initialize(square, color)
    super(square, color)
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
    case color.downcase
    when "white" || "w"
      @symbol = "♙"
    when "black" || "b"
      @symbol = "♟︎"
    end
  end
end