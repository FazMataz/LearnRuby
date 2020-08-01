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
  def initialize(c, v, piece = nil)
    @loc = [c, v]
    @piece = piece
    case piece
    when "King"
      @piece = King.new(self, "black")
    when "Queen"
      @piece = Queen.new(self, "black")
    when "Rook"
      @piece = Rook.new(self, "black")
    when "Bishop"
      @piece = Bishop.new(self, "black")
    when "Knight"
      @piece = Knight.new(self, "black")
    when "Pawn"
      @piece = Pawn.new(self, "black")
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
end

class King < Piece
end

class Queen < Piece
end

class Rook < Piece
end

class Knight < Piece
end

class Bishop < Piece
end

class Pawn < Piece
end