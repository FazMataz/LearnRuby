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
      @piece = King.new(self)
    when "Queen"
      @piece = Queen.new(self)
    when "Rook"
      @piece = Rook.new(self)
    when "Bishop"
      @piece = Bishop.new(self)
    when "Knight"
      @piece = Knight.new(self)
    when "Pawn"
      @piece = Pawn.new(self)
    end
  end
end

class Piece
  def initialize(square)
    @square = square
  end
end

class King
  def initialize(square)
    super()
  end
end